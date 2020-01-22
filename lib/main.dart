import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    return MaterialApp(
      title: 'The best audio player in the world',
      home: MyHomePage(),
      theme: ThemeData.dark(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AudioPlayer _audioPlayer;
  bool _isPlaying = true;
  double _duration;
  double _playPosition;
  Database _database;
  String currentFileName = '';

  void setCurrentFileName(String curFileName) {
    currentFileName = curFileName;
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(playerId: 'MyPlayer');
    _playPosition = 0.0;
    _duration = 0.0;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _setupDB();
      _chooseAndPlayFile();
    });
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }

  void _cleanup() async {
    await _audioPlayer.stop();
  }

  Future<List<Map<String, dynamic>>> queryAudioForFilePath(
      String filePath) async {
    try {
      List<Map<String, dynamic>> res = await _database.transaction((ctx) async {
        return ctx.rawQuery(
            'SELECT file_path FROM Audios WHERE file_path=(?)', [filePath]);
      });
      print('select filepath result: $res');
      return res;
    } catch (e) {
      print('this bitch ass query empty yeet. error: $e');
      return [];
    }
  }

  Future<void> _chooseAndPlayFile() async {
    // Open file manager and choose file
    String chosenFilePath = await FilePicker.getFilePath();
    String chosenFilename = chosenFilePath.split('/').last;
    setCurrentFileName(chosenFilename);

    // Play chosen file and setup listeners on player
    await _audioPlayer.play(chosenFilePath, isLocal: true);
    _audioPlayer.onDurationChanged.listen((Duration d) {
      if (e != null) {
        setState(() {
          _duration = d.inMilliseconds.toDouble();
        });
      }
    });
    _audioPlayer.onAudioPositionChanged.listen((Duration d) {
      if (e != null) {
        setState(() {
          _playPosition = d.inMilliseconds.toDouble();
        });
      }
    });

    // if file has been chosen before, query for and play from the last position
    List<Map<String, dynamic>> res =
        await queryAudioForFilePath(chosenFilePath);
    bool fileHasBeenChosenBefore = res != [];
    if (fileHasBeenChosenBefore) {
      print(
          'file chosen before. should query for last position, play, and seek to it here');
    } else {
      // if file has not been chosen before, create record for it in DB
      Map<String, dynamic> row = {
        'file_path': chosenFilePath,
        'last_position': 0
      };
      await _database.transaction((ctx) async {
        await ctx.insert('Audios', row);
      });
    }

    setState(() => _isPlaying = true);
  }

  Future<void> _setupDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'pawdio-library.db');
    // deleteDatabase(path);

    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      print('creating db');
      await db.execute(
          // todo: add tables for bookmarks & notes, and foreign keys to them in the the audio table
          'CREATE TABLE Audios (file_path TEXT UNIQUE, last_position INTEGER)');
    });
  }

  Future<void> _resume() async {
    await _audioPlayer.resume();
    setState(() => _isPlaying = true);
  }

  void _stop() async {
    await _audioPlayer.pause();
    setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    double albumArtSize = MediaQuery.of(context).size.width * 0.82;
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 48.0,
                    onPressed: () {
                      print('goback');
                    },
                  ),
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert, size: 34.0),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          title: Text('Choose File'),
                          onTap: _chooseAndPlayFile,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: albumArtSize,
                child: Image.asset('assets/no-art-found.png'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 28.0, 10.0, 10.0),
                child: Text(
                  currentFileName,
                  textScaleFactor: 1.27,
                ),
              ),
              Slider(
                activeColor: Colors.white,
                value: _playPosition,
                min: 0.0,
                max: _duration,
                onChanged: (double value) {
                  setState(() {
                    int msToSeekTo = value.toInt() - 100;
                    _audioPlayer.seek(Duration(milliseconds: msToSeekTo));
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    padding: new EdgeInsets.all(0.0),
                    onPressed: () {
                      int tenSecsBefore = (_playPosition - 10000.0).toInt();
                      print('tensecsbefore: $tenSecsBefore');
                      if (tenSecsBefore <= 0) {
                        _audioPlayer.seek(Duration(milliseconds: 0));
                      } else {
                        _audioPlayer
                            .seek(Duration(milliseconds: tenSecsBefore));
                      }
                    },
                    icon: Icon(
                      Icons.forward_10,
                      size: 40.0,
                    ),
                  ),
                  IconButton(
                    padding: new EdgeInsets.all(0.0),
                    onPressed: () {
                      if (_isPlaying) {
                        _stop();
                      } else {
                        _resume();
                      }
                    },
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      size: 48.0,
                    ),
                  ),
                  IconButton(
                    padding: new EdgeInsets.all(0.0),
                    onPressed: () {
                      int thirtySecsFwd = (_playPosition + 30000.0).toInt();
                      _audioPlayer.seek(Duration(milliseconds: thirtySecsFwd));
                    },
                    icon: Icon(
                      Icons.forward_30,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      padding: new EdgeInsets.all(0.0),
                      onPressed: () {
                        print('make a note');
                      },
                      icon: Icon(
                        Icons.note_add,
                        size: 36.0,
                      ),
                    ),
                    IconButton(
                      padding: new EdgeInsets.all(0.0),
                      onPressed: () {
                        print('prev bookmark');
                      },
                      icon: Icon(
                        Icons.chevron_left,
                        size: 40.0,
                      ),
                    ),
                    IconButton(
                      padding: new EdgeInsets.all(0.0),
                      onPressed: () {
                        print('bookmarked!');
                      },
                      icon: Icon(
                        Icons.bookmark_border,
                        size: 44.0,
                      ),
                    ),
                    IconButton(
                      padding: new EdgeInsets.all(0.0),
                      onPressed: () {
                        print('next bkmrk');
                      },
                      icon: Icon(
                        Icons.chevron_right,
                        size: 40.0,
                      ),
                    ),
                    IconButton(
                      padding: new EdgeInsets.all(0.0),
                      onPressed: () {
                        print('sleep timer');
                      },
                      icon: Icon(
                        Icons.timer,
                        size: 36.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
