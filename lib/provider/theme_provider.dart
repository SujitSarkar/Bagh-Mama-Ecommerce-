import 'dart:math';

import 'package:bagh_mama/variables/color_variables.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData;
  bool _isLight;
  ThemeProvider(this._themeData,this._isLight);
  bool _internetConnected=true;
  String _currencyTo='BDT';
  String _currency='TK.';

  get themeData => _themeData;
  get isLight => _isLight;
  get internetConnected=> _internetConnected;
  get currencyTo=> _currencyTo;
  get currency=> _currency;

  set currencyTo(String val){
    _currencyTo = val;
    notifyListeners();
  }
  set currency(String val){
    _currency = val;
    notifyListeners();
  }

  Future<void> toggleThemeData()async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    _isLight = !_isLight;
    if(_isLight){
      _themeData = ThemeData(
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
      notifyListeners();
      pref.setBool('isLight', true);
    }else{
      _themeData = ThemeData(
          backgroundColor: CColor.darkThemeColor,
          primarySwatch: MaterialColor(0xff1F221F, CColor.darkThemeMapColor),
          canvasColor: Colors.transparent,
          indicatorColor: Colors.grey,
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
      //_isLight=false;
      notifyListeners();
      pref.setBool('isLight', false);
    }
  }

  // Future<void> checkConnectivity() async {
  //   var result = await (Connectivity().checkConnectivity());
  //   if (result == ConnectivityResult.none) {
  //     _internetConnected = false;
  //     notifyListeners();
  //   } else if (result == ConnectivityResult.mobile) {
  //     _internetConnected = true;
  //     notifyListeners();
  //   } else if (result == ConnectivityResult.wifi) {
  //     _internetConnected = true;
  //     notifyListeners();
  //   }
  // }

  dynamic roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  String toggleCurrency(String amount){
    if(_currencyTo=='USD'){
      double result= roundDouble(double.parse(amount)*0.012, 3);
      return result.toString();
    }
    else return amount;

  }
  Color toggleBgColor()=> _isLight? Colors.white:CColor.darkThemeColor;
  Color toggleTextColor()=> _isLight? Colors.grey[800]:Colors.grey[300];
  Color orangeWhiteToggleColor()=> _isLight? CColor.lightThemeColor:Colors.white;
  Color orangeBlackToggleColor()=> _isLight? CColor.lightThemeColor:Colors.black;
  Color togglePageBgColor()=> _isLight? Color(0xffEFF3F4) :CColor.darkThemeColor;
  Color whiteBlackToggleColor()=> _isLight? Colors.white :CColor.darkThemeColor;
  Color selectedToggleColor()=> _isLight? Color(0xffEFF3F4) :Colors.grey[800];
  Color fabToggleBgColor()=> _isLight? CColor.lightThemeColor :Colors.grey[600];
  Color toggleFabRingBgColor()=> _isLight? CColor.lightThemeColor :Colors.grey[600];
  Color toggleCartColor()=> _isLight? Colors.white :Colors.grey[800];
  Color liteDeepGreyToggleColor()=> _isLight? Colors.grey[700] :Colors.grey[800];
  Color toggleSnackBgColor()=> _isLight? Colors.black.withOpacity(0.7) :Colors.grey[600].withOpacity(0.7);

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