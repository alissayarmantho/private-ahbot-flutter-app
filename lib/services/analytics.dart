import 'dart:convert';

import 'package:botapp/models/calllog.dart';
import 'package:botapp/models/medialog.dart';
import 'package:botapp/services/api_constants.dart';

import 'base_api.dart';

class AnalyticService {
  static final String analyticUrl = "/api/analytic";

  static Future<List<MediaLog>> fetchAllMediaLogs(
      {required String elderId}) async {
    String url = base_api + analyticUrl + "/all/medialog?elderId=" + elderId;
    try {
      var response = await BaseApi.get(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return List<MediaLog>.from(
          jsonString['data']['mediaLogs'].map((x) => MediaLog.fromJson(x)),
        );
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Getting all media logs error");
    }
  }

  static Future<List<CallLog>> fetchAllCallLogs(
      {required String elderId}) async {
    String url = base_api + analyticUrl + "/all/calllog?elderId=" + elderId;
    try {
      var response = await BaseApi.get(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return List<CallLog>.from(
          jsonString['data']['callLogs'].map((x) => CallLog.fromJson(x)),
        );
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Getting all call logs error");
    }
  }

  static Future<List<int>> getCallQuantity({required String elderId}) async {
    String url = base_api + analyticUrl + "/call-quantity?elderId=" + elderId;
    try {
      var response = await BaseApi.get(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // index 0 for video call num and index 1 for voice call num
        return [
          jsonString['data']['videocallNum'],
          jsonString['data']['voicecallNum']
        ];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Getting call quantity error");
    }
  }

  static Future<List<int>> getCallDuration({required String elderId}) async {
    String url =
        base_api + analyticUrl + "/call-duration-stats?elderId=" + elderId;
    try {
      var response = await BaseApi.get(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // index 0 for video call num and index 1 for voice call num
        return [
          jsonString['data']['videocallDurationMinutes'],
          jsonString['data']['voiceCallDurationMinutes']
        ];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Getting call duration error");
    }
  }

  static Future<List<int>> getAppointmentStats(
      {required String elderId}) async {
    String url =
        base_api + analyticUrl + "/appointment-stats?elderId=" + elderId;
    try {
      var response = await BaseApi.get(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // index 0 for completed appointments and index 1 for total appointments
        return [
          jsonString['data']['completedAppointment'],
          jsonString['data']['totalAppointments']
        ];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Getting appointment statistics error");
    }
  }

  static Future<List<int>> getMedicationStats({required String elderId}) async {
    String url =
        base_api + analyticUrl + "/medication-stats?elderId=" + elderId;
    try {
      var response = await BaseApi.get(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // index 0 for completed medications and index 1 for total medications
        return [
          jsonString['data']['completedMedication'],
          jsonString['data']['totalMeds']
        ];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Getting medication statistics error");
    }
  }

  static Future<int> getMusicActivityDuration({required String elderId}) async {
    String url =
        base_api + analyticUrl + "/music-activity-duration?elderId=" + elderId;
    try {
      var response = await BaseApi.get(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonString['data']['musicTotalMin'];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Getting music activity duration error");
    }
  }

  // only media of type picture and video and probably will get cut out this one
  static Future<int> getMediaActivityDuration(
      {required String elderId, required String mediaType}) async {
    String url = base_api +
        analyticUrl +
        "/media-activity-duration?mediaType=" +
        mediaType +
        "&elderId=" +
        elderId;
    try {
      var response = await BaseApi.get(url: url);
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonString['data']['mediaTotalMin'];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Getting media activity duration error");
    }
  }

  static Future<String> createCallLog({
    required callType,
    required startTime,
    required endTime,
  }) async {
    String url = base_api + analyticUrl + "/calllog";

    try {
      var response = await BaseApi.post(url: url, body: <String, String>{
        'callType': callType,
        'startTime': startTime,
        'endTime': endTime,
      });
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonString['msg'];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Creating call log error");
    }
  }

  static Future<String> createMediaLog({
    required mediaType,
    required startTime,
    required endTime,
  }) async {
    String url = base_api + analyticUrl + "/medialog";

    try {
      var response = await BaseApi.post(url: url, body: <String, String>{
        'mediaType': mediaType,
        'startTime': startTime,
        'endTime': endTime,
      });
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonString['msg'];
      } else {
        return Future.error(jsonString['msg']);
      }
    } catch (e) {
      return Future.error("Creating media log error");
    }
  }
}
