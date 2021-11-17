import 'package:botapp/constants.dart';
import 'package:botapp/controllers/reminder_controller.dart';
import 'package:botapp/models/reminder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class ReminderListNotificationCard extends StatelessWidget {
  final String id,
      elderId,
      title,
      startTime,
      startDate,
      startMonth,
      recurringType;
  final bool isRecurring, hasBeenDeleted;
  final Reminder reminder;
  ReminderListNotificationCard(
      {Key? key,
      required this.id,
      required this.elderId,
      required this.title,
      required this.startTime,
      required this.startDate,
      required this.startMonth,
      required this.recurringType,
      required this.isRecurring,
      required this.reminder,
      required this.hasBeenDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SlidableReminderController slidableReminderController =
        Get.put<SlidableReminderController>(SlidableReminderController());
    slidableReminderController.setHasBeenDeleted(hasBeenDeleted);
    return Obx(
      () => Slidable(
        // The start action pane is the one at the left or the top side.
        endActionPane: slidableReminderController.hasBeenDeleted.value
            ? null
            : ActionPane(
                // A motion is a widget used to control how the pane animates.
                motion: const DrawerMotion(),

                // All actions are defined in the children parameter.
                children: [
                  // A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed: (BuildContext context) {
                      ReminderController()
                          .deleteReminder(id: id, elderId: elderId);
                      slidableReminderController.hasBeenDeleted.value = true;
                      reminder.hasBeenDeleted = true;
                    },
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
        child: Obx(
          () => Container(
            margin: EdgeInsets.fromLTRB(30, 0, 20, 20),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              color: slidableReminderController.hasBeenDeleted.value
                  ? Colors.grey.shade300
                  : kPrimaryLightColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(65),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(65),
                bottomRight: Radius.circular(65),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Obx(
                  () => Container(
                    padding: EdgeInsets.all(5.0),
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                        color: slidableReminderController.hasBeenDeleted.value
                            ? Colors.grey.shade400
                            : kPrimaryColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: isRecurring
                        ? Center(
                            child: Text(recurringType,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                startDate,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(startMonth,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15))
                            ],
                          ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title),
                      Text(startTime,
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SlidableReminderController extends GetxController {
  var hasBeenDeleted = false.obs;

  void setHasBeenDeleted(bool value) {
    hasBeenDeleted.value = value;
  }
}
