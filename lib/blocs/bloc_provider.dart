import 'package:flutter/widgets.dart';
import 'package:pawdio/blocs/bloc.dart';

// A generic provider to inject BLoCs into the widget tree
class BlocProvider<T extends Bloc> extends StatefulWidget {
  final Widget child;
  final T bloc;

  const BlocProvider({Key key, @required this.bloc, @required this.child})
    : super(key: key);

  // of method allows widgets to retrive the BlocProvider from a descendant in the widget tree
  // with current BuildContext (e.g `Theme.of(context) blah blah blah`)
  static T of<T extends Bloc>(BuildContext ctx) {
    // final type = _providerType<BlocProvider<T>>();
    // final BlocProvider<T> provider = ctx.ancestorWidgetOfExactType(type);
    // ^ above was deprecated, try below and see if it still works ^
    final BlocProvider<T> provider = ctx.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return provider.bloc;
  }

  // acrobatics to pass deprecated code a reference to blocprovider type
  // static Type _providerType<T>() => T;

  @override
  State createState() => _BlocProviderState();
}

class _BlocProviderState extends State<BlocProvider> {
  // This widgets build method simply calls build method of its child
  @override
  Widget build(BuildContext ctx) => widget.child;

  // Inherits from stateful widget just to get state.dispose()
  // So that when flutter intelligently disposes state, we can hook in and dispose our blocs (close their streams)
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}