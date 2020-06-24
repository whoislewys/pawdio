import 'package:path/path.dart';
import 'package:pawdio/models/bookmark.dart';
import 'package:pawdio/models/note.dart';
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
    // await pawdioDb.deleteDB();
    return pawdioDb;
  }

  Future<void> setupDb() async {
    if (_database != null) {
      // ensure that setup only gets called once
      return;
    }

    print('\n****Setting up DB****\n');
    var databasesPath =
        await getDatabasesPath(); // /data/user/0/com.example.pawdio/databases
    print('databasesPath: $databasesPath');
    String path = join(databasesPath, _databaseName);

    try {
      print('opening db');
      // TODO: check if i actually need this to enable foreign key support. seems fucked
      final addForeignKeySupport = (Database db) async {
        print('addin fkey support');
        try {
          await db.execute('PRAGMA foreign_keys = ON');
        } catch (e) {
          print('error $e');
        }
      };
      _database = await openDatabase(path,
          version: _databaseVersion, onConfigure: addForeignKeySupport,
          onCreate: (Database db, int version) async {
        print('creating db');
        try {
          print('create table audio');
          try {
                      // id INTEGER PRIMARY KEY AUTOINCREMENT,
            await db.execute('''
                  CREATE TABLE IF NOT EXISTS Audios(
                      id INTEGER PRIMARY KEY AUTOINCREMENT,
                      file_path TEXT UNIQUE,
                      last_position INTEGER
                  );
                  ''');
          } catch (e) {
            print('Error creating Audio table: $e');
          }

          try {
            print('create table bookmarks');
            await db.execute('''
                    CREATE TABLE IF NOT EXISTS Bookmarks(
                        timestamp INTEGER,
                        audio_id INTEGER,
                        FOREIGN KEY(audio_id) REFERENCES Audios(id) ON DELETE NO ACTION ON UPDATE NO ACTION
                    );
                    ''');
          } catch (e) {
            print('Error creating Bookmarks table: $e');
          }

          print('create table notes');
          try {
            await db.execute('''
                    CREATE TABLE IF NOT EXISTS Notes(
                        note TEXT,
                        audio_id INTEGER,
                        FOREIGN KEY(audio_id) REFERENCES Audios(id) ON DELETE NO ACTION ON UPDATE NO ACTION
                    );
                    ''');
          } catch (e) {
            print('Error creating Notes table: $e');
          }
        } catch (e) {
          print('error creating db: $e');
        }
      });
    } catch (e) {
      print('error opening db: $e');
    }
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

//  █████╗ ██╗   ██╗██████╗ ██╗ ██████╗ ███████╗
// ██╔══██╗██║   ██║██╔══██╗██║██╔═══██╗██╔════╝
// ███████║██║   ██║██║  ██║██║██║   ██║███████╗
// ██╔══██║██║   ██║██║  ██║██║██║   ██║╚════██║
// ██║  ██║╚██████╔╝██████╔╝██║╚██████╔╝███████║
// ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝ ╚═════╝ ╚══════╝

  Future<List<Map<String, dynamic>>> queryAudioForFilePath(
      String filePath) async {
    try {
      List<Map<String, dynamic>> res = await _database.transaction((ctx) async {
        return ctx
            .rawQuery('SELECT * FROM Audios WHERE file_path=(?)', [filePath]);
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
        return ctx.rawQuery('SELECT * FROM Audios');
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
      print('woopsie poopsie, last position update failed. heres err $e');
    }
  }

// ██████╗  ██████╗  ██████╗ ██╗  ██╗███╗   ███╗ █████╗ ██████╗ ██╗  ██╗███████╗
// ██╔══██╗██╔═══██╗██╔═══██╗██║ ██╔╝████╗ ████║██╔══██╗██╔══██╗██║ ██╔╝██╔════╝
// ██████╔╝██║   ██║██║   ██║█████╔╝ ██╔████╔██║███████║██████╔╝█████╔╝ ███████╗
// ██╔══██╗██║   ██║██║   ██║██╔═██╗ ██║╚██╔╝██║██╔══██║██╔══██╗██╔═██╗ ╚════██║
// ██████╔╝╚██████╔╝╚██████╔╝██║  ██╗██║ ╚═╝ ██║██║  ██║██║  ██║██║  ██╗███████║
// ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝

  Future<void> createBookmark(Bookmark bookmark) async {
    try {
      await _database.transaction((ctx) async {
        await ctx.insert('Bookmarks', bookmark.toMap());
      });
    } catch (e) {
      print('woopsie poopsie, bookmark update failed. here err: $e');
    }
  }

  Future<void> deleteBookmark(int timestamp) async {
    try {
      await _database.transaction((ctx) async {
        await ctx
            .delete('Bookmarks', where: 'timestamp=?', whereArgs: [timestamp]);
      });
    } catch (e) {
      print('woopsie poopsie, bookmark delete failed. here err: $e');
    }
  }

  Future<List<Bookmark>> getBookmarks() async {
    try {
      var rows;
      await _database.transaction((ctx) async {
        rows = await ctx.rawQuery('SELECT * FROM Bookmarks');
      });
      return List<Bookmark>.from(rows.map(((row) => Bookmark.fromRow(row))));
    } catch (e) {
      print('woopsie poopsie, getBookmarks failed. Err: $e');
      return null;
    }
  }

// ███╗   ██╗ ██████╗ ████████╗███████╗███████╗
// ████╗  ██║██╔═══██╗╚══██╔══╝██╔════╝██╔════╝
// ██╔██╗ ██║██║   ██║   ██║   █████╗  ███████╗
// ██║╚██╗██║██║   ██║   ██║   ██╔══╝  ╚════██║
// ██║ ╚████║╚██████╔╝   ██║   ███████╗███████║
// ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚══════╝╚══════╝

  Future<void> createNote(Note note) async {
    try {
      await _database.transaction((ctx) async {
        await ctx.insert('Notes', note.toMap());
      });
    } catch (e) {
      print('woopsie poopsie, note update failed. here err: $e');
    }
  }

  Future<void> deleteNote(String note) async {
    try {
      await _database.transaction((ctx) async {
        await ctx.delete('Notes', where: 'note=?', whereArgs: [note]);
      });
    } catch (e) {
      print('woopsie poopsie, note delete failed. here err: $e');
    }
  }
}
