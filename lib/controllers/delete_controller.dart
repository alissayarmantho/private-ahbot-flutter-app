import 'package:botapp/controllers/contact_controller.dart';
import 'package:botapp/controllers/media_controller.dart';
import 'package:botapp/models/contact.dart';
import 'package:botapp/models/media.dart';
import 'package:get/get.dart';

class DeleteController extends GetxController {
  var musicList = List<Media>.from([]).obs;
  var pictureList = List<Media>.from([]).obs;
  var videoList = List<Media>.from([]).obs;
  var contactList = List<Contact>.from([]).obs;
  var elderId = "".obs;

  var isSelectedMusicList = List<bool>.from([]).obs;
  var isSelectedPictureList = List<bool>.from([]).obs;
  var isSelectedVideoList = List<bool>.from([]).obs;
  var isSelectedContactList = List<bool>.from([]).obs;

  final MediaController mediaController;
  final ContactController contactController;

  DeleteController(
      {required this.mediaController, required this.contactController});

  @override
  void onInit() {
    super.onInit();
  }

  void setList() {
    musicList.value = mediaController.musicList;
    pictureList.value = mediaController.pictureList;
    videoList.value = mediaController.videoList;
    contactList.value = contactController.contactList;

    isSelectedMusicList.value = List.filled(musicList.length, false);
    isSelectedPictureList.value = List.filled(pictureList.length, false);
    isSelectedVideoList.value = List.filled(videoList.length, false);
    isSelectedContactList.value = List.filled(pictureList.length, false);
  }

  void delete() {
    List<String> mediaIdsToDelete = [];
    List<String> contactIdsToDelete = [];
    isSelectedMusicList.asMap().forEach((index, value) => {
          if (value) {mediaIdsToDelete.add(musicList[index].id)}
        });
    isSelectedPictureList.asMap().forEach((index, value) => {
          if (value) {mediaIdsToDelete.add(pictureList[index].id)}
        });
    isSelectedVideoList.asMap().forEach((index, value) => {
          if (value) {mediaIdsToDelete.add(videoList[index].id)}
        });
    isSelectedContactList.asMap().forEach((index, value) => {
          if (value) {contactIdsToDelete.add(contactList[index].id)}
        });

    if (mediaIdsToDelete.length != 0) {
      mediaController.multiDeleteMedia(
          id: mediaIdsToDelete, elderId: elderId.value);
      // Success or fail, just remove all user selection :)
      // TODO: Better way of doing this
      setList();
    }

    if (contactIdsToDelete.length != 0) {
      contactController.multiDeleteContact(
          id: contactIdsToDelete, elderId: elderId.value);
      // Success or fail, just remove all user selection :)
      // TODO: Better way of doing this
      setList();
    }
  }
}
