import 'package:shared_preferences/shared_preferences.dart';

import 'book_page.dart';

class MemoryService {
  late SharedPreferences _prefsInstance;

  MemoryService() {
    SharedPreferences.getInstance().then((value) => _prefsInstance = value);
  }

  setLastPlayedChapterPosition(Duration position) {
    _prefsInstance.setInt('last_chapter_position', position.inSeconds);
  }

  String? getLastPlayedChapter() {
    String? name = _prefsInstance.getString('last_chapter');
    return name;
  }

  setLastPlayedChapter(Chapter chapter) {
    _prefsInstance.setString('last_chapter', chapter.name);
  }

  Duration? getLastPlayedChapterPosition() {
    int? pos = _prefsInstance.getInt('last_played_chapter_position');

    if (pos != null) return Duration(seconds: pos);
    return null;
  }
}
