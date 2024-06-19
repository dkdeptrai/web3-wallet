import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Routes {
  static String get root => "/";

  Route? onGenerateRoute(RouteSettings settings) {
    Widget widget;
    if (settings.name == root) {
      return null;
    }

    try {
      widget = GetIt.I.get<Widget>(instanceName: settings.name);
      print(widget);
    } catch (e) {
      widget = const Scaffold(
        body: Center(child: Text("404 NOT FOUND")),
      );
    }
    return CupertinoPageRoute(builder: (_) => widget, settings: settings);
  }
}
