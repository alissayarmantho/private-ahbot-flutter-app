import 'dart:math';

import 'package:botapp/constants.dart';
import 'package:botapp/controllers/reminder_controller.dart';
import 'package:botapp/screens/Contact/contact_screen.dart';
import 'package:botapp/screens/Gallery/gallery_screen.dart';
import 'package:botapp/screens/MusicPlayer/music_player_screen.dart';
import 'package:botapp/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReminderScreen extends StatelessWidget {
  final String text;
  final ReminderController? reminderController;
  final String promptType; // contact, gallery, music
  final bool isPrompt;
  final bool isCall;
  const ReminderScreen({
    Key? key,
    required this.text,
    required this.isPrompt,
    required this.isCall,
    this.reminderController,
    // This shouldn't be called unless this screen is a prompt screen
    this.promptType = "",
  }) : super(key: key);

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

    final random = new Random();
    int randomNumber = random.nextInt(7);
    return SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.white,
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
                child: isPrompt || isCall
                    ? Text(text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          decoration: TextDecoration.none,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                        ))
                    : Obx(
                        () => Text(
                            reminderController!.isLoading.value
                                ? "Fetching reminder..."
                                : reminderController!
                                            .activeReminder.value.title.length >
                                        50
                                    ? reminderController!
                                            .activeReminder.value.title
                                            .substring(0, 50) +
                                        "..."
                                    : reminderController!
                                        .activeReminder.value.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              decoration: TextDecoration.none,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            )),
                      ),
              ),
              SizedBox(
                height: 0.05 * size.height,
              ),
              if (isCall)
                CallNotificationButtons()
              else
                !isPrompt
                    ? Obx(
                        () => reminderController!.isLoading.value
                            ? Expanded(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : NotificationPromptButtons(
                                isPrompt: isPrompt,
                                promptType: promptType,
                                reminderId:
                                    reminderController!.activeReminder.value.id,
                                reminderController: reminderController,
                              ),
                      )
                    : NotificationPromptButtons(
                        isPrompt: isPrompt,
                        promptType: promptType,
                        reminderController: reminderController,
                      ),
            ],
          ),
        ),
      ),
    );
  }
}

class CallNotificationButtons extends StatelessWidget {
  const CallNotificationButtons({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: size.width * 0.3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    primary: Color.fromRGBO(14, 206, 125, 1),
                    backgroundColor: Color.fromRGBO(219, 255, 234, 1),
                    side: BorderSide(
                        color: Color.fromRGBO(14, 206, 125, 1), width: 5),
                    padding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
                onPressed: () {
                  Get.back();
                },
                child:
                    Icon(Icons.call, color: Color.fromRGBO(111, 207, 151, 1))),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: size.width * 0.3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    primary: Color.fromRGBO(250, 60, 112, 1),
                    backgroundColor: Color.fromRGBO(255, 180, 202, 1),
                    side: BorderSide(
                        color: Color.fromRGBO(250, 60, 112, 1), width: 5),
                    padding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
                onPressed: () {
                  Get.back();
                },
                child: Icon(Icons.call_end,
                    color: Color.fromRGBO(250, 60, 112, 0.7))),
          ),
        ),
      ],
    );
  }
}

class NotificationPromptButtons extends StatelessWidget {
  final ReminderController? reminderController;
  final String reminderId;
  final String promptType;
  const NotificationPromptButtons({
    Key? key,
    this.reminderController,
    this.reminderId = "",
    this.promptType = "",
    required this.isPrompt,
  }) : super(key: key);

  final bool isPrompt;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SecondaryButton(
            text: isPrompt ? "Yes, sure!" : "Done!",
            height: 100,
            color: isPrompt
                ? Colors.transparent
                : Color.fromRGBO(219, 255, 234, 1),
            borderColor:
                isPrompt ? kPrimaryColor : Color.fromRGBO(14, 206, 125, 1),
            textColor:
                isPrompt ? kPrimaryColor : Color.fromRGBO(14, 206, 125, 1),
            key: UniqueKey(),
            widthRatio: 0.3,
            press: () {
              if (!isPrompt) {
                // if not a prompt, this should be a reminder so reminderController
                // shouldn't be null
                reminderController!.updateReminderStatus(
                    reminderId: reminderId, status: 'completed');
                Get.back();
              } else {
                switch (promptType) {
                  case "contact":
                    {
                      // So that the back button will be to the original page
                      // and not to the notif page
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
                  case "gallery":
                    {
                      // So that the back button will be to the original page
                      // and not to the notif page
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
                  case "music":
                    {
                      // So that the back button will be to the original page
                      // and not to the notif page
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
                  default:
                    {
                      Get.back();
                    }
                    break;
                }
              }
            }),
        SecondaryButton(
            text: isPrompt ? "Nope, let's do something else" : "Don't need",
            key: UniqueKey(),
            height: 100,
            color: isPrompt
                ? Colors.transparent
                : Color.fromRGBO(255, 180, 202, 1),
            borderColor:
                isPrompt ? kPrimaryColor : Color.fromRGBO(250, 60, 112, 1),
            textColor:
                isPrompt ? kPrimaryColor : Color.fromRGBO(250, 60, 112, 1),
            widthRatio: 0.3,
            press: () {
              if (!isPrompt) {
                // I assume missed as don't need
                // if not a prompt, this should be a reminder so reminderController
                // shouldn't be null
                reminderController!.updateReminderStatus(
                    reminderId: reminderId, status: 'missed');
                Get.back();
              } else {
                Get.back();
              }
            }),
      ],
    );
  }
}
