import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/screens/account_screen.dart';
import 'package:bagh_mama/screens/cart_screen.dart';
import 'package:bagh_mama/screens/category_screen.dart';
import 'package:bagh_mama/screens/home_screen.dart';
import 'package:bagh_mama/variables/color_variables.dart';
import 'package:bagh_mama/variables/public_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0; //default index of a first screen

  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),//center button animation duration
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
          () => _animationController.forward(),
    );
  }

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CategoryScreen(),
    CartScreen(),
    AccountScreen()
  ];


  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: themeProvider.toggleBgColor(),
      extendBody: true,
      body:  _widgetOptions.elementAt(_bottomNavIndex),

      floatingActionButton: ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Image.asset('assets/bm_head.png',height:size.width*.12,width: size.width*.12,),
          onPressed: () {
            _animationController.reset();
            _animationController.forward();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: PublicData.navBarIconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? themeProvider.orangeWhiteToggleColor() : Colors.grey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PublicData.navBarIconList[index],
                size: size.width*.06,
                color: color,
              ),
               SizedBox(height: size.width*.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width*.02),
                child: AutoSizeText(
                  PublicData.navBarNameList[index],
                  maxLines: 1,
                  style: TextStyle(color: color),
                  group: autoSizeGroup,
                ),
              )
            ],
          );
        },
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        activeIndex: _bottomNavIndex,
        splashColor: themeProvider.orangeWhiteToggleColor(),
        notchAndCornersAnimation: animation,
        splashSpeedInMilliseconds: 500,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        // leftCornerRadius: 32,
        // rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}

