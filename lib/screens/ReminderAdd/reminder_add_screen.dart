import 'dart:async';

import 'package:botapp/constants.dart';
import 'package:botapp/controllers/reminder_controller.dart';
import 'package:botapp/controllers/user_controller.dart';
import 'package:botapp/models/reminder.dart';
import 'package:botapp/models/user.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

//TODO: Integrate action type into these (and the Reminder Screen)
// I did not take into account action type
class ReminderAddScreen extends StatelessWidget {
  final notifType = ["popup", "action"];
  final recurringType = ["never", "day", "week", "month", "year"];
  final reminderType = [
    "appointment",
    "birthday",
    "call",
    "medication",
    "other"
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _timeController = TextEditingController();
  ReminderAddScreen({Key? key}) : super(key: key);

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
    final ReminderAddController reminderAddController =
        Get.put(ReminderAddController());
    return Scaffold(
      body: AppHeader(
        key: UniqueKey(),
        hasLogOut: true,
        hasBackButton: true,
        child: Form(
          key: _formKey,
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
                      child: Obx(
                        () => CircleAvatar(
                          radius: 30,
                          backgroundColor: reminderAddController.isLoading.value
                              ? Colors.grey.shade400
                              : kPrimaryColor,
                          child: Obx(
                            () => IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: reminderAddController.isLoading.value
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        reminderAddController.isLoading.value =
                                            true;
                                        ReminderController().createReminder(
                                            title: _titleController.text,
                                            description: "",
                                            elderId: elderId,
                                            reminderType: reminderAddController
                                                .reminderTypeSelected.value,
                                            isRecurring: reminderAddController
                                                .isRecurring.value,
                                            recurringType: reminderAddController
                                                .recurringTypeSelected.value,
                                            notifType: reminderAddController
                                                .notifTypeSelected.value,
                                            eventStartTime:
                                                reminderAddController
                                                    .eventStartTime.value,
                                            eventEndTime: reminderAddController
                                                .eventStartTime
                                                .value, // same as event start time
                                            startDate: reminderAddController
                                                .startDate.value,
                                            endDate: reminderAddController
                                                .endDate.value);
                                        // Manually set my own timer for loading
                                        // as depending on reminderController's
                                        // actual loading time will interfere with
                                        // caregiver home page and crash it
                                        // TODO: Find a way to fix this

                                        Timer(
                                            const Duration(seconds: 1),
                                            () => {
                                                  _titleController.text = "",
                                                  _startDateController.text =
                                                      "",
                                                  _endDateController.text = "",
                                                  _timeController.text = "",
                                                  reminderAddController
                                                      .resetAllValues(),
                                                  reminderAddController
                                                      .isLoading.value = false
                                                });
                                      }
                                    },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(40, 40, 40, 20),
                  padding: const EdgeInsets.all(40.0),
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(65),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(65),
                      bottomRight: Radius.circular(65),
                    ),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          hintText: 'Title',
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromRGBO(196, 196, 196, 1),
                          )),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Reminder title cannot be empty';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _timeController,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          hintText: 'Time',
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromRGBO(196, 196, 196, 1),
                          )),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          DatePicker.showDateTimePicker(context,
                              minTime: DateTime.now(),
                              showTitleActions: true,
                              onChanged: (date) {}, onConfirm: (date) {
                            reminderAddController.setEventStartTime(date);
                            reminderAddController.setStartDate(date);
                            _startDateController.text =
                                DateFormat("E, dd MMMM y").format(date);
                            _timeController.text =
                                DateFormat("E, dd MMMM y, hh:mm a")
                                    .format(date);
                          }, currentTime: DateTime.now());
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Reminder time cannot be empty';
                          }
                          return null;
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(196, 196, 196, 1),
                            ),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Text(
                                "Repeat",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Obx(
                              () => DropdownButton(
                                value: reminderAddController
                                    .recurringTypeSelected.value,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: recurringType.map((String item) {
                                  return DropdownMenuItem(
                                      value: item, child: Text(item));
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    reminderAddController
                                        .setRecurringTypeSelected(newValue);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => reminderAddController.isRecurring.value
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromRGBO(196, 196, 196, 1),
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                      child: Text(
                                        "Start Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextFormField(
                                        enabled: false,
                                        controller: _startDateController,
                                        style: TextStyle(fontSize: 18),
                                        decoration: InputDecoration(
                                          hintText: 'Start Date',
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                196, 196, 196, 1),
                                          )),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                        ),
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Start date cannot be empty';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                      child: Text(
                                        "End Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _endDateController,
                                        style: TextStyle(fontSize: 18),
                                        decoration: InputDecoration(
                                          hintText: 'End Date',
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                196, 196, 196, 1),
                                          )),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                        ),
                                        onTap: () {
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          DatePicker.showDatePicker(context,
                                              minTime: DateFormat("y-MM-dd")
                                                  .parse(reminderAddController
                                                      .startDate.value),
                                              showTitleActions: true,
                                              onChanged: (date) {},
                                              onConfirm: (date) {
                                            reminderAddController
                                                .setEndDate(date);
                                            _endDateController.text =
                                                DateFormat("E, dd MMMM y")
                                                    .format(date);
                                          },
                                              currentTime: DateFormat("y-MM-dd")
                                                  .parse(reminderAddController
                                                      .startDate.value));
                                        },
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'End date cannot be empty';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(196, 196, 196, 1),
                            ),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Text(
                                "Notification Type",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Obx(
                              () => DropdownButton(
                                value: reminderAddController
                                    .notifTypeSelected.value,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: notifType.map((String item) {
                                  return DropdownMenuItem(
                                      value: item, child: Text(item));
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    reminderAddController
                                        .setNotifTypeSelected(newValue);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Text(
                                "Notification Icon",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Obx(
                              () => DropdownButton(
                                value: reminderAddController
                                    .reminderTypeSelected.value,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: reminderType.map((String item) {
                                  IconData icon;
                                  switch (item) {
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
                                  return DropdownMenuItem(
                                      value: item,
                                      child: Icon(icon, color: kPrimaryColor));
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    reminderAddController
                                        .setReminderTypeSelected(newValue);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                            "Note: Any new notification created will not be immediately reflected in the app until 5 mins since its creation"),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReminderAddController extends GetxController {
  // It is mandatory initialize with one value from the list
  var notifTypeSelected = "popup".obs;
  var recurringTypeSelected = "never".obs;
  var reminderTypeSelected = "other".obs;
  var isRecurring = false.obs;
  var isLoading = false.obs;
  var eventStartTime = "".obs; // endTime will be the same as startTime
  // Endtime is actually redundant here
  // TODO: Ask backend to remove redundant info like endtime, description, and
  // isRecurring which can be inferred by an additional recurringType "none"
  // It's probably better to ask event date format to be hh:mm instead of
  // "y-M-d H:m" as event time should be a time
  var startDate = "".obs;
  var endDate = "".obs;

  final DateFormat eventDateFormat = DateFormat("y-MM-dd HH:mm");
  final DateFormat dateFormat = DateFormat("y-MM-dd");

  void resetAllValues() {
    startDate.value = "";
    endDate.value = "";
    eventStartTime.value = "";
    isRecurring.value = false;
    notifTypeSelected.value = "popup";
    recurringTypeSelected.value = "never";
    reminderTypeSelected.value = "other";
  }

  void setNotifTypeSelected(String value) {
    notifTypeSelected.value = value;
  }

  void setRecurringTypeSelected(String value) {
    recurringTypeSelected.value = value;
    setIsRecurring(value != "never");
  }

  void setReminderTypeSelected(String value) {
    reminderTypeSelected.value = value;
  }

  void setIsRecurring(bool value) {
    isRecurring.value = value;
  }

  void setStartDate(DateTime date) {
    startDate.value = dateFormat.format(date);
  }

  void setEndDate(DateTime date) {
    endDate.value = dateFormat.format(date);
  }

  void setEventStartTime(DateTime date) {
    eventStartTime.value = eventDateFormat.format(date);
    if (recurringTypeSelected.value == "never") {
      setStartDate(date);
      setEndDate(date);
    }
  }
}
