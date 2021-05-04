import 'package:bagh_mama/pages/change_theme.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: Drawer(
        child: Container(
          color: themeProvider.whiteBlackToggleColor(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ///Body
                Container(
                  decoration:
                  BoxDecoration(color: themeProvider.whiteBlackToggleColor()),
                  margin: EdgeInsets.symmetric(horizontal: size.width*.03),
                  child: Column(
                    children: [
                      _functionBuilder(themeProvider, size, 'WishLists', FontAwesomeIcons.solidHeart),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'Order History', FontAwesomeIcons.shoppingBasket),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'Notifications', FontAwesomeIcons.bell),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'Settings', FontAwesomeIcons.cog),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'Logout', FontAwesomeIcons.signOutAlt),

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _functionBuilder(ThemeProvider themeProvider, Size size, String name, IconData iconData) => ListTile(
    onTap: (){
      if(name=='Settings') Navigator.push(context,
          MaterialPageRoute(builder: (context) => ChangeThemePage()));
      else if(name=='WishLists') Navigator.push(context,
          MaterialPageRoute(builder: (context) => ChangeThemePage()));
      else if(name=='Order History') Navigator.push(context,
          MaterialPageRoute(builder: (context) => ChangeThemePage()));
      else if(name=='Notifications') Navigator.push(context,
          MaterialPageRoute(builder: (context) => ChangeThemePage()));

    },
    leading: Icon(
      iconData,
      color: Colors.grey,
      size: size.width * .06,
    ),
    title: Text(
      name,
      style: TextStyle(
          color: themeProvider.toggleTextColor(),
          fontWeight: FontWeight.w500,
          fontSize: size.width * .04),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.grey,
      size: size.width * .06,
    ),
  );
}
