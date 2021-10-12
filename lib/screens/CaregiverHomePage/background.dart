import 'dart:async';

import 'package:botapp/constants.dart';
import 'package:botapp/screens/ReminderList/reminder_list_screen.dart';
import 'package:botapp/screens/Upload/upload_screen.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    required key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final TimeController timeController =
        Get.put<TimeController>(TimeController());
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: 0.3 * size.height,
                width: 0.25 * size.width,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset(
                    "assets/fadedsun.png",
                    width: size.width,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(50, 25, 0, 10),
                child: Text(
                  "This week in a view",
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: kPrimaryColor),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(0, 25, 1 / 8 * size.width + 30, 10),
                child: Obx(
                  () => Text(
                    DateFormat('E hh:mm a')
                        .format(timeController.currentTime.value),
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: kPrimaryColor),
                  ),
                ),
              ),
            ),
            child,
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SecondaryButton(
                      text: "Notifications",
                      color: Colors.white60,
                      key: UniqueKey(),
                      widthRatio: 0.3,
                      press: () {
                        Get.to(() => ReminderListScreen());
                      }),
                  SecondaryButton(
                      text: "Upload",
                      key: UniqueKey(),
                      color: Colors.white60,
                      widthRatio: 0.25,
                      press: () {
                        Get.to(() => UploadScreen());
                      }),
                ],
              ),
            ),
            AppHeader(
                key: key,
                hasLogOut: true,
                hasBackButton: false,
                child: Container()),
          ],
        ),
      ),
    );
  }
}

class TimeController extends GetxController {
  var currentTime = DateTime.now().obs;
  @override
  void onInit() {
    _updateTime();
    super.onInit();
  }

  void _updateTime() {
    currentTime.value = DateTime.now();
    // Update once per second. Make sure to do it at the beginning of each
    // new second, so that the clock is accurate.
    Timer(
      Duration(seconds: 1) -
          Duration(milliseconds: currentTime.value.millisecond),
      _updateTime,
    );
  }
}
