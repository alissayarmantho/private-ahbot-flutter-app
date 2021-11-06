import 'dart:convert';

import 'package:botapp/models/contact.dart';
import 'package:botapp/services/api_constants.dart';

import 'base_api.dart';

class ContactService {
  static final String contactUrl = "/api/media/contact";

  static Future<List<Contact>> fetchAllContacts(
      {required String elderId}) async {
    String url = base_api + contactUrl + "/all?elderId=" + elderId;
    try {
      var response = await BaseApi.get(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return List<Contact>.from(
          jsonString['data']['contacts'].map((x) => Contact.fromJson(x)),
        );
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Getting all contacts error");
    }
  }

  static Future<Contact> createContact({
    required String name,
    required String number,
    required String countryCode,
    required String elderId,
  }) async {
    String url = base_api + contactUrl;

    try {
      var response = await BaseApi.post(url: url, body: <String, String>{
        'name': name,
        'number': number,
        'countryCode': countryCode,
        'elderId': elderId,
      });
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Contact.fromJson(jsonString['data']['contact']);
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Creating contact error");
    }
  }

  static Future<String> deleteContact({required String id}) async {
    String url = base_api + contactUrl + "contactId=" + id;

    try {
      var response = await BaseApi.delete(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonString['msg'];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Deleting contact error");
    }
  }

  static Future<String> multiDeleteContact({required List<String> id}) async {
    int length = id.length;
    for (var id in id) {
      String url = base_api + contactUrl + "contactId=" + id;

      try {
        var response = await BaseApi.delete(url: url);
        var jsonString = jsonDecode(response.body);
        if (response.statusCode != 200) {
          return Future.error(jsonString['msg']);
        }
      } catch (e) {
        return Future.error("Deleting contact error");
      }
    }
    return "Deleted $length contacts";
  }
}
