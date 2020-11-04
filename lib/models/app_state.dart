import 'package:meta/meta.dart';
import 'package:pawdio/models/audio.dart';
import 'package:pawdio/models/bookmark.dart';

// adapted from
// https://github.com/brianegan/flutter_architecture_samples/blob/master/redux/lib/models/app_state.dart
@immutable
class AppState {
  /// The audios currently available within the app
  final List<Audio> audios;

  /// Currently selected audio
  final Audio currentAudio;

  /// The bookmarks for the currently playing audio
  final List<Bookmark> bookmarks;

  // TODO: add all pieces of global state here
  // final isPlaying; // <- need this?

  AppState({
    this.audios = const [],
    this.currentAudio = const Audio.emptyAudio(),
    this.bookmarks = const [],
  });

  @override
  String toString() {
    return '''

        AppState{
          audios: $audios,
          currentAudio: $currentAudio,
          bookmarks: $bookmarks,
        }
    ''';
  }
}
