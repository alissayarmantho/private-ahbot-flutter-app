// To parse this JSON data, do
//
//     final callLog = callLogFromJson(jsonString);

import 'dart:convert';

class CallLog {
  CallLog({
    required this.callType,
    required this.ownerId,
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.totalMin,
  });

  String callType;
  String ownerId;
  String id;
  DateTime startTime;
  DateTime endTime;
  int totalMin;

  factory CallLog.fromRawJson(String str) => CallLog.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CallLog.fromJson(Map<String, dynamic> json) => CallLog(
        callType: json["callType"],
        ownerId: json["ownerId"],
        id: json["_id"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        totalMin: json["totalMin"],
      );

  Map<String, dynamic> toJson() => {
        "callType": callType,
        "ownerId": ownerId,
        "_id": id,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "totalMin": totalMin,
      };
}
