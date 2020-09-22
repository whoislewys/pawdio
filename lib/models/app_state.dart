import 'package:meta/meta.dart';
import 'package:pawdio/models/audio.dart';
import 'package:pawdio/models/bookmark.dart';

// adapted from
// https://github.com/brianegan/flutter_architecture_samples/blob/master/redux/lib/models/app_state.dart
@immutable
class PawdioState {
  /// The audios currently available within the app
  final List<Audio> audios;

  /// The bookmarks for the currently playing audio
  final List<Bookmark> bookmarks;

  // TODO: add all pieces of global state here
  // final isPlaying; // <- need this?

  PawdioState({
    this.audios = const [],
    this.bookmarks = const [],
  });

  @override
  String toString() {
    return 'PawdioState{audios: $audios, bookmarks: $bookmarks}';
  }
}
