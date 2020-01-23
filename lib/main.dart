import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawdio/screens/play/play.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    return MaterialApp(
      title: 'The best audio player in the world',
      home: Playscreen(),
      theme: ThemeData.dark(),
    );
  }
}