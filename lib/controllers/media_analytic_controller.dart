import 'package:get/get.dart';

class MediaAnalyticController extends GetxController {
  // It is mandatory initialize with one value from the list
  var selected = "caregiver".obs;

  @override
  void onInit() {
    super.onInit();
  }

  void setSelected(String value) {
    selected.value = value;
  }
}
