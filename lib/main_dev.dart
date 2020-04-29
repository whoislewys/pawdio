import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawdio/config.dart';
import 'package:pawdio/screens/library/library.dart';

import 'package:flutter_stetho/flutter_stetho.dart';

void main() {
  print('devmode_D E V   M O D E_devmode');
  var configuredApp = Config(appName: 'Pawdio', flavor: 'dev', child: MyApp());
  Stetho.initialize();
  runApp(configuredApp);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // imageCache.clear();
    return MaterialApp(
        title: 'The best audio player in the world',
        home: LibraryScreen(),
        // home: Playscreen(),
        theme: ThemeData.dark(),
      );
  }
}
