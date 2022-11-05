import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

import 'memory_service.dart';

AudioPlayer appPlayer = AudioPlayer();

class BooksPlayer extends StatefulWidget {
  const BooksPlayer({Key? key}) : super(key: key);

  @override
  State<BooksPlayer> createState() => _BooksPlayerState();
}

class _BooksPlayerState extends State<BooksPlayer> {
  final MemoryService _memory = MemoryService();
  late Timer _timer;

  _BooksPlayerState() {
    _timer = Timer(const Duration(seconds: 5), () {
      if (!appPlayer.playing) return;

      _memory.setLastPlayedChapterPosition(appPlayer.position);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CupertinoButton(
              child: Text('back 15'),
              onPressed: () {
                int position = appPlayer.position.inSeconds;

                appPlayer.seek(Duration(seconds: position - 15));
              }),
          CupertinoButton(
              child: Text('play pause'),
              onPressed: () async {
                appPlayer.playing
                    ? await appPlayer.pause()
                    : await appPlayer.play();
              }),
          CupertinoButton(
              child: Text('forw 15'),
              onPressed: () {
                int position = appPlayer.position.inSeconds;

                appPlayer.seek(Duration(seconds: position + 15));
              }),
        ]);
  }
}
