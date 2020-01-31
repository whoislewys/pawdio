import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:pawdio/blocs/bloc_provider.dart';
import 'package:pawdio/blocs/current_file_path_bloc.dart';
import 'package:pawdio/db/pawdio_db.dart';
import 'package:pawdio/utils/life_cycle_event_handler.dart';
import 'package:pawdio/utils/util.dart';

class Playscreen extends StatefulWidget {
  Playscreen({Key key}) : super(key: key);

  @override
  _PlayscreenState createState() => _PlayscreenState();
}

class _PlayscreenState extends State<Playscreen> {
  AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  double _duration;
  double _playPosition;
  PawdioDb _database;
  String title = '';
  String _currentFilePath;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(playerId: 'MyPlayer');
    _playPosition = 0.0;
    _duration = 0.0;

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _database = await PawdioDb.create();
      // _chooseAndPlayFile();
    });

    // Set up listener for app lifecycle events
    // to save lastPosition of current audio when app goes inactive or closes.
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
        inactiveCallback: () => _database.updateLastPosition(
            _currentFilePath, _playPosition.toInt())));
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }

  void _cleanup() async {
    await _audioPlayer.stop();
  }

  Future<void> _chooseAndPlayFile() async {
    // Open file manager and choose file
    _currentFilePath = await FilePicker.getFilePath();
    _playFile(_currentFilePath);
  }

  Future<void> _playFile(String filePath) async {
    // if already playing, don't allow to play again
    if (_isPlaying) {
      return;
    }

    // set title to show in media player
    title = getFileNameFromFilePath(filePath);

    // Play chosen file and setup listeners on player
    await _audioPlayer.play(filePath, isLocal: true);
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
    List<Map<String, dynamic>> audioResult =
        await _database.queryAudioForFilePath(filePath);
    if (audioResult.isNotEmpty) {
      print(
          'file chosen before. should query for last position, play, and seek to it here');
      int previousPosition = audioResult.first['last_position'];
      print('audio res first ${audioResult.first}');
      print('last position $previousPosition');
      _audioPlayer.seek(Duration(milliseconds: previousPosition));
    } else {
      // if file has not been chosen before, create record for it in DB
      _database.createAudio(filePath);
    }

    setState(() => _isPlaying = true);

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

    return StreamBuilder<String>(
      stream: BlocProvider.of<CurrentFilePathBloc>(context).filePathStream,
      builder: (context, snapshot) {
        final currentFilePath = snapshot.data;
        print('current file path from bloc: $currentFilePath');
        if (currentFilePath == null) {
          return Container();
        }
        _playFile(currentFilePath);
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
                          Navigator.pop(context);
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular((5.0)),
                      child: Image.asset('assets/no-art-found.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 28.0, 10.0, 10.0),
                    child: Text(
                      title,
                      textScaleFactor: 1.27,
                    ),
                  ),
                  // apply slidertheme to make slider label black so it's visible (with dark theme it's white by default)
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      showValueIndicator: ShowValueIndicator.onlyForContinuous,
                      valueIndicatorTextStyle: TextStyle(color: Colors.black),
                    ),
                    child: Slider(
                      activeColor: Colors.white,
                      value: _playPosition,
                      min: 0.0,
                      max: _duration,
                      label: millisecondsToMinutesAndSeconds(_playPosition),
                      onChanged: (double value) {
                        setState(() {
                          int msToSeekTo = value.toInt() - 100;
                          _audioPlayer.seek(Duration(milliseconds: msToSeekTo));
                        });
                      },
                    ),
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
    );
  }
}
