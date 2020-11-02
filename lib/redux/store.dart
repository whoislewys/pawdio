import 'package:redux/redux.dart';
import 'package:pawdio/models/app_state.dart';
import 'package:pawdio/redux/library/reducers.dart';
// import 'package:redux_sample/reducers/tabs_reducer.dart';
// import 'package:redux_sample/reducers/todos_reducer.dart';
// import 'package:redux_sample/reducers/visibility_reducer.dart';

// Adapted from https://github.com/brianegan/flutter_architecture_samples/blob/master/redux/lib/reducers/app_state_reducer.dart
// We create the State reducer by combining many smaller reducers into one!
AppState appReducer(AppState state, action) {
  return AppState(
    audios: audiosReducer(state.audios, action),
  );
}

// adapted from https://github.com/brianegan/flutter_architecture_samples/blob/master/redux/lib/main.dart
final store = Store<AppState>(
  appReducer,
  initialState: AppState(),
  middleware: [],
);
