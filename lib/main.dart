import 'dart:math';
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
    return MaterialApp(
      title: 'Shit in my ass',
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

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(playerId: 'MyPlayer');
    _playPosition = 0.0;
    _duration = 0.0;
    SchedulerBinding.instance.addPostFrameCallback((_) => _chooseAndPlayFile());
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }

  void _cleanup() async {
    await _audioPlayer.stop();
  }

  void _chooseAndPlayFile() async {
    String chosenFilePath = await FilePicker.getFilePath();
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

    setState(() => _isPlaying = true);
  }

  void _resume() async {
    await _audioPlayer.resume();
    setState(() => _isPlaying = true);
  }

  void _stop() async {
    await _audioPlayer.pause();
    setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {
                      print('goback');
                    },
                  ),
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert),
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
              Image.network(
                  'https://cmkt-image-prd.freetls.fastly.net/0.1.0/ps/442503/910/607/m1/fpnw/wm0/1501.m00.i124.n007.s.c10.227189671-sound-wave-background-.jpg?1428817606&s=539d7335bcd5c461d913f0e2417b2c08'),
              Text('File Name'),
              Slider(
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
                        _audioPlayer.seek(Duration(milliseconds: tenSecsBefore));
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
