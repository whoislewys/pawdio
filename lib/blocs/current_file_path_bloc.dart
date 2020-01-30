import 'dart:async';

import 'bloc.dart';

class CurrentFilePathBloc implements Bloc {
  String _filePath;
  String get filePath => _filePath;

  // private StreamController to manage stream & sink for bloc
  final _filePathController = StreamController<String>();

  // Getter so that events can be consumed off stream
  Stream<String> get filePathStream => _filePathController.stream;

  // Input for the bloc
  void _selectFilePath(String filePath) {
    _filePath = filePath;
    _filePathController.sink.add(filePath);
  }

  // Cleanup
  void dispose() {
    _filePathController.close();
  }
}