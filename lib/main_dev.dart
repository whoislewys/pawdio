import 'package:flutter/widgets.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:pawdio/config.dart';
import 'package:pawdio/pawdio_app.dart';

import 'db/pawdio_db.dart';

/// Dev mode includes Stetho for remote sqlite debugging at chrome://inspect/#devices
void main() async {
  print('devmode__D E V   M O D E__devmode');
  // If you're running an application and need to access the binary messenger before `runApp()` has been called (for example, during plugin initialization), then you need to explicitly call the `WidgetsFlutterBinding.ensureInitialized()`
  WidgetsFlutterBinding.ensureInitialized();
  await PawdioDb.create();
  var configuredApp =
      Config(appName: 'Pawdio', flavor: 'prod', child: PawdioApp());
  Stetho.initialize();
  runApp(configuredApp);
}
