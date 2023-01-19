import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks_minimal/main.dart';
import 'package:audiobooks_minimal/memory/memory_service.dart';
import 'package:audiobooks_minimal/widgets/player_progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'audio/books_player.dart';
import 'common/Chapter.dart';

class BookPage extends StatefulWidget {
  final String name;
  final Directory directory;

  const BookPage({super.key, required this.name, required this.directory});

  @override
  State<StatefulWidget> createState() {
    return _BookPageState();
  }
}

class _BookPageState extends State<BookPage> {
  List<Chapter> _chapters = [];
  final MemoryService _memoryService = MemoryService();
  IndexedAudioSource? currentAudioSource;
  late StreamSubscription<SequenceState?> sequenceStateStream;

  @override
  initState() {
    super.initState();

    _readBookChapters();

    sequenceStateStream =
        audioHandler.appPlayer.sequenceStateStream.listen((event) {
      var currentSource = event?.currentSource;

      if (currentSource == null) return;

      currentAudioSource = currentSource;

      print(event?.currentSource?.tag);
    });
  }

  @override
  dispose() {
    super.dispose();
    sequenceStateStream.cancel();
  }

  Future<void> _readBookChapters() async {
    List<Chapter> chapters =
        await _memoryService.getBookChapters(widget.directory);

    setState(() {
      _chapters = chapters;
    });
  }

  Widget _renderChapter(Chapter chapter) {
    return Column(
      children: [
        Stack(
          children: [
            CupertinoButton(
                onPressed: () => audioHandler.playChapter(chapter),
                child: Text(chapter.name)),
            chapter.name == currentAudioSource?.tag.title
                ? const PlayerProgress()
                : Container(),
            Text(currentAudioSource?.tag.title)
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.name),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: _chapters.map(_renderChapter).toList(),
                ),
              ),
              const BooksPlayer()
            ],
          ),
        ));
  }
}
