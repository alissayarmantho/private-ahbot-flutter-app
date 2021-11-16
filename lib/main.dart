import 'dart:async';
import 'dart:math';

import 'package:botapp/controllers/auth_controller.dart';
import 'package:botapp/controllers/media_controller.dart';
import 'package:botapp/controllers/notification_controller.dart';
import 'package:botapp/screens/Contact/contact_screen.dart';
import 'package:botapp/screens/Gallery/gallery_screen.dart';
import 'package:botapp/screens/MusicPlayer/music_player_screen.dart';
import 'package:botapp/screens/Reminder/reminder_screen.dart';
import 'package:botapp/screens/ReminderList/reminder_list_screen.dart';
import 'package:botapp/screens/RobotHomePage/robot_home_page.dart';
import 'package:botapp/screens/Upload/upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wakelock/wakelock.dart';

import 'constants.dart';
import 'controllers/audio_controller.dart';
import 'controllers/bindings/initial_binding.dart';
import 'controllers/contact_controller.dart';
import 'controllers/speech_controller.dart';
import 'controllers/user_controller.dart';
import 'models/user.dart';
import 'screens/CaregiverHomePage/caregiver_home_page.dart';
import 'screens/Launch/launch_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BotApp());
}

class BotApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Wakelock.enable();
    return GetMaterialApp(
      title: 'Ahbot App',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      getPages: [
        // I should be using this named vers if I want to do a pop until named
        // TODO: Use named pages routing way
        GetPage(name: '/robot-home', page: () => RobotHomePage()),
        GetPage(name: '/caregiver-home', page: () => CaregiverHomePage()),
        GetPage(name: '/gallery', page: () => GalleryScreen()),
        GetPage(name: '/music', page: () => MusicPlayerScreen()),
        GetPage(name: "/contact", page: () => ContactScreen()),
        GetPage(name: '/upload', page: () => UploadScreen()),
      ],
      theme: ThemeData(
          fontFamily: 'Montserrat',
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'Montserrat',
                fontSizeFactor: 1.5,
              ),
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.blue,
          primaryColor: kPrimaryColor,
          accentColor: kPrimaryLightColor),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  Timer? _timer;

  late Random random;
  @override
  void initState() {
    super.initState();
    random = new Random();
    _initializeTimer();
  }

  void _goToCharger() {
    // The check to prevent caregiver accounts from sending goToCharger req
    // is here. Notification Controller does no check on whether the request is
    // coming from elder acc or caregiver acc
    if (Get.find<AuthController>()
        .isLoggedIn
        .value) if (Get.find<UserController>()
            .currentUser
            .value
            .accountType !=
        "caregiver") {
      _handleUserInteraction();
      Get.find<NotificationController>().goToCharger();
    }
  }

  void _sendPrompt() {
    // The check to prevent caregiver accounts from sending goToCharger req
    // is here. Notification Controller does no check on whether the request is
    // coming from elder acc or caregiver acc
    if (Get.find<AuthController>()
        .isLoggedIn
        .value) if (Get.find<UserController>()
            .currentUser
            .value
            .accountType !=
        "caregiver") {
      int randomNumber = random.nextInt(3);
      String sendingPromptType = promptType[randomNumber];
      _handleUserInteraction();
      Timer(const Duration(minutes: 5), _goToCharger);
      Get.to(
        () => ReminderScreen(
          text: promptText[randomNumber],
          isPrompt: true,
          isCall: false,
          promptType: sendingPromptType,
        ),
      );
    }
  }

  void _initializeTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(minutes: 5), _sendPrompt);
  }

  void _handleUserInteraction([_]) {
    print("handling user interaction");
    _initializeTimer();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Idling is currently only when the user is in the homepage and doesn't click
    // or do voice commands (other pages don't check for idle)
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      child: Obx(() {
        var userController = Get.find<UserController>();

        var speechController = Get.find<SpeechController>();
        if (speechController.hasCommand.value) {
          _handleUserInteraction();
        }
        // Just to initialise all controllers
        Get.find<NotificationController>();
        Get.find<MediaController>();
        Get.find<ContactController>();
        if (Get.find<AuthController>().isLoggedIn.value) {
          if (userController.currentUser.value == User.nullUser) {
            userController.fetchUser();
            // To always get a new AudioPlayer after logging in
            Get.find<AudioController>().setCurrPlayer(AudioPlayer());
            // initialize the listener to listen to the AudioPlayer added
            Get.find<AudioController>()
                .initializeListeningAfterSettingCurrPlayer();
          }
          if (!userController.isLoading.value) {
            User currentUser = userController.currentUser.value;
            if (currentUser.accountType == "caregiver") {
              return CaregiverHomePage();
            } else {
              // only when the user is elderly will there be notifications and
              // speech recognition
              Get.find<NotificationController>()
                  .setElderId(newElderId: currentUser.id);
              return RobotHomePage();
            }
          }
          return Container(
            width: size.width,
            height: size.height,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return LaunchScreen();
        }
      }),
    );
  }
}
