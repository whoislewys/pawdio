import 'package:flutter/widgets.dart';
import 'package:pawdio/screens/play/play.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    return MaterialApp(
      title: 'The best audio player in the world',
      home: Player(),
      theme: ThemeData.dark(),
    );
  }
}