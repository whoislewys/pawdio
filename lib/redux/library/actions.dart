import 'package:pawdio/models/app_state.dart';
import 'package:pawdio/models/audio.dart';
import 'package:redux/redux.dart';

// action adapted from: https://github.com/brianegan/flutter_architecture_samples/blob/master/redux/lib/actions/actions.dart
class AddAudioAction {
  final Audio audio;
  AddAudioAction(this.audio);
}

addAudio(Store<AppState> store, Audio audio) {
  store.dispatch(AddAudioAction(audio));
}

class HydrateAudiosAction {}

void HydrateAudios(Store<AppState> store) {
  // only used to trigger async hydrateAudios middleware
  store.dispatch(HydrateAudiosAction());
}
