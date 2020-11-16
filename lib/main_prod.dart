import 'package:pawdio/config.dart';
import 'package:flutter/widgets.dart';
import 'package:pawdio/pawdio_app.dart';

void main() {
  var configuredApp =
      Config(appName: 'Pawdio', flavor: 'prod', child: PawdioApp());
  runApp(configuredApp);
}
