import 'package:flutter_redux/flutter_redux.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawdio/db/pawdio_db.dart';
import 'package:pawdio/models/app_state.dart';
import 'package:pawdio/models/audio.dart';
import 'package:pawdio/screens/play/play.dart';
import 'package:pawdio/utils/util.dart';
import 'package:pawdio/redux/library/actions.dart';
import 'package:redux/redux.dart';

class LibraryScreen extends StatefulWidget {
  LibraryScreen({Key key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  // List<Map<String, dynamic>> _audios;
  PawdioDb _database;

  @override
  void initState() {
    super.initState();
    // _hydrateAudio();
  }

  Future<void> _hydrateAudio() async {
    return;
    // _database = await PawdioDb.create();
    // _audios = await _database.getAllAudios();
    // if (_audios.length == 0) {
    //   print('no audios');
    //   // TODO: set state of button on screen to allow you to choose file more easily
    // }
    // return;
  }

  Future<void> _navigateToPlayscreenAndPlayFile(
      BuildContext ctx, String filePath, int audioId) async {
    Navigator.push(
        ctx,
        MaterialPageRoute(
            builder: (context) =>
                Playscreen(currentFilePath: filePath, audioId: audioId)));
  }

  Future<void> _chooseAndPlayFile(
      BuildContext ctx, Store<AppState> store) async {
    // Open file manager and choose file
    var chosenFilePath = await FilePicker.getFilePath();
    if (chosenFilePath == null) {
      print('ERROR: Null file was chosen');
      return;
    }

    store.dispatch(CreateAudioAction(chosenFilePath));

    store.dispatch(SetCurrentAudioAction(chosenFilePath));
    // _navigateToPlayScreen();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: break out ubild method to have multiple storeconnectors for loading audios and adding new audios
    // return StoreConnector<AppState, List<Audio>>(
    //   converter: (Store<AppState> store) {
    //     store.dispatch(HydrateAudiosAction());
    //     return store.state.audios;
    //   },
    //   builder: (context, audios) {
    //     return Container(width: 0, height: 0);
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  // todo: replace 2nd type arg with actual viewmodel probably
                  child: StoreConnector<AppState, Store>(
                    converter: (Store<AppState> store) {
                      return store;
                    },
                    builder: (context, store) {
                      // return Container(width: 0, height: 0);
                      return PopupMenuButton(
                        icon: Icon(Icons.more_vert, size: 34.0),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              title: Text('Choose File'),
                              onTap: () => _chooseAndPlayFile(context, store),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Text(
                'Library',
                style: Theme.of(context).textTheme.headline6,
              ),
              StoreConnector<AppState, List<Audio>>(
                  converter: (Store<AppState> store) {
                    return store.state.audios;
                  },
                  onInit: (Store<AppState> store) =>
                      store.dispatch(HydrateAudiosAction()),
                  builder: (context, audios) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: audios.length,
                        itemBuilder: (BuildContext context, int index) {
                          String audioFilePath = audios[index].filePath;
                          int audioId = audios[index].id;

                          return ListTile(
                            onTap: () => _navigateToPlayscreenAndPlayFile(
                                context, audioFilePath, audioId),
                            title: Text(
                              getFileNameFromFilePath(audioFilePath),
                            ),
                          );
                        },
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
    // },
    // );
  }
}
