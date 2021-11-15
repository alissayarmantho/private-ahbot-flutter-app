// To parse this JSON data, do
//
//     final reminder = reminderFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

class Reminder {
  Reminder({
    required this.title,
    required this.description,
    required this.elderId,
    required this.reminderType,
    required this.status,
    required this.isRecurring,
    required this.recurringCode,
    required this.recurringType,
    required this.id,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.startDate,
    required this.endDate,
  });

  String title;
  String description;
  String elderId;
  String reminderType;
  String status;
  bool isRecurring;
  String recurringCode;
  String recurringType;
  String id;
  DateTime eventStartTime;
  DateTime eventEndTime;
  DateTime startDate;
  DateTime endDate;

  static final nullReminder = Reminder(
      description: "",
      title: "",
      elderId: "",
      reminderType: "",
      status: "",
      recurringCode: "",
      isRecurring: false,
      recurringType: "",
      id: "",
      eventEndTime: DateTime.now(),
      eventStartTime: DateTime.now(),
      startDate: DateTime.now(),
      endDate: DateTime.now());
  factory Reminder.fromRawJson(String str) =>
      Reminder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        title: json["title"],
        description: json["description"],
        elderId: json["elderId"],
        reminderType: json["reminderType"],
        status: json["status"],
        isRecurring: json["isRecurring"],
        recurringCode: json["recurringCode"],
        recurringType: json["recurringType"],
        id: json["_id"],
        eventStartTime: DateFormat('y-M-d H:m').parse(json["eventStartTime"]),
        eventEndTime: DateFormat('y-M-d H:m').parse(json["eventEndTime"]),
        startDate: DateFormat('y-M-d').parse(json["startDate"]),
        endDate: DateFormat('y-M-d').parse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "elderId": elderId,
        "reminderType": reminderType,
        "status": status,
        "isRecurring": isRecurring,
        "recurringCode": recurringCode,
        "recurringType": recurringType,
        "_id": id,
        "eventStartTime": eventStartTime.toIso8601String(),
        "eventEndTime": eventEndTime.toIso8601String(),
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
      };
}
