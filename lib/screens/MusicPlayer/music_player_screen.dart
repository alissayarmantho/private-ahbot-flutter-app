import 'package:botapp/controllers/audio_controller.dart';
import 'package:botapp/controllers/media_controller.dart';
import 'package:botapp/controllers/user_controller.dart';
import 'package:botapp/models/user.dart';
import 'package:botapp/screens/MusicPlayer/music_player_details.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/zero_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MusicPlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User currentUser = Get.find<UserController>().currentUser.value;

    final MediaController mediaController =
        Get.put<MediaController>(MediaController());
    var audioController = Get.find<AudioController>();
    mediaController.fetchAllMedia(mediaType: "music", elderId: currentUser.id);
    return Scaffold(
      body: AppHeader(
        key: key,
        hasBackButton: true,
        hasLogOut: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 15, 40, 0),
              child: Text(
                'Music',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => mediaController.isLoading.value
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : mediaController.musicList.length == 0
                      ? ZeroResult(
                          text:
                              "I think you have not uploaded anything so far...")
                      : Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                return RawMaterialButton(
                                  onPressed: () {
                                    audioController.setMusicList(
                                        mediaController.musicList);
                                    Get.to(() => MusicPlayerDetails(
                                          currentIndex: index,
                                        ));
                                  },
                                  child: Hero(
                                    tag: 'logo$index',
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            "https://i.ibb.co/5jrXNLV/musicdefaultimg.png",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: mediaController.musicList.length,
                            ),
                          ),
                        ),
            )
          ],
        ),
      ),
    );
  }
}
