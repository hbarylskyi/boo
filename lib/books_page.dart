import 'dart:io';

import 'package:audiobooks_minimal/book_page.dart';
import 'package:audiobooks_minimal/audio/books_player.dart';
import 'package:audiobooks_minimal/import_page.dart';
import 'package:audiobooks_minimal/main.dart';
import 'package:audiobooks_minimal/memory/memory_service.dart';
import 'package:flutter/cupertino.dart';

import 'common/Chapter.dart';

// reads file/directory name
String getFileName(FileSystemEntity dir) {
  return dir.path.split(Platform.pathSeparator).last;
}

class BooksPage extends StatefulWidget {
  const BooksPage({
    super.key,
  });

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  List<FileSystemEntity> _books = [];
  final MemoryService _memory = MemoryService();

  @override
  void initState() {
    super.initState();
    _readSavedBooks();
    _readLastPlayedChapter();

    audioHandler.play();
  }

  Future<void> _readSavedBooks() async {
    List<FileSystemEntity> books = await _memory.readSavedBooks();

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

  Widget _renderBook(FileSystemEntity bookDir) {
    String name = getFileName(bookDir);

    return CupertinoButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) =>
                      BookPage(name: name, directory: bookDir as Directory)));
        },
        child: Text(name));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Books'),
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
                      child: _books.isNotEmpty
                          ? GridView.count(
                              crossAxisCount: 2,
                              children: _books.map(_renderBook).toList(),
                            )
                          : const Center(
                              child: Text('No books. Use the import button')),
                    ),
                  ],
                ),
              ),
              const BooksPlayer()
            ],
          ),
        ));
  }
}
