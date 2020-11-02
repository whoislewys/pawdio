import 'package:pawdio/models/app_state.dart';
import 'package:pawdio/models/audio.dart';
import 'package:redux/redux.dart';

// Used to trigger middleware which makes localdb/api call to fill audios
class HydrateAudiosAction {}

// Actually populates store.state.audios
class AddAudiosAction {
  final List<Audio> audios;
  AddAudiosAction(this.audios);
}
