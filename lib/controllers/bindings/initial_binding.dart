import 'package:botapp/controllers/audio_controller.dart';
import 'package:botapp/controllers/auth_controller.dart';
import 'package:botapp/controllers/contact_controller.dart';
import 'package:botapp/controllers/media_controller.dart';
import 'package:botapp/controllers/notification_controller.dart';
import 'package:botapp/controllers/speech_controller.dart';
import 'package:botapp/controllers/user_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<AudioController>(() => AudioController());
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<SpeechController>(() => SpeechController());
    Get.lazyPut<MediaController>(() => MediaController());
    Get.lazyPut<ContactController>(() => ContactController());
  }
}
