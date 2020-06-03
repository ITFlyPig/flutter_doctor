import 'package:flutter/material.dart';

export 'list_extensions.dart';
export 'widget_extensions.dart';
export 'widget_list_extensions.dart';

class WidgetChain {
  /// a util function, just return the param widget itself
  /// this function could been used for chain programming,
  /// for example:
  ///   WidgetChain
  ///     .addNeighbor(Text('a'))
  ///     .addNeighbor(Icon(Icons.add))
  ///     .intoContainer()
  ///     ;
  static Widget addNeighbor(Widget widget) {
    return widget;
  }
}
