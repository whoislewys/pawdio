import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PawdioDb {
  static final _databaseName = 'PawdioDatabase.db';
  static final _databaseVersion = 1;
  Database _database;

  // Singleton pattern using private constructor so only one PawdioDb exists throughout whole app
  PawdioDb._privateConstructor() {
    print(' private constructor ');
  }
  static Future<PawdioDb> create() async {
    PawdioDb pawdioDb = PawdioDb._privateConstructor();
    await pawdioDb.setupDb();
    return pawdioDb;
  }

  Future<void> setupDb() async {
    if (_database != null) {
      // ensure that setup only gets called once
      return;
    }

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
    print('***** DB SETUP COMPLETE ! *****');
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
    try {
      List<Map<String, dynamic>> res = await _database.transaction((ctx) async {
        return ctx.rawQuery(
            'SELECT * FROM Audios WHERE file_path=(?)', [filePath]);
      });
      return res;
    } catch (e) {
      print('this bitch ass query empty yeet. error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllAudios() async {
    try {
      List<Map<String, dynamic>> res = await _database.transaction((ctx) async {
        return ctx.rawQuery(
            'SELECT * FROM Audios');
      });
      return res;
    } catch (e) {
      print('Error getting all audios. error: $e');
      return [];
    }
  }

  Future<void> createAudio(filePath) async {
    print('Inserting!');
    Map<String, dynamic> row = {
      'file_path': filePath,
      'last_position': 0,
    };

    await _database.transaction((ctx) async {
      await ctx.insert('Audios', row);
    });
  }

  Future<void> updateLastPosition(String filePath, int newPlayPosition) async {
    try {
      await _database.transaction((ctx) async {
        await ctx.rawUpdate(
            'UPDATE Audios SET last_position=? WHERE file_path=?',
            [newPlayPosition, filePath]);
      });
    } catch (e) {
      print('woopsie poopsie, update failed. quietly failing');
    }
  }

}
