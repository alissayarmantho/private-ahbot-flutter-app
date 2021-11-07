import 'dart:async';

import 'package:botapp/controllers/auth_controller.dart';
import 'package:botapp/controllers/notification_controller.dart';
import 'package:botapp/screens/RobotHomePage/robot_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wakelock/wakelock.dart';

import 'constants.dart';
import 'controllers/audio_controller.dart';
import 'controllers/bindings/initial_binding.dart';
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
    SystemChrome.setEnabledSystemUIOverlays([]);
    Wakelock.enable();
    return GetMaterialApp(
      title: 'Ahbot App',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
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

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  void _goToCharger() {
    if (Get.find<AuthController>()
        .isLoggedIn
        .value) if (Get.find<UserController>()
            .currentUser
            .value
            .accountType !=
        "caregiver") Get.find<NotificationController>().goToCharger();
  }

  void _initializeTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(minutes: 5), _goToCharger);
  }

  void _handleUserInteraction([_]) {
    _initializeTimer();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      child: Obx(() {
        var userController = Get.find<UserController>();
        // Just to initialise speech and notification controller
        Get.find<SpeechController>();
        Get.find<NotificationController>();
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
