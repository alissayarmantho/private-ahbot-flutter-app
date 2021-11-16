import 'package:botapp/controllers/analytics_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MediaAnalyticController extends GetxController {
  final AnalyticController analyticController = AnalyticController();
  final DateFormat dateFormat = DateFormat('y-MM-dd HH:mm:ss');
  final String mediaType;
  late final DateTime startTime;
  MediaAnalyticController({required this.mediaType});

  @override
  void onInit() {
    startTime = DateTime.now();
    super.onInit();
  }

  @override
  void onClose() {
    analyticController.createMediaLog(
        mediaType: mediaType,
        startTime: dateFormat.format(startTime),
        endTime: dateFormat.format(DateTime.now()));
    super.dispose();
  }
}
