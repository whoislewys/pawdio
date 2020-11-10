import 'package:flutter_redux/flutter_redux.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  Future<void> _navigateToPlayscreenAndPlayFile(
      BuildContext ctx, Audio audioToPlay) async {
    Navigator.push(ctx,
        MaterialPageRoute(builder: (context) => Playscreen(audioId: audioToPlay.id)));
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

    // store.dispatch(SetCurrentAudioAction(store.state.currentAudio));
  }

  @override
  Widget build(BuildContext context) {
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
                      return PopupMenuButton(
                        icon: Icon(Icons.more_vert, size: 34.0),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              title: Text('Add audio'),
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
              StoreConnector<AppState, Store<AppState>>(
                  converter: (Store<AppState> store) {
                    return store;
                  },
                  onInit: (Store<AppState> store) =>
                      store.dispatch(HydrateAudiosAction()),
                  builder: (context, store) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: store.state.audios.length,
                        itemBuilder: (BuildContext context, int index) {
                          String audioFilePath = store.state.audios[index].filePath;
                          // int audioId = audios[index].id;

                          return ListTile(
                            onTap: () {
                              Audio audioToPlay = store.state.audios[index];
                              store.dispatch(SetCurrentAudioAction(audioToPlay));
                              _navigateToPlayscreenAndPlayFile(
                                  context, audioToPlay);
                            },
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
  }
}
