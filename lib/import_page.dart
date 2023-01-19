import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

// TODO move memory logic to a service
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

  Future<void> _pickFiles(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: true);

    String? firstPath = result?.files[0].path;

    if (result?.files == null || firstPath == null) {
      throw ErrorDescription('No files picked');
    }

    setState(() {
      _files = result?.files ?? [];
    });

    await _importFiles(_files);

    Navigator.pop(context);
  }

  Future<void> _importFiles(List<PlatformFile> files) async {
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

        Directory bookDir = Directory('${appDocuments.path}/$bookName');
        bool exists = await bookDir.exists();

        if (!exists) {
          await bookDir.create();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Import'),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                      'put audio files on your device, then select them using the button below.',
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'more import options are coming.',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.black87,
                child: CupertinoButton(
                    onPressed: () => _pickFiles(context),
                    child: const Text(
                      'Import from files',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
