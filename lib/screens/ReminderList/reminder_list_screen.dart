import 'package:botapp/constants.dart';
import 'package:botapp/models/reminder.dart';
import 'package:botapp/screens/ReminderAdd/reminder_add_screen.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/zero_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReminderListScreen extends StatelessWidget {
  final List<Reminder> reminderList;
  const ReminderListScreen({Key? key, required this.reminderList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
            reminderList.length == 0
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
                : Container(child: Text("Hello")),
          ],
        ),
      ),
    );
  }
}
