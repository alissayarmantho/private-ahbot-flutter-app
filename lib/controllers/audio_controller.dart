import 'package:botapp/models/media.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  // This will play audio after u back. And unfortunately when you go
  // to another tile, it will play the audio again, causing overlapping audio
  // TODO: Fix this

  // Ideally we can use the playlist feature of this library, but I am not sure why
  // I think the initialization didn't work
  // TODO: Find out why
  final player = AudioPlayer().obs;

  var isLoading = false.obs;
  var isPlaying = false.obs;
  var musicList = List<Media>.from([]).obs;
  var currIndex = 0.obs;
  var currTitle = "".obs;

  var currPosition = new Duration().obs;
  var currBuffered = new Duration().obs;
  var currMusicLength = new Duration().obs;

  var currPlayer;

  @override
  void onInit() {
    super.onInit();
  }

  void initializeListeningAfterSettingCurrPlayer() {
    listenToCurrPlayerPosition();
    listenToCurrPlayerState();
  }

  void setMusicList(List<Media> newMusicList) {
    musicList.value = newMusicList;
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

  void nextCurrPlayerSong() {
    if (currIndex.value == musicList.length - 1) {
      setCurrIndex(0);
    } else {
      setCurrIndex(currIndex.value + 1);
    }
  }

  void prevCurrPlayerSong() {
    if (currIndex.value == 0) {
      setCurrIndex(musicList.length - 1);
    } else {
      setCurrIndex(currIndex.value - 1);
    }
  }

  void listenToCurrPlayerPosition() {
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
      isPlaying.value = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        isLoading.value = true;
      } else {
        isLoading.value = false;
      }
      if (processingState == ProcessingState.completed) {
        nextCurrPlayerSong();
      }
    });
  }

  // setting current index will also reinitialize the current player to play
  // the song of the current index and set the title
  void setCurrIndex(int value) {
    currIndex.value = value;
    initCurrPlayer(musicList[currIndex.value].link);
    currTitle.value = musicList[currIndex.value].title;
  }

  String getNextSongTitle() {
    if (currIndex.value == musicList.length - 1) {
      return musicList[0].title;
    }
    return musicList[currIndex.value + 1].title;
  }

  void playCurrPlayer() {
    currPlayer.value.play();
  }

  void pauseCurrPlayer() {
    currPlayer.value.pause();
  }

  void currPlayerSeek(Duration position) {
    currPlayer.value.seek(position);
  }
}
