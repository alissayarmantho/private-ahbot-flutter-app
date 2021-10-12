// To parse this JSON data, do
//
//     final mediaLog = mediaLogFromJson(jsonString);

import 'dart:convert';

class MediaLog {
  MediaLog({
    required this.mediaType,
    required this.ownerId,
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.totalMin,
  });

  String mediaType;
  String ownerId;
  String id;
  DateTime startTime;
  DateTime endTime;
  int totalMin;

  factory MediaLog.fromRawJson(String str) =>
      MediaLog.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaLog.fromJson(Map<String, dynamic> json) => MediaLog(
        mediaType: json["mediaType"],
        ownerId: json["ownerId"],
        id: json["_id"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        totalMin: json["totalMin"],
      );

  Map<String, dynamic> toJson() => {
        "mediaType": mediaType,
        "ownerId": ownerId,
        "_id": id,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "totalMin": totalMin,
      };
}
