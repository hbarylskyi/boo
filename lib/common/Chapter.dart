import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import '../pages/books_page.dart';

class Chapter {
  File file;
  Metadata? metadata;
  late Future<Metadata> metadataFuture;
  late String name;

  Chapter({required this.file}) {
    name = getFileName(file);

    metadataFuture =
        MetadataRetriever.fromFile(file).then((meta) => metadata = meta);
  }
}
