import 'package:botapp/models/media.dart';
import 'package:botapp/services/media.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaController extends GetxController {
  var videoList = List<Media>.from([]).obs;
  var pictureList = List<Media>.from([]).obs;
  var musicList = List<Media>.from([]).obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void fetchAllMedia(
      {required String mediaType, required String elderId}) async {
    isLoading(true);

    try {
      await MediaService.fetchAllMedia(mediaType: mediaType, elderId: elderId)
          .then((res) {
        if (mediaType == "picture") pictureList.value = res;
        if (mediaType == "video") videoList.value = res;
        if (mediaType == "music") musicList.value = res;
      }).catchError((err) {
        Get.snackbar(
          "Error Getting All Media",
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

  void uploadMedia(
      {required String mediaType,
      required String elderId,
      required String title,
      required String description,
      required PlatformFile file}) async {
    isLoading(true);

    try {
      await MediaService.uploadMedia(
              mediaType: mediaType,
              elderId: elderId,
              title: title,
              description: description,
              file: file)
          .then((res) {
        Get.snackbar(
          "Successfully uploaded media",
          "Please go to the website if you want to customise your media description/title",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        );
      }).catchError((err) {
        Get.snackbar(
          "Error Uploading Media",
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

  void deleteMedia({required String id}) async {
    isLoading(true);

    try {
      await MediaService.deleteMedia(id: id).then((res) {
        Get.snackbar(
          "Success",
          "Successfully deleted media",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      }).catchError((err) {
        Get.snackbar(
          "Error Deleting Media",
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
