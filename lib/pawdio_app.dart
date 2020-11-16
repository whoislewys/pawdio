import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:pawdio/db/pawdio_db.dart';
import 'package:pawdio/models/app_state.dart';
import 'package:pawdio/screens/library/library.dart';
import 'package:pawdio/redux/store.dart';

class PawdioApp extends StatelessWidget {
  // Create your store as a final variable in the main function or inside a
  // State object. This works better with Hot Reload than creating it directly
  // in the `build` function.

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // imageCache.clear();
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'The best audio player in the world',
        theme: ThemeData.dark(),
        home: LibraryScreen(),
      ),
    );
  }
}
