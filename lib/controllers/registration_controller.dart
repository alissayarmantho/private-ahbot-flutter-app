import 'package:get/get.dart';

class RegistrationController extends GetxController {
  // It is mandatory initialize with one value from the list
  var selected = "caregiver".obs;

  void setSelected(String value) {
    selected.value = value;
  }
}