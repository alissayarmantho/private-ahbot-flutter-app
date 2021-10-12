import 'package:botapp/constants.dart';
import 'package:botapp/controllers/media_controller.dart';
import 'package:botapp/controllers/user_controller.dart';
import 'package:botapp/models/user.dart';
import 'package:botapp/screens/CreateContact/create_contact_screen.dart';
import 'package:botapp/screens/Delete/delete_screen.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:botapp/widgets/custom_icon_button.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final UploadController uploadController = Get.put(UploadController());
    final MediaController mediaController = Get.put(MediaController());
    final UserController userController = Get.find<UserController>();
    final User currentUser = userController.currentUser.value;
    userController.fetchElders();
    return Scaffold(
      body: AppHeader(
        key: UniqueKey(),
        hasLogOut: true,
        hasBackButton: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(50, 15, 0, 10),
                child: Text(
                  "Upload",
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: kPrimaryColor),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 0.05 * size.height,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CustomIconButton(
                          key: UniqueKey(),
                          svgAssetPath: 'assets/icons/music.svg',
                          hasTitle: false,
                          hasDescription: true,
                          description: "Songs",
                          press: () async {
                            uploadController.setPickingType(FileType.audio);
                            await uploadController.pickFiles().then((res) => {
                                  if (res != null)
                                    {
                                      mediaController.uploadMedia(
                                          mediaType: "music",
                                          elderId: currentUser.elderIds.length >
                                                  0
                                              ? currentUser.elderIds[0]
                                              // This will trigger an error as there is
                                              // no elder linked to the current caregiver
                                              // Currently it will default to uploading music
                                              // for potato
                                              : "61547e49adbc3d0023ab129c",
                                          title: uploadController
                                              .paths.single.name,
                                          description: "This is great !!!",
                                          file: uploadController.paths.single)
                                    }
                                });
                          }),
                      CustomIconButton(
                          key: UniqueKey(),
                          hasTitle: false,
                          hasDescription: true,
                          description: "Photos and Videos",
                          svgAssetPath: 'assets/icons/photos.svg',
                          press: () async {
                            uploadController.setPickingType(FileType.image);
                            await uploadController.pickFiles().then((res) => {
                                  if (res != null)
                                    {
                                      mediaController.uploadMedia(
                                          mediaType: "picture",
                                          elderId: currentUser.elderIds.length >
                                                  0
                                              ? currentUser.elderIds[0]
                                              // This will trigger an error as
                                              // there is
                                              // no elder linked to the current
                                              // caregiver. Currently it will
                                              // default to uploading picture
                                              // for potato
                                              : "61547e49adbc3d0023ab129c",
                                          title: res.name,
                                          description: "This is great !!!",
                                          file: res)
                                    }
                                });
                          }),
                      CustomIconButton(
                        key: UniqueKey(),
                        hasTitle: false,
                        hasDescription: true,
                        description: "Contacts",
                        svgAssetPath: 'assets/icons/contact.svg',
                        press: () {
                          Get.to(() => CreateContactScreen());
                        },
                      ),
                      CustomIconButton(
                        key: UniqueKey(),
                        color: Color.fromRGBO(250, 60, 112, 0.3),
                        splashColor: Color.fromRGBO(250, 60, 112, 0.6),
                        hasTitle: false,
                        hasDescription: true,
                        description: "Delete current files",
                        svgAssetPath: 'assets/icons/trash.svg',
                        press: () {
                          Get.to(() => DeleteScreen());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
