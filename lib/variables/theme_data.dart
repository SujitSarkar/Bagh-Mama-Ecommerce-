import 'package:bagh_mama/variables/color_variables.dart';
import 'package:flutter/material.dart';

class SThemeData{
  static final ThemeData lightThemeData= ThemeData(
      backgroundColor:  Colors.white,
      primarySwatch: MaterialColor(0xffFF5C00, CColor.lightThemeMapColor),
      canvasColor: Colors.transparent,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          selectedItemColor: CColor.lightThemeColor
      )
  );

  static final ThemeData darkThemeData= ThemeData(
      backgroundColor: CColor.darkThemeColor,
      primarySwatch: MaterialColor(0xff1F221F, CColor.darkThemeMapColor),
      canvasColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white
      )
  );
}