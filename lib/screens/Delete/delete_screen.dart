import 'package:botapp/constants.dart';
import 'package:botapp/controllers/contact_controller.dart';
import 'package:botapp/controllers/media_controller.dart';
import 'package:botapp/controllers/user_controller.dart';
import 'package:botapp/models/contact.dart';
import 'package:botapp/models/media.dart';
import 'package:botapp/models/user.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/secondary_button.dart';
import 'package:botapp/widgets/zero_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DeleteScreen extends StatefulWidget {
  @override
  _DeleteScreenState createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen>
    with SingleTickerProviderStateMixin {
  // define your tab controller here

  @override
  Widget build(BuildContext context) {
    final _tabController = TabController(length: 3, vsync: this);
    final UserController userController = Get.find<UserController>();
    final User currentUser = Get.find<UserController>().currentUser.value;
    final String elderId = currentUser.elderIds.length > 0
        ? currentUser.elderIds[0]
        // This will trigger an error as there is
        // no elder linked to the current caregiver
        // Currently it will default to uploading music
        // for potato
        : "61547e49adbc3d0023ab129c";

    final MediaController mediaController =
        Get.put<MediaController>(MediaController());
    final Size size = MediaQuery.of(context).size;
    final ContactController contactController =
        Get.put<ContactController>(ContactController());
    userController.fetchElders();
    contactController.fetchAllContacts(elderId: elderId);
    mediaController.fetchAllMedia(mediaType: "picture", elderId: elderId);
    mediaController.fetchAllMedia(mediaType: "music", elderId: elderId);
    mediaController.fetchAllMedia(mediaType: "video", elderId: elderId);

    var pictureList = mediaController.pictureList;
    var musicList = mediaController.musicList;
    var videoList = mediaController.videoList;
    var contactList = contactController.contactList;

    return Scaffold(
      body: AppHeader(
        key: UniqueKey(),
        hasLogOut: false,
        hasBackButton: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text(
                    "Delete",
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: kPrimaryColor),
                  ),
                ),
              ),
              Obx(
                () => mediaController.isLoading.value ||
                        contactController.isLoading.value
                    ? Container() // Because there is already a loading indicator
                    : (mediaController.pictureList.length == 0 &&
                            mediaController.musicList.length == 0 &&
                            mediaController.videoList.length == 0 &&
                            contactController.contactList.length == 0)
                        ? Expanded(
                            child: Center(
                              child: ZeroResult(
                                  text:
                                      "You have not uploaded anything so far..."),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                            child: TabBar(
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return kPrimaryLightColor; // Use the component's default.
                                },
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              controller: _tabController,
                              labelColor: kPrimaryColor,
                              isScrollable: false,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(45),
                                      topRight: Radius.circular(45)),
                                  color: kPrimaryLightColor),
                              indicatorColor: Colors.transparent,
                              unselectedLabelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                              labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                              tabs: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Photos & Videos'),
                                      SizedBox(width: 15),
                                      SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: SvgPicture.asset(
                                              'assets/icons/blue_photos.svg')),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Songs'),
                                      SizedBox(width: 15),
                                      SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: SvgPicture.asset(
                                              'assets/icons/blue_music.svg')),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Contacts'),
                                      SizedBox(width: 15),
                                      SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: SvgPicture.asset(
                                              'assets/icons/blue_contact.svg')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
              Obx(
                () => mediaController.isLoading.value ||
                        contactController.isLoading.value
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : (mediaController.pictureList.length != 0 ||
                            mediaController.musicList.length != 0 ||
                            mediaController.videoList.length != 0 ||
                            contactController.contactList.length != 0)
                        ? Expanded(
                            child: ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.center,
                                  colors: [Colors.transparent, Colors.black],
                                ).createShader(Rect.fromLTRB(
                                    0, 0, rect.width, rect.height));
                              },
                              blendMode: BlendMode.dstIn,
                              child: TabBarView(
                                controller: _tabController,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(45),
                                            bottomRight: Radius.circular(45)),
                                        color: kPrimaryLightColor),
                                    child: Text(
                                      'Photos and Videos',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(45),
                                            bottomRight: Radius.circular(45)),
                                        color: kPrimaryLightColor),
                                    child: Text(
                                      'Music',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(45),
                                            bottomRight: Radius.circular(45)),
                                        color: kPrimaryLightColor),
                                    child: Text(
                                      'Contacts',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        // This shouldn't be called
                        : Container(),
              ),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SecondaryButton(
                        text: "Delete",
                        key: UniqueKey(),
                        color: Colors.white60,
                        textColor: Color.fromRGBO(250, 60, 112, 1),
                        borderColor: Color.fromRGBO(250, 60, 112, 1),
                        widthRatio: 0.25,
                        press: () {}),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteController extends GetxController {
  var musicList = List<Media>.from([]).obs;
  var pictureList = List<Media>.from([]).obs;
  var videoList = List<Media>.from([]).obs;
  var contactList = List<Contact>.from([]).obs;

  var isSelectedMusicList = List<bool>.from([]).obs;
  var isSelectedPictureList = List<bool>.from([]).obs;
  var isSelectedVideoList = List<bool>.from([]).obs;
  var isSelectedContactList = List<bool>.from([]).obs;

  MediaController mediaController = Get.put<MediaController>(MediaController());
  ContactController contactController =
      Get.put<ContactController>(ContactController());

  @override
  void onInit() {
    super.onInit();
  }

  void setList(
      {required List<Media> newMusicList,
      required List<Media> newPictureList,
      required List<Media> newVideoList,
      required List<Contact> newContactList}) {
    musicList.value = newMusicList;
    pictureList.value = newPictureList;
    videoList.value = newVideoList;
    contactList.value = newContactList;

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

    if (mediaIdsToDelete.length != 0)
      mediaController.multiDeleteMedia(id: mediaIdsToDelete);
    if (contactIdsToDelete.length != 0)
      contactController.multiDeleteContact(id: contactIdsToDelete);
  }
}
