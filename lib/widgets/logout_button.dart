import 'package:botapp/constants.dart';
import 'package:botapp/controllers/audio_controller.dart';
import 'package:botapp/controllers/auth_controller.dart';
import 'package:botapp/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class LogoutButton extends GetWidget<AuthController> {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: kPrimaryLightColor,
      iconSize: 35,
      icon: const Icon(Icons.logout),
      tooltip: 'Log out',
      onPressed: () {
        Get.find<UserController>().removeCurrentUser();
        // Remove previous currPlayer audio player instance
        Get.find<AudioController>().currPlayer.value.dispose();
        controller.logout();
      },
    );
  }
}
