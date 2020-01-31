import 'package:flutter/material.dart';
import 'package:pawdio/blocs/bloc_provider.dart';
import 'package:pawdio/blocs/current_file_path_bloc.dart';
import 'package:pawdio/screens/library/library.dart';
import 'package:pawdio/screens/play/play.dart';

class MainScreen extends StatelessWidget {
  @override
  // Widget build(BuildContext ctx) {
  //   return StreamBuilder<String>(
  //       stream: BlocProvider.of<CurrentFilePathBloc>(ctx).filePathStream,
  //       builder: (context, snapshot) {
  //         final currentFilePath = snapshot.data;
  //         if (currentFilePath == null) {
  //           return LibraryScreen();
  //         }
  //         print('currentfilepath $currentFilePath');
  //         return Playscreen();
  //       });
  // }

  Widget build(BuildContext ctx) {
    return LibraryScreen();
  }
}
