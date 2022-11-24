import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks_minimal/memory/memory_service.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:just_audio/just_audio.dart';

import '../book_page.dart';

class BooAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final MemoryService _memory = MemoryService();
  final AudioPlayer appPlayer = AudioPlayer();

  Timer? speedDownTimer;
  Timer? speedUpTimer;

  Duration audioSpeedLongPressIncrementDuration =
      const Duration(milliseconds: 1500);

  // final PlayerState state = PlayerState(false, ProcessingState.loading);

  void speedDown() {
    appPlayer.setSpeed(appPlayer.speed - 0.05);
  }

  void speedDownLongPressStart() {
    speedDown();

    speedDownTimer =
        Timer(audioSpeedLongPressIncrementDuration, () => speedDown());
  }

  void speedDownLongPressStop() {
    speedDownTimer?.cancel();
  }

  void speedUp() {
    appPlayer.setSpeed(appPlayer.speed + 0.05);
  }

  void speedUpLongPressStart() {
    speedUp();

    speedUpTimer = Timer(audioSpeedLongPressIncrementDuration, () => speedUp());
  }

  void speedUpLongPressStop() {
    speedUpTimer?.cancel();
  }

  Future<void> play() async {
    appPlayer.play();
  }

  Future<void> pause() async {
    appPlayer.pause();
  }

  Future<void> stop() async {
    appPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    appPlayer.seek(position);
  }

  // Future<void> skipToQueueItem(int i) async {
  // }

  playChapter(Chapter chapter, [Duration? position]) async {
    Metadata meta = await chapter.metaFuture;

    AudioSource item = AudioSource.uri(
      Uri.file(chapter.file.path),
      tag: MediaItem(
        id: chapter.file.path,
        title: meta.trackName ?? chapter.name,
        artist: meta.albumName ?? meta.albumArtistName,
      ),
    );

    await appPlayer.setAudioSource(item, initialPosition: position);
    await appPlayer.play();

    _memory.setLastPlayedChapter(chapter);
  }
}
