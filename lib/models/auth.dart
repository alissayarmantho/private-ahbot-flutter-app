// To parse this JSON data, do
//
//     final auth = authFromJson(jsonString);

import 'dart:convert';

class Auth {
  Auth({
    required this.token,
    required this.account,
  });

  String token;
  Account account;

  factory Auth.fromRawJson(String str) => Auth.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        token: json["token"],
        account: Account.fromJson(json["account"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "account": account.toJson(),
      };
}

class Account {
  Account({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.accountType,
    required this.email,
  });

  String id;
  String firstName;
  String lastName;
  String accountType;
  String email;

  factory Account.fromRawJson(String str) => Account.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        accountType: json["accountType"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "accountType": accountType,
        "email": email,
      };
}
