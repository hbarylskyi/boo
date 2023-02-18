import 'dart:io';

import 'package:audiobooks_minimal/cubits/ChaptersCubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../audio/books_player.dart';
import '../../common/Chapter.dart';
import 'ChapterRow.dart';

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
  ChaptersCubit chaptersCubit = ChaptersCubit();

  @override
  initState() {
    super.initState();

    chaptersCubit.read(widget.directory);
  }

  @override
  dispose() {
    chaptersCubit.close();
    super.dispose();
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
                child: BlocBuilder<ChaptersCubit, List<Chapter>>(
                  bloc: chaptersCubit,
                  builder: (BuildContext context, chapters) {
                    chapters.sort((a, b) {
                      // print(a.metadata);
                      return a.name.compareTo(b.name);
                    });

                    return Column(
                        children: chapters
                            .map((chapter) => ChapterRow(
                                  chapter: chapter,
                                ))
                            .toList());
                  },
                ),
              ),
              const BooksPlayer()
            ],
          ),
        ));
  }
}
