import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Config extends InheritedWidget{
  final String appName;
  final String flavor;

  Config({
    @required this.appName,
    @required this.flavor,
    @required Widget child,
    }) : 
    super(child: child);


  static Config of(BuildContext ctx) {
    return ctx.inheritFromWidgetOfExactType(Config);
  }

  // config should never update while app runs, so never notify
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
