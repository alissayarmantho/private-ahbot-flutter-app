import 'package:botapp/constants.dart';
import 'package:botapp/controllers/contact_controller.dart';
import 'package:botapp/controllers/delete_controller.dart';
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
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = Get.find<UserController>().currentUser.value;
    // Assume that elderId is inherited from upload screen that had just fetched
    // it
    var elderId = currentUser.elderIds.length > 0
        ? currentUser.elderIds[0]
        // This will trigger an error as there is
        // no elder linked to the current caregiver
        // Currently it will default to uploading music
        // for potato
        : "61547e49adbc3d0023ab129c";
    MediaController mediaController = Get.find<MediaController>();
    ContactController contactController = Get.find<ContactController>();
    contactController.fetchAllContacts(elderId: elderId);
    mediaController.fetchAllMedia(mediaType: "picture", elderId: elderId);
    mediaController.fetchAllMedia(mediaType: "music", elderId: elderId);
    mediaController.fetchAllMedia(mediaType: "video", elderId: elderId);

    final DeleteController deleteController = Get.put<DeleteController>(
        DeleteController(
            mediaController: mediaController,
            contactController: contactController));
    deleteController.elderId.value = elderId;
    return Scaffold(
      body: AppHeader(
        key: UniqueKey(),
        hasLogOut: false,
        hasBackButton: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
          // This is really not the best way of doing this, but
          // I tried something else before that didn't work
          // TODO: Refactor this
          child: Obx(() {
            if (mediaController.isLoading.value ||
                contactController.isLoading.value) {
              return Column(
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
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
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
                            press: () {
                              deleteController.delete();
                            }),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              deleteController.setList();
              return Column(
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
                  (deleteController.pictureList.length == 0 &&
                          deleteController.musicList.length == 0 &&
                          deleteController.videoList.length == 0 &&
                          deleteController.contactList.length == 0)
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
                                    Expanded(child: Text('Photos & Videos')),
                                    SizedBox(width: 15),
                                    Flexible(
                                      child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: SvgPicture.asset(
                                              'assets/icons/blue_photos.svg')),
                                    ),
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
                  (deleteController.pictureList.length != 0 ||
                          deleteController.musicList.length != 0 ||
                          deleteController.videoList.length != 0 ||
                          deleteController.contactList.length != 0)
                      ? Expanded(
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [Colors.transparent, Colors.black],
                              ).createShader(
                                  Rect.fromLTRB(0, 0, rect.width, rect.height));
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
                                  child: ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount:
                                          deleteController.pictureList.length,
                                      itemBuilder: (context, index) {
                                        Media item =
                                            deleteController.pictureList[index];
                                        return Obx(() => CheckboxListTile(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(45),
                                              ),
                                              title: Text(item.title),
                                              value: deleteController
                                                  .isSelectedPictureList[index],
                                              onChanged: (bool? val) {
                                                deleteController
                                                        .isSelectedPictureList[
                                                    index] = val ?? false;
                                              },
                                            ));
                                      }),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(45),
                                          bottomRight: Radius.circular(45)),
                                      color: kPrimaryLightColor),
                                  child: ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount:
                                          deleteController.musicList.length,
                                      itemBuilder: (context, index) {
                                        Media item =
                                            deleteController.musicList[index];

                                        return Obx(() => CheckboxListTile(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(45),
                                              ),
                                              title: Text(item.title),
                                              value: deleteController
                                                  .isSelectedMusicList[index],
                                              onChanged: (bool? val) {
                                                deleteController
                                                        .isSelectedMusicList[
                                                    index] = val ?? false;
                                              },
                                            ));
                                      }),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(45),
                                          bottomRight: Radius.circular(45)),
                                      color: kPrimaryLightColor),
                                  child: ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount:
                                          deleteController.contactList.length,
                                      itemBuilder: (context, index) {
                                        Contact item =
                                            deleteController.contactList[index];
                                        return Obx(() => CheckboxListTile(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(45),
                                              ),
                                              title: Text(item.name),
                                              value: deleteController
                                                  .isSelectedContactList[index],
                                              onChanged: (bool? val) {
                                                deleteController
                                                        .isSelectedContactList[
                                                    index] = val ?? false;
                                              },
                                            ));
                                      }),
                                ),
                              ],
                            ),
                          ),
                        )
                      // This shouldn't be called
                      : Container(),
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
                            press: () {
                              deleteController.delete();
                            }),
                      ),
                    ],
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
