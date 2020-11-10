import 'package:redux/redux.dart';
import 'package:pawdio/models/audio.dart';
import 'package:pawdio/redux/library/actions.dart';

/// AUDIOS (LIBRARY) REDUCERS
// reducer adapted from https://github.com/brianegan/flutter_architecture_samples/blob/master/redux/lib/reducers/todos_reducer.dart
final audiosReducer = combineReducers<List<Audio>>([
  TypedReducer<List<Audio>, HydrateAudiosAction>(_hydrateAudio),
  TypedReducer<List<Audio>, AddAudiosAction>(_addAudios),
  TypedReducer<List<Audio>, CreateAudioAction>(_createAudio),
]);

List<Audio> _hydrateAudio(List<Audio> audios, HydrateAudiosAction action) {
  // just used to trigger middleware, return audios without modification
  return audios;
}

List<Audio> _addAudios(List<Audio> audios, AddAudiosAction action) {
  return List.from(audios)..addAll(action.audios);
}

// TODO: do i even need to have a reducer for this?
List<Audio> _createAudio(List<Audio> audios, CreateAudioAction action) {
  // just used to trigger createAudio middleware
  return audios;
}

/// CURRENT PLAYING AUDIO REDUCER
final currentAudioReducer =
    TypedReducer<Audio, SetCurrentAudioAction>(_setCurrentAudio);
Audio _setCurrentAudio(Audio audio, SetCurrentAudioAction action) {
  return action.newCurrentAudio;
}

// final playCurrentAudio
