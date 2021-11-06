// To parse this JSON data, do
//
//     final mediaLog = mediaLogFromJson(jsonString);

import 'dart:convert';

class NotificationMessage {
  NotificationMessage({
    required this.elderId,
    required this.eventType,
    required this.actionTrigger,
    required this.status,
    required this.sender,
  });

  String elderId;
  String eventType;
  String actionTrigger;
  String status;
  String sender;

  factory NotificationMessage.fromRawJson(String str) =>
      NotificationMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationMessage.fromJson(Map<String, dynamic> json) =>
      NotificationMessage(
        elderId: json["elderId"],
        eventType: json["eventType"],
        actionTrigger: json["actionTrigger"],
        status: json["status"],
        sender: json["sender"],
      );

  Map<String, dynamic> toJson() => {
        "elderId": elderId,
        "eventType": eventType,
        "actionTrigger": actionTrigger,
        "status": status,
        "sender": sender,
      };
}
