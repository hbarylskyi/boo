import 'dart:io';

import 'package:audiobooks_minimal/book_page.dart';
import 'package:audiobooks_minimal/audio/books_player.dart';
import 'package:audiobooks_minimal/import_page.dart';
import 'package:audiobooks_minimal/main.dart';
import 'package:audiobooks_minimal/memory/memory_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'audio/boo_audio_handler.dart';

String getFileOrDirName(FileSystemEntity dir) {
  return dir.path.split(Platform.pathSeparator).last;
}

class BooksPage extends StatefulWidget {
  const BooksPage({
    super.key,
  });

  // final String title;

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  List<FileSystemEntity> _books = [];
  MemoryService _memory = MemoryService();

  @override
  void initState() {
    super.initState();
    _readSavedBooksFromFs();
    _readLastPlayedChapter();

    audioHandler.play();
  }

  Future<void> _readSavedBooksFromFs() async {
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> books = await appDocumentsDir.list().toList();

    setState(() {
      _books = books;
    });
  }

  Future<void> _readLastPlayedChapter() async {
    Chapter? lastChapter = await _memory.getLastPlayedChapter();
    Duration? lastPosition = await _memory.getLastPlayedChapterPosition();

    if (lastChapter != null) {
      audioHandler.playChapter(lastChapter, lastPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Books'),
          trailing: CupertinoButton(
              child: const Icon(CupertinoIcons.tray_arrow_down),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const ImportPage()),
                );
              }),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: _books.map(_renderBook).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const BooksPlayer()
            ],
          ),
        ));
  }

  Widget _renderBook(FileSystemEntity dir) {
    String name = getFileOrDirName(dir);

    return CupertinoButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) =>
                      BookPage(name: name, dir: dir as Directory)));
        },
        child: Text(name));
  }
}
