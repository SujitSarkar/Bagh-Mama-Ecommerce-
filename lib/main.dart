import 'package:bagh_mama/main_screen.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/variables/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref= await SharedPreferences.getInstance();
  final bool isLight = pref.getBool('isLight') ?? true;
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
          );
        },
      ),
    );
  }
}


