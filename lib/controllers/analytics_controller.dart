import 'package:botapp/models/calllog.dart';
import 'package:botapp/models/contact.dart';
import 'package:botapp/models/medialog.dart';
import 'package:botapp/services/analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticController extends GetxController {
  var callLogs = List<CallLog>.from([]).obs;
  var mediaLogs = List<MediaLog>.from([]).obs;
  var filterName = "".obs;
  var filteredContactList = List<Contact>.from([]).obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void fetchAllCallLogs({required String elderId}) async {
    isLoading(true);

    try {
      await AnalyticService.fetchAllCallLogs(elderId: elderId).then((res) {
        callLogs.value = res;
      }).catchError((err) {
        Get.snackbar(
          "Error Getting All Call Logs",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
  }

  void fetchAllMediaLogs({required String elderId}) async {
    isLoading(true);

    try {
      await AnalyticService.fetchAllMediaLogs(elderId: elderId).then((res) {
        mediaLogs.value = res;
      }).catchError((err) {
        Get.snackbar(
          "Error Getting All Media Logs",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
  }

  Future<List<int>> getCallQuantity({required String elderId}) async {
    isLoading(true);
    try {
      await AnalyticService.getCallQuantity(elderId: elderId).then((res) {
        return Future.value(res);
      }).catchError((err) {
        Get.snackbar(
          "Error Getting Call Quantity",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
    // if it gets here it errors anyways I believe
    throw Future.error("Error getting call quantity");
  }

  Future<List<int>> getCallDuration({required String elderId}) async {
    isLoading(true);
    try {
      await AnalyticService.getCallDuration(elderId: elderId).then((res) {
        return Future.value(res);
      }).catchError((err) {
        Get.snackbar(
          "Error Getting Call Duration",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
    // if it gets here it errors anyways I believe
    throw Future.error("Error getting call duration");
  }

  Future<List<int>> getAppointmentStats({required String elderId}) async {
    isLoading(true);
    try {
      await AnalyticService.getAppointmentStats(elderId: elderId).then((res) {
        return Future.value(res);
      }).catchError((err) {
        Get.snackbar(
          "Error Getting Appointment Statistics",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
    // if it gets here it errors anyways I believe
    throw Future.error("Error getting appointment statistics");
  }

  Future<List<int>> getMedicationStats({required String elderId}) async {
    isLoading(true);
    try {
      await AnalyticService.getMedicationStats(elderId: elderId).then((res) {
        return Future.value(res);
      }).catchError((err) {
        Get.snackbar(
          "Error Getting Medication Statistics",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
    // if it gets here it errors anyways I believe
    throw Future.error("Error getting medication statistics");
  }

  Future<int> getMusicActivityDuration({required String elderId}) async {
    isLoading(true);
    try {
      await AnalyticService.getMusicActivityDuration(elderId: elderId)
          .then((res) {
        return Future.value(res);
      }).catchError((err) {
        Get.snackbar(
          "Error Getting Music Activity Duration",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
    // if it gets here it errors anyways I believe
    throw Future.error("Error getting music activity duration");
  }

  Future<int> getMediaActivityDuration(
      {required String elderId, required String mediaType}) async {
    isLoading(true);
    try {
      await AnalyticService.getMediaActivityDuration(
              elderId: elderId, mediaType: mediaType)
          .then((res) {
        return Future.value(res);
      }).catchError((err) {
        Get.snackbar(
          "Error Getting Media Activity Duration",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
    // if it gets here it errors anyways I believe
    throw Future.error("Error getting media activity duration");
  }

  void createCallLog({
    required String callType,
    required String startTime,
    required String endTime,
  }) async {
    isLoading(true);
    try {
      await AnalyticService.createCallLog(
        callType: callType,
        startTime: startTime,
        endTime: endTime,
      ).catchError((err) {
        Get.snackbar(
          "Error Creating Call Log",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
  }

  void createMediaLog({
    required String mediaType,
    required String startTime,
    required String endTime,
  }) async {
    isLoading(true);
    try {
      await AnalyticService.createMediaLog(
        mediaType: mediaType,
        startTime: startTime,
        endTime: endTime,
      ).catchError((err) {
        Get.snackbar(
          "Error Creating Media Log",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } finally {
      isLoading(false);
    }
  }
}
