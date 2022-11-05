import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'books_page.dart';

// late AudioHandler audioHandler;
// var _player = AudioPlayer()

Future<void> main() async {
  // audioHandler = await AudioService.init(
  //   builder: () => MyAudioHandler(),
  //   config: const AudioServiceConfig(
  //     androidNotificationChannelId: 'com.audiobooks.minimal',
  //     androidNotificationChannelName: 'Minimal Audiobooks',
  //     androidNotificationOngoing: true,
  //   ),
  // );

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.audiobooks.minimal',
    androidNotificationChannelName: 'Minimal Audiobooks',
    androidNotificationOngoing: true,
      rewindInterval: const Duration(seconds: 15),
      fastForwardInterval: const Duration(seconds: 15)
  );


  runApp(const AudiobooksApp());
}


class AudiobooksApp extends StatelessWidget {
  const AudiobooksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Minimal Audiobooks',
      theme: CupertinoThemeData(primaryColor: Colors.black),
      home: BooksPage(),
    );
  }
}
