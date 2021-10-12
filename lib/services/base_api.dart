import 'dart:convert';

import 'package:botapp/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BaseApi {
  static var client = http.Client();

  static final AuthController authController = Get.put(AuthController());
  static Future<dynamic> get({required String url}) async {
    String token = await authController.getToken();
    return client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<dynamic> post(
      {required String url, required Map<String, dynamic> body}) async {
    String token = await authController.getToken();
    return await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  static Future<dynamic> delete({required String url}) async {
    String token = await authController.getToken();
    return client.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
