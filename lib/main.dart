import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

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
  String patriceAudio = 'assets/patrice-were-better.mp3';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(playerId: 'MyPlayer');
    _playPosition = 0.0;
    _duration = 0.0;
    SchedulerBinding.instance.addPostFrameCallback((_) => chooseAndPlayFile());
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }

  void _cleanup() async {
    await _audioPlayer.stop();
  }

  void chooseAndPlayFile() async {
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

  void _play(String url) async {
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
              Image.network(
                  'https://cmkt-image-prd.freetls.fastly.net/0.1.0/ps/442503/910/607/m1/fpnw/wm0/1501.m00.i124.n007.s.c10.227189671-sound-wave-background-.jpg?1428817606&s=539d7335bcd5c461d913f0e2417b2c08'),
              Text('File Name'),
              Slider(
                value: _playPosition,
                min: 0.0,
                max: _duration,
                onChanged: (double value) {
                  setState(() {
                    print('slider changed to $value');
                    int msToSeekTo = value.toInt() - 100;
                    // _player.seekToPlayer(msToSeekTo);
                    _audioPlayer.seek(Duration(milliseconds: msToSeekTo));
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    padding: new EdgeInsets.all(0.0),
                    onPressed: () {
                      int tenSecsBefore = (_playPosition - 10000.0).toInt();
                      // _player.seekToPlayer(tenSecsBefore),

                      _audioPlayer.seek(Duration(milliseconds: tenSecsBefore));
                    },
                    icon: Icon(
                      Icons.forward_10,
                      size: 48.0,
                    ),
                  ),
                  IconButton(
                    padding: new EdgeInsets.all(0.0),
                    onPressed: () {
                      if (_isPlaying) {
                        _stop();
                      } else {
                        _play(patriceAudio);
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
                      // _player.seekToPlayer(thirtySecsFwd),

                      _audioPlayer.seek(Duration(milliseconds: thirtySecsFwd));
                    },
                    icon: Icon(
                      Icons.forward_30,
                      size: 48.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
