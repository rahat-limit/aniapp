import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileSystem {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/fav_titles.txt');
  }

  Future<File> writeData(String id) async {
    final file = await _localFile;

    return file.writeAsString(id);
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<void> removeData() async {
    final file = await _localFile;

    file.delete();
  }
}
