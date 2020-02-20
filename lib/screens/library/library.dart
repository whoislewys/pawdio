import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawdio/db/pawdio_db.dart';
import 'package:pawdio/screens/play/play.dart';
import 'package:pawdio/utils/util.dart';

class LibraryScreen extends StatefulWidget {
  LibraryScreen({Key key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Map<String, dynamic>> _audios;
  PawdioDb _database;

  @override
  void initState() {
    super.initState();
    _hydrateAudio();
  }

  Future<void> _hydrateAudio() async {
    _database = await PawdioDb.create();
    _audios = await _database.getAllAudios();
    return;
  }

  Future<void> _navigateToPlayscreenAndPlayFile(
      BuildContext ctx, String filePath) async {
    Navigator.push(ctx, MaterialPageRoute(builder: (context) => Playscreen(currentFilePath: filePath)));
  }

  Future<void> _chooseAndPlayFile(BuildContext ctx) async {
    // Open file manager and choose file
    var chosenFile = await FilePicker.getFilePath();
    _navigateToPlayscreenAndPlayFile(ctx, chosenFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              PopupMenuButton(
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
                          itemCount: _audios.length,
                          itemBuilder: (BuildContext context, int index) {
                            String audioFilePath = _audios[index]['file_path'];
                            return ListTile(
                              onTap: () => _navigateToPlayscreenAndPlayFile(
                                  context, audioFilePath),
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
  }
}
