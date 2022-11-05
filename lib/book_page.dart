import 'dart:io';

import 'package:audiobooks_minimal/memory_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'books_player.dart';
import 'books_page.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

import 'package:audio_service/audio_service.dart';

class Book {}

class Chapter {
  File file;
  late Metadata? meta;
  late String name;

  Chapter({required this.file}) {
    name = getFileOrDirName(file);

    MetadataRetriever.fromFile(file).then((meta) => this.meta = meta);
  }
}

class BookPage extends StatefulWidget {
  final String name;
  final Directory dir;

  const BookPage({super.key, required this.name, required this.dir});

  @override
  State<StatefulWidget> createState() {
    return _BookPageState();
  }
}

class _BookPageState extends State<BookPage> {
  List<Chapter> _chapters = [];
  final MemoryService _memory = MemoryService();

  @override
  initState() {
    super.initState();

    _readBookChaptersFromFs();
  }

  Future<void> _readBookChaptersFromFs() async {
    List<Chapter> chapters =
        await widget.dir.list().map((f) => Chapter(file: f as File)).toList();

    setState(() {
      _chapters = chapters;
    });

    appPlayer.playbackEventStream.listen((event) {});
  }

  _playChapter(Chapter chapter) async {
    Metadata? meta = chapter.meta;
    if (meta == null) return Container();

    AudioSource item = AudioSource.uri(
      Uri.file(chapter.file.path),
      tag: MediaItem(
        id: chapter.file.path,
        title: meta.trackName ?? chapter.name,
        artist: meta.albumName ?? meta.albumArtistName,
      ),
    );

    await appPlayer.setAudioSource(item);
    await appPlayer.play();

    _memory.setLastPlayedChapter(chapter);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _chapters.map(_renderChapter).toList(),
            )),
          ),
          const BooksPlayer()
        ],
      ),
    ));
  }

  Widget _renderChapter(Chapter chapter) => CupertinoButton(
      onPressed: _playChapter(chapter), child: Text(chapter.name));
}
