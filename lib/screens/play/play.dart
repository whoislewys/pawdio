import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:pawdio/db/pawdio_db.dart';
import 'package:pawdio/models/bookmark.dart';
import 'package:pawdio/utils/life_cycle_event_handler.dart';
import 'package:pawdio/utils/util.dart';

class Playscreen extends StatefulWidget {
  final String currentFilePath;
  // todo: replace this passing from screen to screen with redux so i can have a nice little queue in the future
  Playscreen({Key key, @required this.currentFilePath}) : super(key: key);

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
  List<Bookmark> _bookmarks;
  List<int> _bookmarkTimes;

  // Whether there is bookmark at current play position
  // I should probably also add a debounce, or at least a short term cache, could use (`memoize`)
  // To avoid spamming while paused (would need to make sure to invalidate cache on song change though)a
  // bool get currentlyOnBookmark => _bookmarkTimes.contains(_playPosition.toInt());
  bool get currentlyOnBookmark {
    return _bookmarkTimes == null
        ? false
        : _bookmarkTimes.contains(_playPosition.toInt());
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(playerId: 'MyPlayer');
    _playPosition = 0.0;
    _duration = 0.0;
    _currentFilePath = widget.currentFilePath;

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _database = await PawdioDb.create();
      await _initBookmarkTimes();
    });

    // Set up listener for app lifecycle events
    // to save lastPosition of current audio when app goes inactive or closes.
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
            inactiveCallback: () => _database.updateLastPosition(
                _currentFilePath, _playPosition.toInt())));
    print('current filepath: $_currentFilePath');
    _playFile(_currentFilePath);
  }

  Future<void> _initBookmarkTimes() async {
    _bookmarks = await _database.getBookmarks();
    _bookmarkTimes = _bookmarks.map((bookmark) => bookmark.timestamp);
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

  /// Setup subscriptions audioPlayer's PlayPosition
  Future<void> _playFile(String filePath) async {
    // set title to show in media player
    title = getFileNameFromFilePath(filePath);

    // Play chosen file and setup listeners on player
    await _audioPlayer.play(filePath, isLocal: true);

    _audioPlayer.onDurationChanged.listen((Duration d) {
      if (d != null) {
        setState(() {
          _duration = d.inMilliseconds.toDouble();
        });
      }
    });

    _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      if (p != null) {
        setState(() {
          _playPosition = p.inMilliseconds.toDouble();
        });
      }
    });

    // if file has been chosen before, query for and play from the last position
    List<Map<String, dynamic>> audioResult =
        await _database.queryAudioForFilePath(filePath);
    if (audioResult.isNotEmpty) {
      int previousPosition = audioResult.first['last_position'];
      _audioPlayer.seek(Duration(milliseconds: previousPosition));
    } else {
      // if file has not been chosen before, create record for it in DB
      _database.createAudio(filePath);
    }

    setState(() => _isPlaying = true);
  }

  Future<void> _seekToStart() async {
    await _audioPlayer.seek(Duration(milliseconds: 0));
    setState(() => _isPlaying = true);
  }

  Future<void> _resume() async {
    await _audioPlayer.resume();
    setState(() => _isPlaying = true);
  }

  void _stop() async {
    print('pausing');
    await _audioPlayer.pause();
    setState(() => _isPlaying = false);
  }

  void _createBookmark(position) {
    print('');
    print('bookmark clicked!');
    _database.createBookmark(Bookmark(timestamp: position));
  }

  void _createOrDeleteBookmark(int position) {
    if (position == _playPosition) {
      _database.deleteBookmark(position);
    }
    _createBookmark(position);
  }

  @override
  Widget build(BuildContext context) {
    print('playpostiion: $_playPosition');
    if (_playPosition > _duration) {
      // to catch weird audioPlayer bug where it sends a request to native media player to skip past end of audio before build
      _seekToStart();
      _resume();
    }

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
                      if (thirtySecsFwd >= _duration) {
                        _audioPlayer.seek(Duration(milliseconds: _duration.toInt()));
                        return;
                      }
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
                        int prevBookmarkIdx = findNearestBelow(sortedList: _bookmarkTimes, element: _playPosition.toInt());
                        print('prev bookmark idx: $prevBookmarkIdx');
                        Bookmark prevBookmark = _bookmarks[prevBookmarkIdx];
                        print('prev bookmark: $prevBookmark');

                        _stop(); // PAUSE
                        _audioPlayer.seek(Duration(milliseconds: prevBookmark.timestamp));
                      },
                      icon: Icon(
                        Icons.chevron_left,
                        size: 40.0,
                      ),
                    ),
                    IconButton(
                      padding: new EdgeInsets.all(0.0),
                      onPressed: () => _createOrDeleteBookmark(_playPosition.toInt()),
                      // if play position is on top of a bookmark position, show the filled bookmark icon
                      // else, show the outlined one
                      icon: currentlyOnBookmark
                      ? Icon(
                        Icons.bookmark,
                        size: 44.0,
                      )
                      : Icon(
                        Icons.bookmark_border,
                        size: 44.0,
                      ),
                    ),
                    IconButton(
                      padding: new EdgeInsets.all(0.0),
                      onPressed: () {
                        int nextBookmarkIdx = findNearestAbove(sortedList: _bookmarkTimes, element: _playPosition.toInt());
                        print('prev bookmark idx: $nextBookmarkIdx');
                        Bookmark nextBookmark = _bookmarks[nextBookmarkIdx];
                        print('prev bookmark: $nextBookmark');

                        _stop(); // PAUSE
                        _audioPlayer.seek(Duration(milliseconds: nextBookmark.timestamp));
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
