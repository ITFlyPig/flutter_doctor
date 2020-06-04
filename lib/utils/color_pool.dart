import 'dart:math';

import 'dart:ui';

import 'package:flutter/material.dart';


class ColorPool {
  static List<Color> colors = [

    Color(0xffad4e00),
    Colors.deepOrange[800],
    Color(0xff3f6600),
    Color(0xff006d75),
    Color(0xff391085),
    Colors.deepOrange[600],
    Color(0xffeb2f96),
    Colors.lime[500],
    Color(0xff722ed1),
    Colors.lime[600],
    Color(0xffffc53d),
    Colors.lime[700],
    Colors.deepOrange[900],
    Color(0xffad6800),
    Colors.lime[800],
    Color(0xffff5722),
    Colors.lime[900],

    Color(0xffe57373),
    Color(0xffcf1322),
    Color(0xff5a5a5a),
    Color(0xff795548),
    Color(0xff43a047),
    Color(0xff0288d1),
    Color(0xffffab00),
    Color(0xff009688),
    Colors.amber[700],
    Colors.amber[300],
    Colors.deepOrange[200],
    Colors.amber[400],
    Colors.deepOrange[300],
    Colors.amber[500],
    Colors.deepOrange[400],
    Colors.amber[600],
    Colors.deepOrange[500],
    Color(0xff876800),

    Colors.amber[800],

    Colors.amber[900],


  ];

  static int index = 0;

  ///随机的颜色
  static Color randomColor() {
   index++;
   if (index >= colors.length) {
     index = 0;
   }
    return colors[index];
  }
}
