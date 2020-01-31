import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawdio/blocs/current_file_path_bloc.dart';
import 'package:pawdio/screens/main_screen.dart';

import 'blocs/bloc_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // imageCache.clear();
    return BlocProvider<CurrentFilePathBloc>(
      bloc: CurrentFilePathBloc(),
      child: MaterialApp(
        title: 'The best audio player in the world',
        home: MainScreen(),
        // home: Playscreen(),
        theme: ThemeData.dark(),
      ),
    );
  }
}
