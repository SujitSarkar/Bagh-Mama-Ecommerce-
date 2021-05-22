import 'package:bagh_mama/main_screen.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/variables/color_variables.dart';
import 'package:bagh_mama/variables/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref= await SharedPreferences.getInstance();
  final bool isLight = pref.getBool('isLight') ?? true;
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
      statusBarColor: Colors.white,
  ));
  runApp(MyApp(isLight));
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  bool isLight;
  MyApp(this.isLight);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 3000) //display duration of [showSuccess] [showError] [showInfo], default 2000ms.
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = Colors.black.withOpacity(0.75)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = CColor.lightThemeColor.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
    // ..customAnimation = CustomAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>ThemeProvider(widget.isLight?SThemeData.lightThemeData:SThemeData.darkThemeData,widget.isLight)),
        ChangeNotifierProvider(create: (_)=>APIProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            title: 'Bagh Mama',
            //home: LoginPage(),
            home: MainScreen(),
            builder: EasyLoading.init(),
          );
        },
      ),
    );
  }
}


