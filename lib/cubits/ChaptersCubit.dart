import 'dart:io';

import 'package:audiobooks_minimal/common/Chapter.dart';
import 'package:audiobooks_minimal/memory/memory_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChaptersCubit extends Cubit<List<Chapter>> {
  ChaptersCubit() : super([]);

  final _memory = MemoryService();

  void read(Directory bookDir) async {
    List<Chapter> chapters = await _memory.readChapters(bookDir);
    emit(chapters);
  }
}