import 'package:audio_service/audio_service.dart';
import 'package:audiobooks_minimal/pages/books_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'audio/boo_audio_handler.dart';

late BooAudioHandler audioHandler;

Future<void> main() async {
  audioHandler = await AudioService.init(
    builder: () => BooAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.audiobooks.minimal',
      androidNotificationChannelName: 'Boo',
      androidNotificationOngoing: true,
    ),
  );

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
    );

    return CupertinoApp(
      title: 'Boo',
      theme: booTheme,
      home: const BooksPage(),
    );
  }
}
