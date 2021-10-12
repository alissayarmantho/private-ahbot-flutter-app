import 'dart:convert';

import 'package:botapp/models/auth.dart';
import 'package:botapp/services/api_constants.dart';
import 'package:http/http.dart' as http;

import 'base_api.dart';

class AuthService {
  static var client = http.Client();
  static final String authUrl = "/api/authorization";

  static Future<Auth> login(
      {required String email, required String password}) async {
    String url = base_api + authUrl + "/login";

    try {
      var response = await BaseApi.post(url: url, body: <String, String>{
        'email': email,
        'password': password,
      });
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Auth.fromJson(jsonString['data']);
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Login error");
    }
  }

  static Future<Auth> register(
      {required Account account, required String password}) async {
    String url = base_api + authUrl + "/signup";

    try {
      var response = await BaseApi.post(url: url, body: <String, String>{
        "firstName": account.firstName,
        "lastName": account.lastName,
        "accountType": account.accountType,
        'email': account.email,
        'password': password,
      });
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Auth.fromJson(jsonString['data']);
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Registration error");
    }
  }

  static Future<String> requestResetPassword({required String email}) async {
    String url = base_api + authUrl + "/reset-password-request";

    try {
      var response = await BaseApi.post(url: url, body: <String, String>{
        'email': email,
      });
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonString['msg'];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Request reset password error");
    }
  }
  // Logout is not available in the backend api
}
