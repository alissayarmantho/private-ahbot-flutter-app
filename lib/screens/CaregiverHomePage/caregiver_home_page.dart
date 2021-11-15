import 'package:botapp/controllers/reminder_controller.dart';
import 'package:botapp/controllers/user_controller.dart';
import 'package:botapp/models/user.dart';
import 'package:botapp/widgets/home_page_notification_card.dart';
import 'package:flutter/material.dart';
import 'package:botapp/screens/CaregiverHomePage/background.dart';
import 'package:botapp/widgets/custom_icon_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CaregiverHomePage extends StatelessWidget {
  const CaregiverHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User currentUser = Get.find<UserController>().currentUser.value;
    // Assume that elderId is inherited from upload screen that had just fetched
    // it
    var elderId = currentUser.elderIds.length > 0
        ? currentUser.elderIds[0]
        // This will trigger an error as there is
        // no elder linked to the current caregiver
        // Currently it will default to uploading music
        // for potato
        : "61547e49adbc3d0023ab129c";
    final ReminderController reminderController =
        Get.put<ReminderController>(ReminderController());
    reminderController.fetchAllReminders(elderId: elderId);
    return Scaffold(
      body: Background(
        key: UniqueKey(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CustomIconButton(
                  key: UniqueKey(),
                  hasTitle: true,
                  hasDescription: true,
                  title: "45",
                  description: "mins",
                  svgAssetPath: 'assets/icons/music.svg',
                  press: () {
                    // Get.to(() => MusicPlayerScreen());
                  },
                ),
                CustomIconButton(
                  key: UniqueKey(),
                  hasTitle: true,
                  hasDescription: true,
                  title: "1.5",
                  description: "hours",
                  svgAssetPath: 'assets/icons/photos.svg',
                  press: () {
                    // Get.to(() => GalleryScreen());
                  },
                ),
                CustomIconButton(
                  key: UniqueKey(),
                  hasTitle: true,
                  hasDescription: true,
                  title: "21",
                  description: "hours",
                  svgAssetPath: 'assets/icons/contact.svg',
                  press: () {
                    // launch('tel:0');
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [Colors.transparent, Colors.black],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Container(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Obx(
                    () => reminderController.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : reminderController.reminderList.length == 0
                            ? HomePageNotificationCard(
                                startTime: "😊",
                                title: "There is no notification for today",
                                icon: Icons.celebration,
                              )
                            : (ListView.builder(
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 80),
                                itemCount:
                                    reminderController.reminderList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String reminderType = reminderController
                                      .reminderList[index].reminderType;
                                  IconData icon;
                                  switch (reminderType) {
                                    case "appointment":
                                      {
                                        icon = Icons.calendar_today;
                                      }
                                      break;
                                    case "birthday":
                                      {
                                        icon = Icons.cake;
                                      }
                                      break;
                                    case "call":
                                      {
                                        icon = Icons.call;
                                      }
                                      break;
                                    case "medication":
                                      {
                                        icon = Icons.medication;
                                      }
                                      break;
                                    case "other":
                                    default:
                                      {
                                        icon = Icons.notifications;
                                      }
                                      break;
                                  }
                                  return HomePageNotificationCard(
                                    startTime: DateFormat.Hm().format(
                                        reminderController.reminderList[index]
                                            .eventStartTime),
                                    title: reminderController
                                                .reminderList[index]
                                                .title
                                                .length >
                                            50
                                        ? reminderController
                                                .reminderList[index].title
                                                .substring(0, 50) +
                                            "..."
                                        : reminderController
                                            .reminderList[index].title,
                                    icon: icon,
                                  );
                                })),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
