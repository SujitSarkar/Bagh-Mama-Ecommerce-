import 'package:flutter/material.dart';

class CColor {
  List<int> lst = [255, 92, 0];

  static final Map<int, Color> lightThemeMapColor = {
    //RGB Color Code (0, 194, 162) Hex: 0xff0095B2
    50: Color.fromRGBO(255, 92, 0, .1),
    100: Color.fromRGBO(255, 92, 0, .2),
    200: Color.fromRGBO(255, 92, 0, .3),
    300: Color.fromRGBO(255, 92, 0, .4),
    400: Color.fromRGBO(255, 92, 0, .5),
    500: Color.fromRGBO(255, 92, 0, .6),
    600: Color.fromRGBO(255, 92, 0, .7),
    700: Color.fromRGBO(255, 92, 0, .8),
    800: Color.fromRGBO(255, 92, 0, .9),
    900: Color.fromRGBO(255, 92, 0, 1),
  };

  static final Map<int, Color> darkThemeMapColor = {
    //RGB Color Code (0, 194, 162) Hex: 0xff0095B2
    50: Color.fromRGBO(31, 34, 31, .1),
    100: Color.fromRGBO(31, 34, 31, .2),
    200: Color.fromRGBO(31, 34, 31, .3),
    300: Color.fromRGBO(31, 34, 31, .4),
    400: Color.fromRGBO(31, 34, 31, .5),
    500: Color.fromRGBO(31, 34, 31, .6),
    600: Color.fromRGBO(31, 34, 31, .7),
    700: Color.fromRGBO(31, 34, 31, .8),
    800: Color.fromRGBO(31, 34, 31, .9),
    900: Color.fromRGBO(31, 34, 31, 1),
  };

  static final Color lightThemeColor = Color(0xffFF5C00);
  static final Color darkThemeColor = Color(0xff1F221F);
}
