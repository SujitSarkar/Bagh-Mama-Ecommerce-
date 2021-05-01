import 'package:bagh_mama/variables/color_variables.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData;
  bool _isLight;

  ThemeProvider(this._themeData,this._isLight);

  get themeData => _themeData;

  get isLight => _isLight;

  Future<void> toggleThemeData()async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    _isLight = !_isLight;
    if(_isLight){
      _themeData = ThemeData(
          backgroundColor:  Colors.white,
          primarySwatch: MaterialColor(0xffFF5C00, CColor.lightThemeMapColor),
          canvasColor: Colors.transparent,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              //backgroundColor: Colors.white,
              elevation: 0.0,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.grey,
              selectedItemColor: CColor.lightThemeColor
          )
      );
      //_isLight=true;
      notifyListeners();
      pref.setBool('isLight', true);
    }else{
      _themeData = ThemeData(
          backgroundColor: Colors.black,
          primarySwatch: MaterialColor(0xff1F221F, CColor.darkThemeMapColor),
          canvasColor: Colors.transparent,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              //backgroundColor: CColor.darkThemeColor,
              elevation: 0.0,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.grey,
              selectedItemColor: Colors.white
          )
      );
      //_isLight=false;
      notifyListeners();
      pref.setBool('isLight', false);
    }
  }


  Color toggleBgColor()=> _isLight? Colors.white:CColor.darkThemeColor;
  Color toggleTextColor()=> _isLight? Colors.grey[800]:Colors.grey[300];
  Color orangeWhiteToggleColor()=> _isLight? CColor.lightThemeColor:Colors.white;
  Color togglePageBgColor()=> _isLight? Color(0xffEFF3F4) :CColor.darkThemeColor;
  Color whiteBlackToggleColor()=> _isLight? Colors.white :CColor.darkThemeColor;
  Color selectedToggleColor()=> _isLight? Color(0xffEFF3F4) :Colors.grey[800];
  Color fabToggleBgColor()=> _isLight? CColor.lightThemeColor :Colors.grey[600];
  Color toggleFabRingBgColor()=> _isLight? CColor.lightThemeColor :Colors.grey[600];
  Color toggleCartColor()=> _isLight? Colors.white :Colors.grey[800];

  ThemeColor themeMode() {
    return ThemeColor(
      gradient: [
        if (isLight) ...[Color(0xDDFF0080), Color(0xDDFF8C00)],
        if (!isLight) ...[Color(0xFF8983F7), Color(0xFFA3DAFB)]
      ],
      textColor: isLight ? Color(0xFF000000) : Color(0xFFFFFFFF),
      toggleButtonColor: isLight ? Color(0xFFFFFFFF) : Color(0xFf34323d),
      toggleBackgroundColor:
      isLight ? Color(0xFFe7e7e8) : Color(0xFF222029),
      shadow: [
        if (isLight)
          BoxShadow(
              color: Color(0xFFd8d7da),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 5)),
        if (!isLight)
          BoxShadow(
              color: Color(0x66000000),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 5))
      ],
    );
  }
}

class ThemeColor {
  List<Color> gradient;
  Color backgroundColor;
  Color toggleButtonColor;
  Color toggleBackgroundColor;
  Color textColor;
  List<BoxShadow> shadow;

  ThemeColor({
    this.gradient,
    this.backgroundColor,
    this.toggleBackgroundColor,
    this.toggleButtonColor,
    this.textColor,
    this.shadow,
  });
}