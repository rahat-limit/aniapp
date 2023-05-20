import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class FileSystem {
  Future createOrUseDB() async {
    final dbPath = await sql.getDatabasesPath();
    sql.openDatabase(
      path.join(dbPath, 'collection.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE anime_titles(id TEXT PRIMARY KEY, code TEXT, )');
        //   final int id;
        // final String code;
        // final Map<String, dynamic> names;
        // final String description;
        // final dynamic announce;
        // List<dynamic>? genres = [];
        // final Map<String, dynamic> team;
        // final Map<String, dynamic> season;
        // final Map<String, dynamic> status;
        // final Map<String, dynamic> posters;
        // final Map<String, dynamic> type;
        // final Map<String, dynamic> player;
        // String rating;
        // String ageRating;
        // bool isLiked = false;
        // String trailer;
      },
    );
  }

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
