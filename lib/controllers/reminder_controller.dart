import 'dart:async';

import 'package:botapp/models/reminder.dart';
import 'package:botapp/services/reminder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReminderController extends GetxController {
  var reminderList = List<Reminder>.from([]).obs;
  var activeReminder = Reminder.nullReminder.obs;
  var elderId = "".obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void fetchAllReminders({required String elderId}) async {
    isLoading(true);

    try {
      await ReminderService.fetchAllReminders(elderId: elderId).then((res) {
        reminderList.value = res;
      }).catchError((err) {
        Get.snackbar(
          "Error Getting All Reminders",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
  }

  void fetchReminder({required String id}) async {
    isLoading(true);

    try {
      await ReminderService.fetchReminder(id: id).then((res) {
        activeReminder.value = res;
      }).catchError((err) {
        Get.snackbar(
          "Error Getting Reminder",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
  }

  void updateReminderList() {
    // Update once per 2 hours, need to set elderId first
    fetchAllReminders(elderId: elderId.value);
    Timer(
      Duration(hours: 2),
      updateReminderList,
    );
  }

  void updateReminderStatus(
      {required String reminderId, required String status}) async {
    isLoading(true);

    try {
      await ReminderService.updateReminderStatus(
              reminderId: reminderId, status: status)
          .then((res) {
        Get.snackbar(
          "Success",
          "Successfully updated reminder status",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        );
      }).catchError((err) {
        Get.snackbar(
          "Error Updating Reminder Status",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
  }

  void createReminder({
    required title,
    required description,
    required elderId,
    required reminderType,
    required isRecurring,
    required recurringType,
    required notifType,
    required eventStartTime,
    required eventEndTime,
    required startDate,
    required endDate,
  }) async {
    isLoading(true);

    try {
      await ReminderService.createReminder(
        elderId: elderId,
        title: title,
        description: description,
        reminderType: reminderType,
        isRecurring: isRecurring,
        recurringType: recurringType,
        notifType: notifType,
        eventStartTime: eventStartTime,
        eventEndTime: eventEndTime,
        startDate: startDate,
        endDate: endDate,
      ).then((res) {
        Get.snackbar(
          "Successfully created reminder",
          "Please go to the website for further customisation",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        );
        fetchAllReminders(elderId: elderId);
      }).catchError((err) {
        Get.snackbar(
          "Error Creating Reminder",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
  }

  void deleteAllRecurringReminder({required String recurringCode}) async {
    isLoading(true);

    try {
      await ReminderService.deleteAllRecurringReminder(
              recurringCode: recurringCode)
          .then((res) {
        Get.snackbar(
          "Success",
          "Successfully deleted all recurring reminders",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      }).catchError((err) {
        Get.snackbar(
          "Error Deleting All Recurring Reminders",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
  }

  void deleteReminder({required String id, required String elderId}) async {
    isLoading(true);

    try {
      await ReminderService.deleteReminder(id: id).then((res) {
        Get.snackbar(
          "Success",
          "Successfully deleted reminder",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
        fetchAllReminders(elderId: elderId);
      }).catchError((err) {
        Get.snackbar(
          "Error Deleting Reminder",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
  }
}
