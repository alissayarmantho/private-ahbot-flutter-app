import 'package:botapp/constants.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:botapp/controllers/audio_controller.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/svg_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Note this music playing will do weird things when the caregiver deletes songs
// while the elderly is playing the song

// TODO: Find out exactly what it does and fix it
class MusicPlayerDetails extends StatelessWidget {
  final int currentIndex;

  MusicPlayerDetails({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioController = Get.find<AudioController>();
    if (audioController.currIndex.value != currentIndex ||
        !audioController.isPlaying.value) {
      audioController.setCurrIndex(currentIndex);
    }
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AppHeader(
        key: key,
        hasBackButton: true,
        hasLogOut: false,
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(
              top: 48.0,
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Obx(() => Container(
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            image: DecorationImage(
                                image: NetworkImage(
                                  audioController.currMusicPicPath.value == ""
                                      ? "https://i.ibb.co/5jrXNLV/musicdefaultimg.png"
                                      : audioController
                                              .currMusicPicPath.value ??
                                          "https://i.ibb.co/5jrXNLV/musicdefaultimg.png",
                                ),
                                fit: BoxFit.contain),
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            audioController.currTitle.value,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: Obx(
                            () => Container(
                              width: size.width * 0.4,
                              child: ProgressBar(
                                progress: audioController.currPosition.value,
                                buffered: audioController.currBuffered.value,
                                total: audioController.currMusicLength.value,
                                onSeek: audioController.currPlayerSeek,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SVGButton(
                              key: UniqueKey(),
                              size: 100,
                              svgAssetPath: 'assets/icons/prev_song.svg',
                              press: () {
                                audioController.prevCurrPlayerSong();
                              },
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Obx(
                              () => Ink(
                                padding: EdgeInsets.all(10),
                                child: audioController.isLoading.value
                                    ? SizedBox(
                                        width: 116,
                                        height: 116,
                                        child: Center(
                                            child: CircularProgressIndicator()))
                                    : audioController.isPlaying.value
                                        ? IconButton(
                                            iconSize: 100,
                                            color: Colors.white,
                                            splashColor: Colors.transparent,
                                            // because splash radius cannot be 0 but
                                            // I don't want to have a splash radius
                                            splashRadius: 1,
                                            onPressed: () async {
                                              audioController.pauseCurrPlayer();
                                            },
                                            icon: Icon(Icons.pause))
                                        : IconButton(
                                            iconSize: 100,
                                            color: Colors.white,
                                            splashColor: Colors.transparent,
                                            // because splash radius cannot be 0 but
                                            // I don't want to have a splash radius
                                            splashRadius: 1,
                                            onPressed: () async {
                                              audioController.playCurrPlayer();
                                            },
                                            icon: Icon(Icons.play_arrow),
                                          ),
                                decoration: ShapeDecoration(
                                    color: Color.fromRGBO(86, 204, 242, 1),
                                    shape: CircleBorder()),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            SVGButton(
                              key: UniqueKey(),
                              size: 100,
                              svgAssetPath: 'assets/icons/next_song.svg',
                              press: () {
                                audioController.nextCurrPlayerSong();
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: size.width * 0.415,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: kPrimaryLightColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(40),
                            ),
                          ),
                          child: Obx(
                            () => Text("Next song: " +
                                audioController.getNextSongTitle()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
