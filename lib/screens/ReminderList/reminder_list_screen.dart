import 'package:botapp/constants.dart';
import 'package:botapp/controllers/reminder_controller.dart';
import 'package:botapp/controllers/user_controller.dart';
import 'package:botapp/models/user.dart';
import 'package:botapp/screens/ReminderAdd/reminder_add_screen.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/zero_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReminderListScreen extends StatelessWidget {
  const ReminderListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
      body: AppHeader(
        key: UniqueKey(),
        hasLogOut: true,
        hasBackButton: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(50, 15, 0, 10),
                    child: Text(
                      "Notifications",
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: kPrimaryColor),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 150, 10),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: kPrimaryColor,
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.to(() => ReminderAddScreen());
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Obx(
              () => reminderController.isLoading.value
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : reminderController.reminderList.length == 0
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 0.05 * size.height,
                              ),
                              ZeroResult(
                                  text: "There is no upcoming notifications...")
                            ],
                          ),
                        )
                      : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
