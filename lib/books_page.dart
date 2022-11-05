import 'dart:io';

import 'package:audiobooks_minimal/book_page.dart';
import 'package:audiobooks_minimal/books_player.dart';
import 'package:audiobooks_minimal/import_page.dart';
import 'package:audiobooks_minimal/memory_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    appPlayer.play();
  }

  Future<void> _readSavedBooksFromFs() async {
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> books = await appDocumentsDir.list().toList();

    setState(() {
      _books = books;
    });
  }

  Future<void> _readLastPlayedChapter() async {
    _memory.getLastPlayedChapter();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Books'),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ..._books.map(_renderBook),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const ImportPage()),
                      );
                    },
                    child: Text('Import more'),
                  ),
                ],
              ),
            ),
            const SafeArea(child: BooksPlayer())
          ],
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
