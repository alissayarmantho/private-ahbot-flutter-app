import 'dart:convert';

import 'package:botapp/models/reminder.dart';
import 'package:botapp/services/api_constants.dart';

import 'base_api.dart';

class ReminderService {
  static final String reminderUrl = "/api/reminder";

  // Fetching all reminders for today
  static Future<List<Reminder>> fetchAllReminders(
      {required String elderId}) async {
    String url = base_api + reminderUrl + "/notifications?elderId=" + elderId;
    try {
      var response = await BaseApi.get(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return List<Reminder>.from(
          jsonString['data']['notifications'].map((x) => Reminder.fromJson(x)),
        );
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Getting all notifications error");
    }
  }

  static Future<String> createReminder({
    required title,
    required description,
    required elderId,
    required reminderType,
    required isRecurring,
    required recurringType,
    required eventStartTime,
    required eventEndTime,
    required startDate,
    required endDate,
  }) async {
    String url = base_api + reminderUrl + "/create-reminder";

    try {
      var response = await BaseApi.post(url: url, body: <String, dynamic>{
        'title': title,
        'description': description,
        'elderId': elderId,
        'reminderType': reminderType,
        'isRecurring': isRecurring,
        'recurringType': recurringType,
        'eventStartTime': eventStartTime,
        'eventEndTime': eventEndTime,
        'startDate': startDate,
        'endDate': endDate,
      });
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonString['msg'];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Creating reminder error");
    }
  }

  static Future<String> updateReminderStatus({
    required String reminderId,
    required String status,
  }) async {
    String url = base_api + reminderUrl + "/update-reminder-status";

    try {
      var response = await BaseApi.post(url: url, body: <String, String>{
        'reminderId': reminderId,
        'status': status,
      });
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonString['msg'];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Updating reminder status error");
    }
  }

  static Future<String> deleteReminder({required String id}) async {
    String url = base_api + reminderUrl + "/single?reminderId=" + id;

    try {
      var response = await BaseApi.delete(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonString['msg'];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Deleting reminder error");
    }
  }

  static Future<String> deleteAllRecurringReminder(
      {required String recurringCode}) async {
    String url = base_api +
        reminderUrl +
        "/all-recurring?recurringCode=" +
        recurringCode;

    try {
      var response = await BaseApi.delete(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonString['msg'];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Deleting recurring reminder error");
    }
  }
}
