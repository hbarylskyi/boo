import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../book_page.dart';

class MemoryService {
  SharedPreferences? _prefsInstance;

  Future<SharedPreferences> _getPrefs() async {
    _prefsInstance ??= await SharedPreferences.getInstance();

    return _prefsInstance as SharedPreferences;
  }

  setLastPlayedChapterPosition(Duration position) async {
    (await _getPrefs()).setInt('last_chapter_position', position.inSeconds);

    print("set player position: ${position.inSeconds} sec");
  }

  Future<Duration?> getLastPlayedChapterPosition() async {
    int? pos = (await _getPrefs()).getInt('last_played_chapter_position');

    if (pos != null) return Duration(seconds: pos);
    return null;
  }

  setLastPlayedChapter(Chapter chapter) async {
    (await _getPrefs()).setString('last_chapter_path', chapter.file.path);
    print("set chapter: ${chapter.file.path}");
  }

  Future<Chapter?> getLastPlayedChapter() async {
    String? path = (await _getPrefs()).getString('last_chapter_path');

    if (path != null) return Chapter(file: File(path));
    return null;
  }
}
