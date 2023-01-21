import 'dart:io';

import 'package:audiobooks_minimal/memory/memory_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksCubit extends Cubit<List<FileSystemEntity>> {
  BooksCubit() : super([]);

  final _memory = MemoryService();

  void read() async {
    List<FileSystemEntity> books = await _memory.readSavedBooks();
    emit(books);
  }
}