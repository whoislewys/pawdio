import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LibraryScreen extends StatefulWidget {
  LibraryScreen({Key key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  Future<void> _chooseAndPlayFile() async {
    // Open file manager and choose file
    var chosenFile = await FilePicker.getFilePath();
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
                onTap: _chooseAndPlayFile,
              ),
            ),
          ],
        ),
      ],
    ))));
  }
}
