// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.accountType,
    required this.email,
    required this.caregiverIds,
    required this.elderIds,
  });

  String id;
  String firstName;
  String lastName;
  String accountType;
  String email;
  List<String> caregiverIds;
  List<String> elderIds;
  static final nullUser = User(
      accountType: "",
      email: "",
      id: "",
      firstName: "",
      lastName: "",
      caregiverIds: [],
      elderIds: []);
  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        accountType: json["accountType"],
        email: json["email"],
        caregiverIds: List<String>.from(json["caregiverIds"].map((x) => x)),
        elderIds: List<String>.from(json["elderIds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "accountType": accountType,
        "email": email,
        "caregiverIds": List<dynamic>.from(caregiverIds.map((x) => x)),
        "elderIds": List<dynamic>.from(elderIds.map((x) => x)),
      };
}
