import 'package:botapp/controllers/notification_controller.dart';
import 'package:botapp/screens/Contact/contact_screen.dart';
import 'package:botapp/screens/Gallery/gallery_screen.dart';
import 'package:botapp/screens/MusicPlayer/music_player_details.dart';
import 'package:botapp/screens/MusicPlayer/music_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:botapp/screens/RobotHomePage/background.dart';
import 'package:botapp/widgets/custom_icon_button.dart';
import 'package:get/get.dart';
import 'dart:math';

class RobotHomePage extends StatelessWidget {
  const RobotHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final NotificationController notificationController =
        Get.put<NotificationController>(NotificationController());
    final imagePaths = [
      'assets/cutefaces/blush.png',
      'assets/cutefaces/excited.png',
      'assets/cutefaces/yay.png',
      'assets/cutefaces/smile.png',
      'assets/cutefaces/smug.png',
      'assets/cutefaces/uwu.png'
    ];
    final random = new Random();
    int randomNumber = random.nextInt(6);
    return Scaffold(
      body: Background(
        key: UniqueKey(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 0.4 * size.width,
                height: 0.4 * size.height,
                child: Image.asset(
                  imagePaths[randomNumber],
                ),
              ),
              SizedBox(
                height: 0.05 * size.height,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CustomIconButton(
                    key: UniqueKey(),
                    svgAssetPath: 'assets/icons/music.svg',
                    hasTitle: false,
                    hasDescription: false,
                    press: () {
                      Get.to(() => MusicPlayerScreen());
                    },
                  ),
                  CustomIconButton(
                    key: UniqueKey(),
                    hasTitle: false,
                    hasDescription: false,
                    svgAssetPath: 'assets/icons/photos.svg',
                    press: () {
                      Get.to(() => GalleryScreen());
                    },
                  ),
                  CustomIconButton(
                    key: UniqueKey(),
                    hasTitle: false,
                    hasDescription: false,
                    svgAssetPath: 'assets/icons/contact.svg',
                    press: () {
                      Get.to(() => ContactScreen());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
