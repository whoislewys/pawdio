import 'package:redux/redux.dart';
import 'package:pawdio/models/audio.dart';
import 'package:pawdio/redux/library/actions.dart';

// reducer adapted from https://github.com/brianegan/flutter_architecture_samples/blob/master/redux/lib/reducers/todos_reducer.dart
final audiosReducer = combineReducers<List<Audio>>([
  TypedReducer<List<Audio>, AddAudioAction>(_addAudio),
]);

List<Audio> _addAudio(List<Audio> audios, AddAudioAction action) {
  return List.from(audios)..add(action.audio);
}