import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:just_audio_background/just_audio_background.dart';
import 'audio/boo_audio_handler.dart';
import 'books_page.dart';

late BooAudioHandler audioHandler;
// var _player = AudioPlayer()

Future<void> main() async {
  audioHandler = await AudioService.init(
    builder: () => BooAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.audiobooks.minimal',
      androidNotificationChannelName: 'Minimal Audiobooks',
      androidNotificationOngoing: true,
    ),
  );

  // await JustAudioBackground.init(
  //     androidNotificationChannelId: 'com.audiobooks.minimal',
  //     androidNotificationChannelName: 'Minimal Audiobooks',
  //     androidNotificationOngoing: true,
  //     rewindInterval: const Duration(seconds: 15),
  //     fastForwardInterval: const Duration(seconds: 15));

  runApp(const AudiobooksApp());
}

class AudiobooksApp extends StatelessWidget {
  const AudiobooksApp({super.key});

  @override
  Widget build(BuildContext context) {
    CupertinoThemeData parentTheme = CupertinoTheme.of(context);
    CupertinoThemeData booTheme = parentTheme.copyWith(
      primaryColor: Colors.black87,
      primaryContrastingColor: Colors.white60,
      brightness: Brightness.light,

      textTheme: const CupertinoTextThemeData(primaryColor: Colors.white60),

//          fontFamily: 'Georgia'
//          textTheme: const TextTheme(
//          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
//          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
//        ),
    );

    return CupertinoApp(
      title: 'Minimal Audiobooks',
      theme: booTheme,
      home: BooksPage(),
    );
  }
}
