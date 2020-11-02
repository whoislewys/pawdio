import 'package:pawdio/db/pawdio_db.dart';
import 'package:pawdio/models/app_state.dart';
import 'package:pawdio/models/audio.dart';
import 'package:pawdio/redux/library/actions.dart';
import 'package:redux/redux.dart';

// TODO: finish
Future<void> hydrateAudiosMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is HydrateAudiosAction) {
    final database = await PawdioDb.create(); // should get instance, not create anew
    final fetchedAudios = await database.getAllAudios();
    List<Audio> audios = fetchedAudios.map((row) => Audio.fromRow(row));
    if (fetchedAudios.length == 0) {
      print('no audios');
    }
    print('got audios: ${audios}');
    store.dispatch(AddAudiosAction(audios));
    next(action);
  }
}
