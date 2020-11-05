import 'package:redux/redux.dart';
import 'package:pawdio/models/app_state.dart';
import 'package:pawdio/redux/library/reducers.dart';
import 'package:pawdio/redux/library/middlewares.dart';

// Adapted from https://github.com/brianegan/flutter_architecture_samples/blob/master/redux/lib/reducers/app_state_reducer.dart
// We create the State reducer by combining many smaller reducers into one!
AppState appReducer(AppState state, action) {
  return AppState(
    audios: audiosReducer(state.audios, action),
    currentAudioPath: currentAudioReducer(state.currentAudioPath, action),
  );
}

// adapted from https://github.com/brianegan/flutter_architecture_samples/blob/master/redux/lib/main.dart
final store = Store<AppState>(
  appReducer,
  initialState: AppState(),
  middleware: [
    hydrateAudiosMiddleware,
    createAudioMiddleware,
  ],
);
