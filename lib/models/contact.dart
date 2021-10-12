// To parse this JSON data, do
//
//     final contact = contactFromJson(jsonString);

import 'dart:convert';

class Contact {
  Contact({
    required this.name,
    required this.number,
    required this.countryCode,
    required this.ownerId,
    required this.id,
  });

  String name;
  String number;
  String countryCode;
  String ownerId;
  String id;

  factory Contact.fromRawJson(String str) => Contact.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        name: json["name"],
        number: json["number"],
        countryCode: json["countryCode"],
        ownerId: json["ownerId"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "number": number,
        "countryCode": countryCode,
        "ownerId": ownerId,
        "_id": id,
      };
}
