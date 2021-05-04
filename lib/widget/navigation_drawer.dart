import 'package:bagh_mama/drawer_pages/about_us.dart';
import 'package:bagh_mama/drawer_pages/complain_page.dart';
import 'package:bagh_mama/drawer_pages/faq_page.dart';
import 'package:bagh_mama/drawer_pages/how_to_order.dart';
import 'package:bagh_mama/drawer_pages/shop_page.dart';
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.width*.03),
                      Image.asset('assets/logo.png',height: size.width*.12,fit: BoxFit.cover),
                      SizedBox(height: size.width*.07),

                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'Shop', FontAwesomeIcons.store),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'How To Order', FontAwesomeIcons.shoppingBasket),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'About Us', FontAwesomeIcons.infoCircle),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'Common FAQ', FontAwesomeIcons.solidQuestionCircle),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'Complain', FontAwesomeIcons.exclamationTriangle),
                      Divider(color: Colors.grey,height: 0.5),

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
      if(name=='Shop') Navigator.push(context,
          MaterialPageRoute(builder: (context) => ShopPage()));
      else if(name=='How To Order') Navigator.push(context,
          MaterialPageRoute(builder: (context) => HowToOrder()));
      else if(name=='About Us') Navigator.push(context,
          MaterialPageRoute(builder: (context) => AboutUsPage()));
      else if(name=='Complain') Navigator.push(context,
          MaterialPageRoute(builder: (context) => ComplainPage()));
      else if(name=='Common FAQ') Navigator.push(context,
          MaterialPageRoute(builder: (context) => FaqPage()));
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
      size: size.width * .044,
    ),
  );
}
