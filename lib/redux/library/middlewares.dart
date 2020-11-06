import 'package:pawdio/db/pawdio_db.dart';
import 'package:pawdio/models/app_state.dart';
import 'package:pawdio/models/audio.dart';
import 'package:pawdio/redux/library/actions.dart';
import 'package:redux/redux.dart';

// Fill store.state.audios with all the cur user's audios
Future<void> hydrateAudiosMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  if (action is HydrateAudiosAction) {
    try {
      final database = await PawdioDb.create();
      try {
        List<Audio> audios = await database.getAllAudios();

        if (audios.length == 0) {
          print('no audios');
        }
        print('got audios in mware: $audios');
        store.dispatch(AddAudiosAction(audios));
      } catch(e) {
        print('error getting all audios: $e') ;
      }
    } catch(e) {
      print('error getting db instance: $e');
    }
  }
  next(action);
}

// Add a new audio from a file path to the user's library
Future<void> createAudioMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  if (action is CreateAudioAction) {
    final database = await PawdioDb.create();
    Audio audioResult = await database.getAudioByFilePath(action.filePath);

    if (audioResult != null) {
      // create entry in DB
      await database.createAudio(action.filePath);
      // get the entry we just made
      Audio newAudio = await database.getAudioByFilePath(action.filePath);
      // add audio to store
      store.dispatch(AddAudiosAction([newAudio]));
    }
  }
  next(action);
}
