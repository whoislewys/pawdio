import 'package:flutter/widgets.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final inactiveCallback;
  LifecycleEventHandler({this.inactiveCallback});

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        await inactiveCallback();
        break;
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
