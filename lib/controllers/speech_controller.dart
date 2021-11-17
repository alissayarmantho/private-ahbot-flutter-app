import 'dart:math';
import 'dart:async';

import 'package:botapp/controllers/audio_controller.dart';
import 'package:botapp/controllers/auth_controller.dart';
import 'package:botapp/controllers/notification_controller.dart';
import 'package:botapp/controllers/user_controller.dart';
import 'package:botapp/screens/Contact/contact_screen.dart';
import 'package:botapp/screens/Gallery/gallery_screen.dart';
import 'package:botapp/screens/MusicPlayer/music_player_screen.dart';
import 'package:botapp/screens/PoseNet/posenet_screen.dart';
import 'package:botapp/screens/RobotHomePage/robot_home_page.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechController extends GetxController {
  var hasInitSpeech = false.obs;
  bool _logEvents = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  var lastWords = ''.obs;
  var lastError = ''.obs;
  var lastStatus = ''.obs;
  var hasCommand = false.obs;
  String _currentLocaleId = '';
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();
  final random = new Random();
  late Timer timer;
  late Timer activityTimer;

  @override
  void onInit() async {
    super.onInit();
    initSpeechState();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => startListening());
    activityTimer = Timer.periodic(Duration(seconds: 30),
        (Timer t) => {if (hasCommand.value) hasCommand.value = false});
  }

  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: true,
        finalTimeout: Duration(milliseconds: 0));
    if (hasSpeech) {
      // Get the list of languages installed on the supporting platform so they
      // can be displayed in the UI for selection by the user.
      _localeNames = await speech.locales();
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale?.localeId ?? '';
    }

    hasInitSpeech.value = hasSpeech;
  }

  // This is called each time the users wants to start a new speech
  // recognition session
  void startListening() {
    _logEvent('start listening');
    lastWords.value = '';
    lastError.value = '';
    // Note that `listenFor` is the maximum, not the minimun, on some
    // recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    // When music is playing, speech to text will not work so that
    // music playing is not interrupted
    if (Get.find<AuthController>().isLoggedIn.value) if (hasInitSpeech.value &&
        !Get.find<AudioController>().isPlaying.value &&
        Get.find<UserController>().currentUser.value.accountType != "caregiver")
      speech
          .listen(
              onResult: resultListener,
              listenFor: Duration(seconds: 30),
              pauseFor: Duration(seconds: 5),
              partialResults: true,
              localeId: _currentLocaleId,
              onSoundLevelChange: soundLevelListener,
              cancelOnError: false,
              listenMode: ListenMode.confirmation)
          .onError((error, stackTrace) => print(error));
  }

  void stopListening() {
    _logEvent('stop');
    speech.stop();
    level = 0.0;
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    level = 0.0;
  }

  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  Future<void> resultListener(SpeechRecognitionResult result) async {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    lastWords.value = '${result.recognizedWords}';
    if (!Get.find<AuthController>().isLoggedIn.value) lastWords.value = "";
    if (result.finalResult)
      // This method will give an error when user wanna navigate from other pages
      // besides the home page, sometimes it will cause dirty state update
      // TODO: Find out how to fix it
      switch (lastWords.value) {
        case 'gallery':
        case 'photo':
        case 'open gallery':
        case 'open photos':
        case 'see photos':
        case 'open photo':
        case 'see photo':
        case 'opengallery':
        case 'openphoto':
        case 'openphotos':
        case 'seephoto':
        case 'seephotos':
        case 'play photo':
        case 'show photo':
        case 'show random photo':
          {
            hasCommand.value = true;
            Get.back();
            Get.back();
            Get.back();
            // 3 times because that's the max stack you can have when on
            // the robot side of the app this is a hack done widely in the codebase
            // to avoid dirty state rendering and error
            // TODO: Find a way to fix this
            Future.delayed(Duration(seconds: 1), () {
              Get.to(() => GalleryScreen());
            });
          }
          break;
        case 'open contact':
        case 'open contact book':
        case 'open contact':
        case 'open contacts':
        case 'opencontact':
        case 'opencontactbook':
        case 'open contact books':
        case 'see contact':
        case 'see contacts':
        case 'seecontacts':
        case 'seecontact':
        case 'contacts':
        case 'contact':
          {
            hasCommand.value = true;
            Get.back();
            Get.back();
            Get.back();
            // 3 times because that's the max stack you can have when on
            // the robot side of the app this is a hack done widely in the codebase
            // to avoid dirty state rendering and error
            // TODO: Find a way to fix this
            Future.delayed(Duration(seconds: 1), () {
              Get.to(() => ContactScreen());
            });
          }
          break;
        case 'play music':
        case 'play random music':
        case 'play some music':
        case 'open music':
        case 'open musics':
        case 'listen to music':
        case 'music':
          {
            hasCommand.value = true;
            Get.back();
            Get.back();
            Get.back();
            // 3 times because that's the max stack you can have when on
            // the robot side of the app this is a hack done widely in the codebase
            // to avoid dirty state rendering and error
            // TODO: Find a way to fix this
            Future.delayed(Duration(seconds: 1), () {
              Get.to(() => MusicPlayerScreen());
            });
          }
          break;

        case 'back':
        case 'go back':
          {
            hasCommand.value = true;
            Get.back();
          }
          break;

        case 'close':
        case 'go back to homepage':
        case 'go back home':
        case 'homepage':
          {
            hasCommand.value = true;
            Get.to(() => RobotHomePage());
          }
          break;

        case 'ahbot come here':
        case 'ah bot come here':
        case 'abot come here':
        case 'bot come here':
        case 'robot come here':
          {
            hasCommand.value = true;
            Get.find<NotificationController>().goToElder();
          }
          break;

        case 'robot go home':
        case 'ahbot go home':
        case 'bot go home':
        case 'abot go home':
        case 'ah bot go home':
          {
            hasCommand.value = true;
            Get.find<NotificationController>().goToCharger();
          }
          break;

        case "camera":
          {
            Future.delayed(Duration(seconds: 2), () {
              Get.to(() => PosenetScreen());
            });
          }
          break;
      }
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    this.level = level;
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');
    lastError.value = error.errorMsg;
    initSpeechState();
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');
    lastStatus.value = status;
  }

  void switchLang(selectedVal) {
    _currentLocaleId = selectedVal;
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      print('$eventTime $eventDescription');
    }
  }
}
