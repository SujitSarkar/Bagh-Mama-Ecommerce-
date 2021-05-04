import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/screens/account_screen.dart';
import 'package:bagh_mama/screens/cart_screen.dart';
import 'package:bagh_mama/screens/category_screen.dart';
import 'package:bagh_mama/screens/home_screen.dart';
import 'package:bagh_mama/screens/track_order_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CategoryScreen(),
    TrackOrderScreen(),
    CartScreen(),
    AccountScreen()
  ];
  void _onItemTapped(int index) => setState(()=> _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child){
        return Scaffold(
          backgroundColor: themeProvider.toggleBgColor(),
          body:  _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: Material(
            color: themeProvider.toggleBgColor(),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.box),
                  label: 'Category',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.truck),
                  label: 'Track',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.shoppingBasket),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.userAlt),
                  label: 'Account',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        );
      },
    );
  }
}
