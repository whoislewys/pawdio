import 'package:pawdio/models/app_state.dart';
import 'package:pawdio/models/audio.dart';
import 'package:redux/redux.dart';

// Used to trigger middleware which makes localdb/api call to fill store.state.audios
class HydrateAudiosAction {}

// Actually populates store.state.audios
class AddAudiosAction {
  final List<Audio> audios;
  AddAudiosAction(this.audios);
}

// Used to create a new audio obj from file path
class CreateAudioAction {
  final String filePath;
  CreateAudioAction(this.filePath);
}

class SetCurrentAudioAction {
  final String newCurrentAudioPath;
  SetCurrentAudioAction(this.newCurrentAudioPath);
}
