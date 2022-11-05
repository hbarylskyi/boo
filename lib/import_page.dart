import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({
    super.key,
  });

  // final String title;

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  List<PlatformFile> _files = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: true);

    String? firstPath = result?.files[0].path;

    if (result?.files == null || firstPath == null) {
      throw ErrorDescription('Damn dude its empty here');
    }

    // var file = File(firstPath);
    // var metadata = await MetadataRetriever.fromFile(file);
    // print(metadata);

    setState(() {
      _files = result?.files ?? [];
    });

    _importFiles(_files);
  }

  void _importFiles(List<PlatformFile> files) async {
    final appDocuments = await getApplicationDocumentsDirectory();

    for (var pFile in files) {
      var filePath = pFile.path;

      if (filePath != null) {
        var file = File(filePath);
        var metadata = await MetadataRetriever.fromFile(file);
        var bookName = metadata.albumName ??
            metadata.albumArtistName ??
            metadata.authorName ??
            'Unknown book';

        Directory bookDir = Directory(appDocuments.path + '/' + bookName);
        bool exists = await bookDir.exists();

        if (!exists) {
          await bookDir.create();
        }

        File copiedFile = await file.copy(bookDir.path + '/' + pFile.name);
        print(copiedFile.path + ' copied');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Import your files here'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoButton(
                child: Text('Import from files'), onPressed: _pickFiles),
            Column(
              children: _files.map((e) => Text(e.name)).toList(),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
