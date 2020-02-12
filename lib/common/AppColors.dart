import 'dart:math';

import 'package:flutter/material.dart';

/// @date:2020-01-20
/// @author:Silence
/// @describe:
class AppColors {
  static Color colorPrimary = const Color(0xff0091ea);
  static Color color999999 = const Color(0xff999999);
  static Color colorEFEFEF = const Color(0xffefefef);

  static Color randomColor() {
    var red = Random().nextInt(190);
    var green = Random().nextInt(190);
    var blue = Random().nextInt(190);
    return Color.fromRGBO(red, green, blue, 1.0);
  }
}
