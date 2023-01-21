import 'dart:io';

import 'package:audiobooks_minimal/audio/books_player.dart';
import 'package:audiobooks_minimal/cubits/BooksCubit.dart';
import 'package:audiobooks_minimal/main.dart';
import 'package:audiobooks_minimal/memory/memory_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/Chapter.dart';
import 'import_page.dart';
import 'books/book_page.dart';

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
  final MemoryService _memory = MemoryService();
  final booksCubit = BooksCubit();

  @override
  void initState() {
    super.initState();
    booksCubit.read();
    _playLastPlayedChapter();

    audioHandler.play();
  }

  Future<void> _playLastPlayedChapter() async {
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
                    BlocBuilder<BooksCubit, List<FileSystemEntity>>(
                      bloc: booksCubit,
                      builder: (BuildContext context, books) => Expanded(
                        child: books.isNotEmpty
                            ? GridView.count(
                                crossAxisCount: 2,
                                children: books.map(_renderBook).toList(),
                              )
                            : const Center(
                                child: Text('No books. Use the import button')),
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
}
