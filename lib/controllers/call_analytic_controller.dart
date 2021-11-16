import 'package:botapp/controllers/analytics_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CallAnalyticController extends GetxController {
  final AnalyticController analyticController = AnalyticController();
  final DateFormat dateFormat = DateFormat('y-MM-dd HH:mm:ss');
  late final DateTime startTime;
  final String callType;

  CallAnalyticController({required this.callType});
  @override
  void onInit() {
    startTime = DateTime.now();
    super.onInit();
  }

  @override
  void onClose() {
    analyticController.createCallLog(
        callType: callType,
        startTime: dateFormat.format(startTime),
        endTime: dateFormat.format(DateTime.now()));
    super.dispose();
  }
}
