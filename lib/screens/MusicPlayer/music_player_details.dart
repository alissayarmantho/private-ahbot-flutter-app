import 'package:botapp/constants.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:botapp/models/media.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/svg_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerDetails extends StatelessWidget {
  final int currentIndex;
  final List<Media> musicList;

  MusicPlayerDetails(
      {Key? key, required this.currentIndex, required this.musicList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioController = Get.put<AudioController>(
        AudioController(index: currentIndex, musicList: musicList));
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
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            musicList[audioController.currIndex.value].title,
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
                                // audioController.onPreviousSongButtonPressed();
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
                                              print("pause");
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
                                              print("play");
                                              // audioController.play();
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
                                // audioController.onNextSongButtonPressed();
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
                            () => Text(
                              "Next song: " +
                                  musicList[audioController
                                          .getNextSongIndex(musicList.length)]
                                      .title,
                            ),
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

class AudioController extends GetxController {
  // This will play audio after u back. And unfortunately when you go
  // to another tile, it will play the audio again, causing overlapping audio
  // TODO: Fix this
  final player = AudioPlayer().obs;

  var isLoading = false.obs;
  var isPlaying = false.obs;
  var index;
  var musicList;
  var currIndex = 0.obs;
  var currTitle = "".obs;

  var currPosition = new Duration().obs;
  var currBuffered = new Duration().obs;
  var currMusicLength = new Duration().obs;

  var currPlayer = AudioPlayer().obs;

  AudioController({required this.index, required this.musicList});

  @override
  void onInit() {
    setCurrIndex(index);
    // initialisePlaylist();
    // listenToPlayerState();
    // listenToPlayerPosition();
    initCurrPlayer(musicList[currIndex.value].link);
    listenToCurrPlayerPosition();
    listenToCurrPlayerState();
    super.onInit();
  }

  void initCurrPlayer(String link) async {
    await currPlayer.value.setUrl(link).catchError((err) {
      Get.snackbar(
        "Error Loading Music",
        err,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    });
  }

  void playCurrPlayer() {
    currPlayer.value.play();
  }

  void pauseCurrPlayer() {
    currPlayer.value.pause();
  }

  void nextCurrPlayerSong() {
    if (currIndex.value == musicList.length - 1) {
      currIndex.value = 0;
    } else {
      currIndex.value += 1;
    }
    initCurrPlayer(musicList[currIndex.value].link);
    currTitle.value = musicList[currIndex.value].title;
  }

  void prevCurrPlayerSong() {
    if (currIndex.value == 0) {
      currIndex.value = musicList.length - 1;
    } else {
      currIndex.value -= 1;
    }
    currPlayer.value.dispose();
    currPlayer.value = AudioPlayer();
    initCurrPlayer(musicList[currIndex.value].link);
    currTitle.value = musicList[currIndex.value].title;
  }

  void listenToPlayerState() {
    player.value.playerStateStream.listen((playerState) {
      print("listening to player state");
      isPlaying.value = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        isLoading.value = true;
      } else {
        isLoading.value = false;
      }
    });
  }

  void listenToPlayerPosition() {
    print("listening to player position");
    player.value.positionStream.listen((position) {
      currPosition.value = position;
    });
    player.value.durationStream.listen((totalDuration) {
      currMusicLength.value = totalDuration ?? Duration.zero;
    });
    player.value.bufferedPositionStream.listen((bufferedPosition) {
      currBuffered.value = bufferedPosition;
    });
  }

  void listenToCurrPlayerPosition() {
    print("listening to Curr player position");
    currPlayer.value.positionStream.listen((position) {
      currPosition.value = position;
    });
    currPlayer.value.durationStream.listen((totalDuration) {
      currMusicLength.value = totalDuration ?? Duration.zero;
    });
    currPlayer.value.bufferedPositionStream.listen((bufferedPosition) {
      currBuffered.value = bufferedPosition;
    });
  }

  void listenToCurrPlayerState() {
    currPlayer.value.playerStateStream.listen((playerState) {
      print("listening to player state");
      isPlaying.value = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        isLoading.value = true;
      } else {
        isLoading.value = false;
      }
    });
  }

  void listenForChangesInSequenceState() {
    player.value.sequenceStateStream.listen((sequenceState) {
      print("listening to sequence state");
      if (sequenceState == null) return;
      final currentItem = sequenceState.currentSource;
      setCurrIndex(sequenceState.currentIndex);
      currTitle.value = currentItem?.tag as String? ?? "";
    });
  }

  void initialisePlaylist() async {
    var audioSources =
        musicList.map((music) => AudioSource.uri(music.link, tag: music.title));
    // Will loop the entire playlist by default
    player.value.setLoopMode(LoopMode.all);
    print("initialisePlaylist");
    await player.value
        .setAudioSource(ConcatenatingAudioSource(children: [audioSources]))
        .then(
            (res) => Get.snackbar("Loaded Music Playlist Successfully", "Done"))
        .catchError((err) {
      Get.snackbar(
        "Error Loading Music Playlist",
        err,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    });
  }

  void onPreviousSongButtonPressed() {
    player.value.seekToPrevious();
  }

  void onNextSongButtonPressed() {
    player.value.seekToNext();
  }

  void setCurrIndex(int value) {
    currIndex.value = value;
  }

  int getNextSongIndex(int listLength) {
    if (currIndex.value == listLength - 1) {
      return 0;
    }
    return currIndex.value + 1;
  }

  void play() {
    player.value.play();
  }

  void pause() {
    player.value.pause();
  }

  void seek(Duration position) {
    player.value.seek(position);
  }

  void currPlayerSeek(Duration position) {
    currPlayer.value.seek(position);
  }
}
