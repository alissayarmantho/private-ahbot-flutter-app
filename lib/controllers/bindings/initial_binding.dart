import 'package:botapp/controllers/audio_controller.dart';
import 'package:botapp/controllers/auth_controller.dart';
import 'package:botapp/controllers/user_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<UserController>(() => UserController());
    Get.put<AudioController>(AudioController());
  }
}
