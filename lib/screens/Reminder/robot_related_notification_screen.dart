import 'dart:math';

import 'package:botapp/controllers/notification_controller.dart';
import 'package:botapp/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RobotRelatedNotificationScreen extends StatelessWidget {
  final String text;
  final String type;
  const RobotRelatedNotificationScreen(
      {Key? key, required this.text, this.type = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final imagePaths = [
      'assets/cutefaces/blush.png',
      'assets/cutefaces/excited.png',
      'assets/cutefaces/yay.png',
      'assets/cutefaces/smile.png',
      'assets/cutefaces/smug.png',
      'assets/cutefaces/owo.png',
      'assets/cutefaces/uwu.png'
    ];
    final NotificationController notificationController =
        Get.find<NotificationController>();
    final random = new Random();
    int randomNumber = random.nextInt(7);
    return Container(
      color: Colors.white,
      child: Center(
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
            Container(
              width: size.width * 0.75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color.fromRGBO(224, 243, 255, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(4, 7), // changes position of shadow
                    ),
                  ]),
              padding: EdgeInsets.fromLTRB(40, 40, 40, 40),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  decoration: TextDecoration.none,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 0.05 * size.height,
            ),
            Obx(
              () => notificationController.hasPutDown.value
                  ? SecondaryButton(
                      text: "Done!",
                      color: Color.fromRGBO(219, 255, 234, 1),
                      borderColor: Color.fromRGBO(14, 206, 125, 1),
                      textColor: Color.fromRGBO(14, 206, 125, 1),
                      key: UniqueKey(),
                      widthRatio: 0.3,
                      press: () {
                        if (type == "unreachableStation") {
                          notificationController.goToCharger();
                        }
                        Get.back();
                      })
                  : Container(), // Else don't show the button to go back
            ),
          ],
        ),
      ),
    );
  }
}
