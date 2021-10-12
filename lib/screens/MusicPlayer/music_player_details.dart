import 'package:audioplayers/audioplayers.dart';
import 'package:botapp/constants.dart';
import 'package:botapp/models/media.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/svg_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MusicPlayerDetails extends StatelessWidget {
  final int currentIndex;
  final List<Media> musicList;

  MusicPlayerDetails(
      {Key? key, required this.currentIndex, required this.musicList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioController = Get.put<AudioController>(AudioController());
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
                    child: Container(
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        image: DecorationImage(
                            image: NetworkImage(
                              //TODO: Change this to use album art
                              "https://i.ibb.co/5jrXNLV/musicdefaultimg.png",
                            ),
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Stargazer",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${audioController.position.value.inMinutes}:${audioController.position.value.inSeconds.remainder(60)}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Container(
                                width: size.width * 0.4,
                                child: Slider.adaptive(
                                    activeColor:
                                        Color.fromRGBO(24, 160, 251, 1),
                                    inactiveColor: Colors.grey[350],
                                    value: audioController
                                        .position.value.inSeconds
                                        .toDouble(),
                                    max: audioController
                                        .musicLength.value.inSeconds
                                        .toDouble(),
                                    onChanged: (value) {
                                      audioController.seekToSec(value.toInt());
                                    }),
                              ),
                              Text(
                                "${audioController.musicLength.value.inMinutes}:${audioController.musicLength.value.inSeconds.remainder(60)}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
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
                            press: () {},
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Obx(
                            () => Ink(
                              padding: EdgeInsets.all(10),
                              child: IconButton(
                                iconSize: 100,
                                color: Colors.white,
                                splashColor: Colors.transparent,
                                // because splash radius cannot be 0 but
                                // I don't want to have a splash radius
                                splashRadius: 1,
                                onPressed: () async {
                                  //here we will add the functionality of the play button
                                  // if (!audioController.playing.value) {
                                  //now let's play the song
                                  audioController.player.value.play(
                                      'https://luan.xyz/files/audio/ambient_c_motion.mp3');
                                },
                                icon: Icon(
                                  audioController.playing.value
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
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
                            press: () {},
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
                        child: Text("No contacts available ..."),
                      ),
                    ],
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

class AudioController extends GetxController {
  var player = AudioPlayer().obs;
  var isLoading = false.obs;
  var playing = false.obs;

  var position = new Duration().obs;
  var musicLength = new Duration().obs;

  @override
  void onInit() {
    super.onInit();
  }

  void play(String url) async {
    //here we will add the functionality of the play button
    if (!playing.value) {
      await player.value
          .play('http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p')
          .then((res) => {
                playing.value = true,
                getDuration(),
                getPosition(),
                print(playing.value)
              })
          .catchError((err) {
        Get.snackbar(
          "Error Playing Music File",
          err,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    } else {
      player.value.pause();
      playing.value = false;
    }
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    player.value.seek(newPos);
  }

  void getDuration() {
    player.value.onDurationChanged.listen((Duration d) {
      musicLength.value = d;
    });
  }

  void getPosition() {
    player.value.onAudioPositionChanged
        .listen((Duration p) => position.value = p);
  }
}
