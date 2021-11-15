import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UploadController extends GetxController {
  var fileName = "".obs;
  var saveAsFileName = "".obs;
  // Currently this should only hold one value as I do not allow multiple files
  // pick
  var paths = List<PlatformFile>.from([]).obs;
  var directoryPath = "".obs;
  var extension = "".obs;
  var isLoading = false.obs;
  var userAborted = false.obs;
  var multiPick = false.obs;
  var pickingType = FileType.any.obs;

  void setPickingType(FileType value) {
    pickingType.value = value;
  }

  void resetState() {
    isLoading.value = true;
    directoryPath.value = "";
    fileName.value = "";
    paths.value = [];
    saveAsFileName.value = "";
    userAborted.value = false;
  }

  Future<PlatformFile?> pickFiles() async {
    resetState();
    try {
      directoryPath.value = "";
      paths.value = (await FilePicker.platform.pickFiles(
            withReadStream: true,
            type: pickingType.value,
            allowMultiple: multiPick.value,
            onFileLoading: (FilePickerStatus status) => print(status),
            allowedExtensions: (extension.value.isNotEmpty)
                ? extension.value.replaceAll(' ', '').split(',')
                : null,
          ))
              ?.files ??
          [];
      return paths.length > 0 ? paths.single : null;
    } on PlatformException catch (e) {
      Get.snackbar(
        "Unsupported Operation",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } catch (e) {
      Get.snackbar(
        "Error Picking Files",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
      fileName.value =
          paths.isNotEmpty ? paths.map((e) => e.name).toString() : '...';
      userAborted.value = paths.isEmpty;
      setPickingType(FileType.any);
    }
  }
}
