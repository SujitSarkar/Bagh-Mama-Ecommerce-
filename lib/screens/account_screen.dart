import 'package:bagh_mama/pages/change_theme.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return  Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeProvider.togglePageBgColor(),
      body: SafeArea(
        child: _bodyUI(size, themeProvider),
      ),
      floatingActionButton: Builder(
        builder: (context) => _floatingActionButton(size, themeProvider),
    ),
    );
  }

  Widget _bodyUI(Size size, ThemeProvider themeProvider)=>Container(
    child: SingleChildScrollView(
      child: Column(
        children: [
          ///Header
          UserAccountsDrawerHeader(
            currentAccountPicture: Container(
              height: size.width*.2,
              width: size.width*.2,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(size.width*.2)),
                  image: DecorationImage(
                      image: AssetImage('assets/product_image/product.jpg'),
                      fit: BoxFit.cover
                  )
              ),
            ),
              accountName: Text('Yous Name Here',style: TextStyle(fontSize: size.width*.05),),
              accountEmail: Text('Example@gmail.com',style: TextStyle(fontSize: size.width*.038),),
          ),
          SizedBox(height: 10),

          ///Body
          Container(
            decoration: BoxDecoration(
              color: themeProvider.whiteBlackToggleColor()
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                ListTile(
                  onTap:(){},
                  leading: Icon(FontAwesomeIcons.solidHeart,color: Colors.grey,size: size.width*.06,),
                  title: Text('WISHLIST',style: TextStyle(color: themeProvider.toggleTextColor(),fontWeight: FontWeight.w500,fontSize: size.width*.04),),
                  trailing: Icon(FontAwesomeIcons.angleRight,color: Colors.grey,size: size.width*.06,),
                ),
                Divider(color: Colors.grey,),
                ListTile(
                  onTap:(){},
                  leading: Icon(FontAwesomeIcons.shoppingBasket,color: Colors.grey,size: size.width*.06,),
                  title: Text('ORDERS',style: TextStyle(color: themeProvider.toggleTextColor(),fontWeight: FontWeight.w500,fontSize: size.width*.04),),
                  trailing: Icon(FontAwesomeIcons.angleRight,color: Colors.grey,size: size.width*.06,),
                ),
                Divider(color: Colors.grey,),
                ListTile(
                  onTap:(){},
                  leading: Icon(FontAwesomeIcons.mapMarkerAlt,color: Colors.grey,size: size.width*.06,),
                  title: Text('ADDRESS',style: TextStyle(color: themeProvider.toggleTextColor(),fontWeight: FontWeight.w500,fontSize: size.width*.04),),
                  trailing: Icon(FontAwesomeIcons.angleRight,color: Colors.grey,size: size.width*.06,),
                ),
                Divider(color: Colors.grey,),
                ListTile(
                  onTap:()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangeThemePage())),
                  leading: Icon(FontAwesomeIcons.cog,color: Colors.grey,size: size.width*.06,),
                  title: Text('SETTINGS',style: TextStyle(color: themeProvider.toggleTextColor(),fontWeight: FontWeight.w500,fontSize: size.width*.04),),
                  trailing: Icon(FontAwesomeIcons.angleRight,color: Colors.grey,size: size.width*.06,),
                ),
                Divider(color: Colors.grey,),
                ListTile(
                  onTap:(){},
                  leading: Icon(FontAwesomeIcons.shareAlt,color: Colors.grey,size: size.width*.06,),
                  title: Text('SHARE APP',style: TextStyle(color: themeProvider.toggleTextColor(),fontWeight: FontWeight.w500,fontSize: size.width*.04),),
                  trailing: Icon(FontAwesomeIcons.angleRight,color: Colors.grey,size: size.width*.06,),
                ),
                Divider(color: Colors.grey,),
                ListTile(
                  onTap:(){},
                  leading: Icon(FontAwesomeIcons.signOutAlt,color: Colors.grey,size: size.width*.06,),
                  title: Text('LOGOUT',style: TextStyle(color: themeProvider.toggleTextColor(),fontWeight: FontWeight.w500,fontSize: size.width*.04),),
                  trailing: Icon(FontAwesomeIcons.angleRight,color: Colors.grey,size: size.width*.06,),
                ),

              ],
            ),
          )
        ],
      ),
    ),
  );

  Widget _floatingActionButton(Size size, ThemeProvider themeProvider)=>FabCircularMenu(
    key: fabKey,
    // Cannot be `Alignment.center`
    alignment: Alignment.bottomRight,
    ringColor: themeProvider.toggleFabRingBgColor(),
    ringDiameter: 450.0,
    ringWidth: 100.0,
    fabSize: 60.0,
    fabElevation: 5.0,
    fabIconBorder: CircleBorder(),
    fabColor: themeProvider.fabToggleBgColor(),
    fabOpenIcon: Icon(FontAwesomeIcons.solidCommentAlt, color: Colors.white,size: size.width*.06,),
    fabCloseIcon: Icon(Icons.close, color: Colors.white),
    fabMargin: EdgeInsets.only(right: 5,bottom: 5),
    animationDuration: Duration(milliseconds: 700),
    animationCurve: Curves.easeInOutCirc,
    onDisplayChange: (isOpen) {
      print("The menu is ${isOpen ? "open" : "closed"}");
    },
    children: <Widget>[
      Container(),
      RawMaterialButton(
        onPressed: () {
          print("You pressed 4. This one closes the menu on tap");
          fabKey.currentState.close();
        },
        shape: CircleBorder(),
        padding:  EdgeInsets.all(20.0),
        child: Icon(FontAwesomeIcons.commentAlt, color: Colors.white,size: size.width*.075),
      ),
      RawMaterialButton(
        onPressed: () {
          print("You pressed 3");
          fabKey.currentState.close();
        },
        shape: CircleBorder(),
        padding:  EdgeInsets.all(20.0),
        child: Icon(FontAwesomeIcons.envelope, color: Colors.white,size: size.width*.08),
      ),
      RawMaterialButton(
        onPressed: () {
          print( "You pressed 2");
          fabKey.currentState.close();
        },
        shape: CircleBorder(),
        padding:  EdgeInsets.all(20.0),
        child: Icon(FontAwesomeIcons.whatsapp, color: Colors.white,size: size.width*.085),
      ),

      RawMaterialButton(
        onPressed: () {
          print( "You pressed 1");
          fabKey.currentState.close();
        },
        shape: CircleBorder(),
        padding:  EdgeInsets.all(20.0),
        child: Icon(Icons.local_phone_outlined, color: Colors.white,size: size.width*.08),
      ),

    ],
  );

}
