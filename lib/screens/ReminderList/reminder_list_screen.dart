import 'package:botapp/constants.dart';
import 'package:botapp/models/reminder.dart';
import 'package:botapp/screens/ReminderAdd/reminder_add_screen.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/reminder_list_notification_card.dart';
import 'package:botapp/widgets/zero_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Currently this will only lists the notifications today
// TODO: Check if want to display all notifs and adjust
// This also does not support editing
// TODO: Add editing of reminders if needed
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
                          // so that when they go back it will be to home page
                          // because this list will not be updated with the latest reminders
                          Get.off(() => ReminderAddScreen());
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
                : (ListView.builder(
                    shrinkWrap: true,
                    itemCount: reminderList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String recurringType;
                      switch (reminderList[index].recurringType) {
                        case "day":
                          {
                            recurringType = "Daily";
                          }
                          break;
                        case "week":
                          {
                            recurringType = "Weekly";
                          }
                          break;
                        case "month":
                          {
                            recurringType = "Monthly";
                          }
                          break;
                        case "year":
                          {
                            recurringType = "Yearly";
                          }
                          break;
                        default:
                          {
                            recurringType = "Never";
                          }
                          break;
                      }
                      return Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: ReminderListNotificationCard(
                              title: reminderList[index].title,
                              startTime: DateFormat("hh:mm a")
                                  .format(reminderList[index].eventStartTime),
                              id: reminderList[index].id,
                              elderId: reminderList[index].elderId,
                              recurringType: recurringType,
                              isRecurring: reminderList[index].isRecurring,
                              startDate: DateFormat("dd")
                                  .format(reminderList[index].eventStartTime),
                              startMonth: DateFormat("MMM")
                                  .format(reminderList[index].eventStartTime)));
                    }))
          ],
        ),
      ),
    );
  }
}
