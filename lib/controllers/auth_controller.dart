import 'package:botapp/models/auth.dart';
import 'package:botapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends GetxController {
  // Create storage
  // TODO: Find a better way to store the token as currently this will not last
  // if the app is closed, the user will be signed out automatically
  final storage = new FlutterSecureStorage();

  var isLoggedIn = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    // Initialise empty token
    refreshToken("");
    super.onInit();
  }

  Future<String> getToken() async {
    String? token = await storage.read(key: "token");
    if (token != null) {
      if (token == "")
        isLoggedIn(false);
      else
        isLoggedIn(true);
      return token;
    }
    // token should never be null here
    return "";
  }

  void refreshToken(String value) async {
    // Write token to storage
    if (value == "") isLoggedIn(false);
    await storage.write(key: "token", value: value);
  }

  void register({required Account newAccount, required String password}) async {
    isLoading(true);
    try {
      await AuthService.register(account: newAccount, password: password)
          .then((res) {
        refreshToken(res.token);
        if (res.token != "") {
          isLoggedIn(true);
          Get.back();
        }
      }).catchError((err) {
        Get.snackbar(
          "Error Registering Account",
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

  void login({required String email, required String password}) async {
    isLoading(true);
    try {
      await AuthService.login(email: email, password: password).then((res) {
        refreshToken(res.token);
        if (res.token != "") {
          isLoggedIn(true);
          Get.back();
        }
      }).catchError((err) {
        Get.snackbar(
          "Error Logging In",
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

  void logout() {
    // Current method of logging out
    refreshToken("");
    isLoggedIn(false);
    // TODO: Find a better way of doing this, currently this causes some page to
    // not exit entirely (starting from the third page from home page),
    // thus I just remove the logout button for those pages for now
    // (need to click back once again after clicking the logout button)
    Get.back();
  }

  void requestResetPassword({required String email}) async {
    isLoading(true);
    try {
      await AuthService.requestResetPassword(email: email).then((res) {
        Get.snackbar(
          "Success",
          "Successfully requested reset password",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      }).catchError((err) {
        Get.snackbar(
          "Error Requesting Reset Password",
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
