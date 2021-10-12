import 'dart:convert';

import 'package:botapp/models/user.dart';
import 'package:botapp/services/api_constants.dart';

import 'base_api.dart';

class UserService {
  static final String userUrl = "/api/account";

  static Future<User> fetchUser() async {
    String url = base_api + userUrl + "/associated-elder-caregiver-my-account";
    try {
      var response = await BaseApi.get(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return User.fromJson(jsonString['data']['myAcccount']);
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Getting current user error");
    }
  }

  static Future<List<User>> fetchElders() async {
    String url = base_api + userUrl + "/associated-elder";
    try {
      var response = await BaseApi.get(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return List<User>.from(
          jsonString['data']['elders'].map((x) => User.fromJson(x)),
        );
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Getting associated elders error");
    }
  }

  static Future<List<User>> fetchCaregivers() async {
    String url = base_api + userUrl + "/associated-caregiver";
    try {
      var response = await BaseApi.get(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return List<User>.from(
          jsonString['data']['caregivers'].map((x) => User.fromJson(x)),
        );
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Getting associated caregivers error");
    }
  }

  static Future<User> addElder({required String id}) async {
    String url = base_api + userUrl + "/add-elder";

    try {
      var response =
          await BaseApi.post(url: url, body: <String, String>{'elderId': id});
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonString['data']['account'];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Adding elder error");
    }
  }

  static Future<User> deleteElder({required String id}) async {
    String url = base_api + userUrl + "/remove-elder";

    try {
      var response =
          await BaseApi.post(url: url, body: <String, String>{'elderId': id});
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonString['data']['account'];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Deleting elder error");
    }
  }
}
