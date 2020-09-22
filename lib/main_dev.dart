import 'package:flutter/widgets.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:pawdio/config.dart';
import 'package:pawdio/pawdio_app.dart';

/// Dev mode includes Stetho for remote sqlite debugging at chrome://inspect/#devices
void main() {
  print('devmode__D E V   M O D E__devmode');
  var configuredApp =
      Config(appName: 'Pawdio', flavor: 'prod', child: PawdioApp());
  Stetho.initialize();
  runApp(configuredApp);
}
