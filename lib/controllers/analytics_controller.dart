import 'package:botapp/models/calllog.dart';
import 'package:botapp/models/medialog.dart';
import 'package:botapp/services/analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticController extends GetxController {
  var callLogs = List<CallLog>.from([]).obs;
  var mediaLogs = List<MediaLog>.from([]).obs;

  // All in minutes
  var pictureActivityDuration = 0.obs;
  var videoActivityDuration = 0.obs;
  var musicActivityDuration = 0.obs;
  var videoCallDuration = 0.obs;
  var voiceCallDuration = 0.obs;

  // Quantities
  var videoCallQuantity = 0.obs;
  var voiceCallQuantity = 0.obs;
  var completedAppointments = 0.obs;
  var totalAppointments = 0.obs;
  var completedMedications = 0.obs;
  var totalMedications = 0.obs;

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

  void getCallQuantity({required String elderId}) async {
    isLoading(true);
    try {
      await AnalyticService.getCallQuantity(elderId: elderId).then((res) {
        videoCallQuantity.value = res[0];
        voiceCallQuantity.value = res[1];
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
  }

  void getCallDuration({required String elderId}) async {
    isLoading(true);
    try {
      await AnalyticService.getCallDuration(elderId: elderId).then((res) {
        videoCallDuration.value = res[0];
        voiceCallDuration.value = res[1];
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
  }

  void getAppointmentStats({required String elderId}) async {
    isLoading(true);
    try {
      await AnalyticService.getAppointmentStats(elderId: elderId).then((res) {
        completedAppointments.value = res[0];
        totalAppointments.value = res[1];
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
  }

  void getMedicationStats({required String elderId}) async {
    isLoading(true);
    try {
      await AnalyticService.getMedicationStats(elderId: elderId).then((res) {
        completedMedications.value = res[0];
        totalMedications.value = res[1];
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
  }

  void getMusicActivityDuration({required String elderId}) async {
    isLoading(true);
    try {
      await AnalyticService.getMusicActivityDuration(elderId: elderId)
          .then((res) {
        musicActivityDuration.value = res;
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
  }

  void getMediaActivityDuration(
      {required String elderId, required String mediaType}) async {
    isLoading(true);
    try {
      await AnalyticService.getMediaActivityDuration(
              elderId: elderId, mediaType: mediaType)
          .then((res) {
        if (mediaType == "picture") {
          pictureActivityDuration.value = res;
        } else {
          videoActivityDuration.value = res;
        }
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
