import 'package:pawdio/models/app_state.dart';
import 'package:pawdio/models/bookmark.dart';
import 'package:redux/redux.dart';

class PlayscreenViewModel {
  final bool isPlaying;
  final double duration;
  final double playPosition;
  final String title;
  final List<Bookmark> bookmarks;
  final List<int> bookmarkTimes;

  PlayscreenViewModel(
      {this.isPlaying,
      this.duration,
      this.playPosition,
      this.title,
      this.bookmarks,
      this.bookmarkTimes});

  factory PlayscreenViewModel.fromStore(Store<AppState> store) {
    return PlayscreenViewModel(
      isPlaying: store.state.isPlaying,
      duration: store.state.duration,
      playPosition: store.state.playPosition,
      title: store.state.title,
      bookmarks: store.state.bookmarks,
      bookmarkTimes: store.state.bookmarkTimes,
    );
  }
}
