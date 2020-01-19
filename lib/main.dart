import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_sound/flutter_sound.dart';

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
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String patriceAudio = 'assets/patrice-were-better.mp3';
  bool _isPlaying = true;
  FlutterSound _player;
  double _duration;
  double _playPosition;
  StreamSubscription<PlayStatus> _playerSubscription;

  @override
  void initState() {
    super.initState();
    _player = FlutterSound();
    _playPosition = 0.0;
    _duration = 0.0;
    SchedulerBinding.instance.addPostFrameCallback((_) => _play(patriceAudio));
  }

  @override
  void dispose() {
    // TODO cleanly clean things up. Since _cleanup is async, sometimes the _playerSubscription listener calls setState after dispose but before it's canceled.
    _cleanup();
    super.dispose();
  }

  void _cleanup() async {
    await _player.stopPlayer();
    _playerSubscription.cancel();
  }

  void _stop() async {
    await _player.pausePlayer();
    setState(() => _isPlaying = false);
  }

  void _play(String url) async {
    // todo: play the local patrice file
    ByteData localAudio = await rootBundle.load(url);
    await _player.startPlayerFromBuffer(localAudio.buffer.asUint8List());
    _playerSubscription = _player.onPlayerStateChanged.listen((e) {
      if (e != null) {
        if (_isPlaying) {
          print('position: ${e.currentPosition}');
          print('duration ${e.duration}');
        }
        setState(() {
          _playPosition = e.currentPosition;
          _duration = e.duration;
        });
      }
    });
    setState(() => _isPlaying = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Slider(
                value: _playPosition,
                min: 0.0,
                max: _duration,
                onChanged: (double value) {
                  setState(() {
                    print('slider changed to $value');
                    int msToSeekTo = value.toInt() - 100;
                    _player.seekToPlayer(msToSeekTo);
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () =>
                        _player.seekToPlayer((_playPosition - 10000.0).toInt()),
                    icon: Icon(
                      Icons.forward_10,
                      size: 48.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_isPlaying) {
                        _stop();
                      } else {
                        _play(patriceAudio);
                      }
                    },
                    padding: new EdgeInsets.all(0.0),
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      size: 48.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        _player.seekToPlayer((_playPosition + 30000.0).toInt()),
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
