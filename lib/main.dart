import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: PlayButton(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Icon(
          Icons.forward_30,
          color: Colors.white,
          size: 48.0,
          semanticLabel: '15 secs',
          ),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: Icon(
            Icons.forward_10,
            color: Colors.white,
            size: 48.0,
            semanticLabel: '30 secs',
            ),
        ),
      ],
    ),
    );
  }
}

class PlayButton extends StatefulWidget {
  PlayButton({Key key}) : super(key: key);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool _isPlaying = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IconButton(
        icon: _isPlaying
          ? Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 48.0,
            )
          : Icon(
            Icons.pause_circle_outline,
            color: Colors.white,
            size: 48.0,
            ),
        onPressed: () {
          setState(() {
            print('pressed!');
            _isPlaying = !_isPlaying;
            print(' isplaying? | $_isPlaying');
          });
        }
      ),
    );
  }
}
