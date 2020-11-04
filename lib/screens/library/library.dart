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

  Future<void> _chooseAndPlayFile(BuildContext ctx) async {
    // TODO: make werk with redux
    // Open file manager and choose file
    // var chosenFilePath = await FilePicker.getFilePath();
    // if (chosenFilePath == null) {
    //   print('ERROR: Null file was chosen');
    //   return;
    // }

    // List<Map<String, dynamic>> audioResult =
    //     await _database.queryAudioForFilePath(chosenFilePath);

    // if (audioResult.isEmpty) {
    //   // if file has not been chosen before, create record for it in DB
    //   await _database.createAudio(chosenFilePath);
    //   final newAudios = await _database.getAllAudios();
    // setState(() {
    // _audios = newAudios;
    // });
    // audioResult = await _database.queryAudioForFilePath(chosenFilePath);
    // }

    // _navigateToPlayscreenAndPlayFile(
    //     ctx, chosenFilePath, audioResult[0]['rowid']);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Audio>>(
      converter: (store) {
        store.dispatch(HydrateAudiosAction());
        return store.state.audios;
      },
      builder: (context, audios) {
        print('audios: ${audios}');
        return Scaffold(
          body: Center(
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: PopupMenuButton(
                        icon: Icon(Icons.more_vert, size: 34.0),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              title: Text('Choose File'),
                              onTap: () => _chooseAndPlayFile(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'Library',
                    style: Theme.of(context).textTheme.title,
                  ),
                  FutureBuilder(
                      future: _hydrateAudio(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              // TODO: make store.state.audios the source of truth for audios
                              itemCount: audios.length,
                              itemBuilder: (BuildContext context, int index) {
                                String audioFilePath = audios[index].filePath;
                                int audioId = audios[index].id;
                                print('audio id: $audioId');

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
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
