import 'dart:io';

import 'package:audiobooks_minimal/main.dart';
import 'package:audiobooks_minimal/memory/memory_service.dart';
import 'package:flutter/cupertino.dart';
import 'audio/boo_audio_handler.dart';
import 'audio/books_player.dart';
import 'books_page.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

class Chapter {
  File file;
  Metadata? meta;
  late Future<Metadata> metaFuture;
  late String name;

  Chapter({required this.file}) {
    name = getFileOrDirName(file);

    metaFuture =
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

    audioHandler.appPlayer.playbackEventStream.listen((event) {});
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

  Widget _renderChapter(Chapter chapter) {
    return CupertinoButton(
        onPressed: () => audioHandler.playChapter(chapter),
        child: Text(chapter.name));
  }
}
