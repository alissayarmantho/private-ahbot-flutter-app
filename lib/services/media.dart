import 'dart:convert';

import 'package:botapp/controllers/auth_controller.dart';
import 'package:botapp/models/media.dart';
import 'package:botapp/services/api_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'base_api.dart';

class MediaService {
  static final String mediaUrl = "/api/media";

  static final AuthController authController = Get.put(AuthController());
  static Future<List<Media>> fetchAllMedia(
      {required String mediaType, required String elderId}) async {
    String url = base_api +
        mediaUrl +
        "/all?mediaType=" +
        mediaType +
        "&elderId=" +
        elderId;
    try {
      var response = await BaseApi.get(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return List<Media>.from(
          jsonString['data']['multimedia'].map((x) => Media.fromJson(x)),
        );
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Getting all media error");
    }
  }

  static Future<Media> uploadMedia(
      {required String mediaType,
      required String title,
      required String description,
      required PlatformFile file,
      required String elderId}) async {
    String url = base_api + mediaUrl + "/upload";
    if (mediaType == "music") {
      url = url + "-music";
    }

    try {
      String token = await authController.getToken();
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(url),
      );
      // Adding upload fields
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['mediaType'] = mediaType;
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['elderId'] = elderId;

      // Adding file with the request
      request.files.add(new http.MultipartFile("mediaUpload",
          file.readStream ?? Stream<List<int>>.empty(), file.size,
          filename: file.name));

      // send request
      http.Response response =
          await http.Response.fromStream(await request.send());

      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Media.fromJson(jsonString['data']['multimedia']);
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Uploading media error");
    }
  }

  static Future<String> deleteMedia({required String id}) async {
    String url = base_api + mediaUrl + "mediaId=" + id;

    try {
      var response = await BaseApi.delete(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonString['msg'];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Deleting media error");
    }
  }
}
