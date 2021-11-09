import 'package:botapp/models/user.dart';
import 'package:botapp/services/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var associatedElders = [].obs;
  var associatedCaregivers = [].obs;
  var currentUser = User.nullUser.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void fetchUser() async {
    isLoading(true);
    try {
      await UserService.fetchUser().then((res) {
        currentUser.value = res;
        if (res.accountType == 'caregiver')
          fetchElders();
        else
          fetchCaregivers();
      }).catchError((err) {
        Get.snackbar(
          "Error Getting User",
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

  void removeCurrentUser() {
    currentUser.value = User.nullUser;
    associatedElders.value = [];
    associatedCaregivers.value = [];
  }

  void fetchCaregivers() async {
    isLoading(true);
    try {
      await UserService.fetchCaregivers().then((res) {
        associatedCaregivers.value = res;
      }).catchError((err) {
        Get.snackbar(
          "Error Fetching Caregivers",
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

  void fetchElders() async {
    isLoading(true);
    try {
      await UserService.fetchElders().then((res) {
        associatedElders.value = res;
      }).catchError((err) {
        Get.snackbar(
          "Error Fetching Elders",
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

  void addElder({required String id}) async {
    isLoading(true);
    try {
      await UserService.addElder(id: id).then((res) {
        currentUser.value = res;
        Get.snackbar(
          "Success",
          "Successfully added elder",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
        fetchElders();
      }).catchError((err) {
        Get.snackbar(
          "Error Adding Elder",
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

  void deleteElder({required String id}) async {
    isLoading(true);
    try {
      await UserService.deleteElder(id: id).then((res) {
        currentUser.value = res;
        Get.snackbar(
          "Successfully Deleted Elder",
          "",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
        fetchElders();
      }).catchError((err) {
        Get.snackbar(
          "Error Deleting Elder",
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
