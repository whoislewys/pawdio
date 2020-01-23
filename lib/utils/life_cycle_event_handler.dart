import 'package:flutter/widgets.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final inactiveCallback;
  LifecycleEventHandler({this.inactiveCallback});

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        await inactiveCallback();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await inactiveCallback();
        break;
      case AppLifecycleState.resumed:
    }
    print('''
=============================================================
               $state
=============================================================
''');
  }
}