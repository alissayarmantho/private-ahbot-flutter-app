// To parse this JSON data, do
//
//     final media = mediaFromJson(jsonString);

import 'dart:convert';

class Media {
  Media({
    required this.title,
    required this.description,
    required this.elderId,
    required this.link,
    required this.mediaType,
    required this.id,
  });

  String title;
  String description;
  String elderId;
  String link;
  String mediaType;
  String id;

  factory Media.fromRawJson(String str) => Media.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        title: json["title"],
        description: json["description"],
        elderId: json["elderId"],
        link: json["link"],
        mediaType: json["mediaType"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "elderId": elderId,
        "link": link,
        "mediaType": mediaType,
        "_id": id,
      };
}
