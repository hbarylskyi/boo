import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks_minimal/memory/memory_service.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:just_audio/just_audio.dart';

import '../common/Chapter.dart';

class BooAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final MemoryService _memory = MemoryService();
  final AudioPlayer appPlayer = AudioPlayer();

  Timer? speedDownTimer;
  Timer? speedUpTimer;

  Duration audioSpeedLongPressIncrementDuration =
      const Duration(milliseconds: 1500);

  BooAudioHandler();

  void speedDown() {
    appPlayer.setSpeed(appPlayer.speed - 0.05);
  }

  void speedUp() {
    appPlayer.setSpeed(appPlayer.speed + 0.05);
  }

  @override
  Future<void> play() async {
    appPlayer.play();
  }

  @override
  Future<void> pause() async {
    appPlayer.pause();
  }

  @override
  Future<void> stop() async {
    appPlayer.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    appPlayer.seek(position);
  }

  playChapter(Chapter chapter, [Duration? position]) async {
    Metadata metadata = await chapter.metadataFuture;

    AudioSource item = AudioSource.uri(
      Uri.file(chapter.file.path),
      tag: MediaItem(
        id: chapter.file.path,
        title: metadata.trackName ?? chapter.name,
        artist: metadata.albumName ?? metadata.albumArtistName,
      ),
    );

    await appPlayer.setAudioSource(item, initialPosition: position);
    await appPlayer.play();

    _memory.setLastPlayedChapter(chapter);
  }
}
