import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PawdioDb {
  static final _databaseName = 'PawdioDatabase.db';
  static final _databaseVersion = 1;

  static Database _database;

  static Future<void> setupDb() async {
    print('\n****Setting up DB****\n');
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);

    _database = await openDatabase(path, version: _databaseVersion,
        onCreate: (Database db, int version) async {
      print('creating db');
      await db.execute(
          // TODO: Create tables for bookmarks & notes, and foreign keys to them in the the audio table
          'CREATE TABLE Audios (file_path TEXT UNIQUE, last_position INTEGER)');
    });
  }

  Future<void> deleteDB() async {
    print('deletingdb');
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);
    deleteDatabase(path);
  }

//  $$$$$$\  $$\   $$\ $$$$$$$$\ $$$$$$$\  $$$$$$\ $$$$$$$$\  $$$$$$\
// $$  __$$\ $$ |  $$ |$$  _____|$$  __$$\ \_$$  _|$$  _____|$$  __$$\
// $$ /  $$ |$$ |  $$ |$$ |      $$ |  $$ |  $$ |  $$ |      $$ /  \__|
// $$ |  $$ |$$ |  $$ |$$$$$\    $$$$$$$  |  $$ |  $$$$$\    \$$$$$$\
// $$ |  $$ |$$ |  $$ |$$  __|   $$  __$$<   $$ |  $$  __|    \____$$\
// $$ $$\$$ |$$ |  $$ |$$ |      $$ |  $$ |  $$ |  $$ |      $$\   $$ |
// \$$$$$$ / \$$$$$$  |$$$$$$$$\ $$ |  $$ |$$$$$$\ $$$$$$$$\ \$$$$$$  |
//  \___$$$\  \______/ \________|\__|  \__|\______|\________| \______/
//      \___|

  Future<List<Map<String, dynamic>>> queryAudioForFilePath(
      String filePath) async {
    print('\n****Querying for filepath****\n');
    try {
      List<Map<String, dynamic>> res = await _database.transaction((ctx) async {
        return ctx.rawQuery(
            'SELECT file_path FROM Audios WHERE file_path=(?)', [filePath]);
      });
      print('select filepath result: $res');

      List<Map<String, dynamic>> res2 = await _database.transaction((ctx) async {
        return ctx.rawQuery(
            'SELECT file_path FROM Audios');
      });
      print('select ALL filepaths result: $res2');
      return res;
    } catch (e) {
      print('this bitch ass query empty yeet. error: $e');
      return [];
    }
  }

  Future<void> createAudio(chosenFilePath) async {
    print('Inserting!');
    Map<String, dynamic> row = {
      'file_path': chosenFilePath,
      'last_position': 0,
    };

    await _database.transaction((ctx) async {
      await ctx.insert('Audios', row);
    });
  }
}
