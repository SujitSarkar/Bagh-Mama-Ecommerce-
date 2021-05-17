import 'dart:io';
import 'package:bagh_mama/pages/change_password.dart';
import 'package:bagh_mama/pages/change_theme.dart';
import 'package:bagh_mama/pages/notification_list.dart';
import 'package:bagh_mama/pages/order_history_list.dart';
import 'package:bagh_mama/pages/update_profile.dart';
import 'package:bagh_mama/pages/wishlist_page.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  File _image;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        //backgroundColor: themeProvider.togglePageBgColor(),
        appBar: AppBar(
          backgroundColor: themeProvider.whiteBlackToggleColor(),
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.grey,
          ),
          title: Text(
            'My Account',
            style: TextStyle(
                color: themeProvider.toggleTextColor(),
                fontSize: size.width * .045),
          ),
        ),
        body: _bodyUI(size, themeProvider),
        floatingActionButton: Builder(
          builder: (context) => _floatingActionButton(size, themeProvider),
        ),
      ),
    );
  }

  Widget _bodyUI(Size size, ThemeProvider themeProvider) => Container(
        child: SingleChildScrollView(
          child: Column(
            children: [

              ///Header Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width*.03,vertical: size.width*.03),
                color: themeProvider.whiteBlackToggleColor(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///Profile Image Container
                        Container(
                          width: size.width*.45,
                          child: Column(
                            children: [
                              Container(
                                height: size.width * .45,
                                width: size.width * .45,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10),),
                                    image: DecorationImage(
                                        image: _image==null? NetworkImage('https://i.picsum.photos/id/1027/2848/4272.jpg?hmac=EAR-f6uEqI1iZJjB6-NzoZTnmaX0oI0th3z8Y78UpKM')
                                            :FileImage(_image),
                                        fit: BoxFit.cover)),
                              ),
                            ],
                          ),
                        ),

                        ///User Information
                        Container(
                          width: size.width*.45,
                          child:RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              //text: 'Hello ',
                              style: TextStyle(fontSize: size.width*.038,color: themeProvider.toggleTextColor()),
                              children: <TextSpan>[
                                TextSpan(text: 'Mr. Tanvir Ahmed\n',style: TextStyle(fontSize: size.width*.05,fontWeight: FontWeight.w500)),
                                TextSpan(text: 'example@gmail.com\n'),
                                TextSpan(text: '+8801830200087\n\n'),
                                TextSpan(text: 'Address: ',style: TextStyle(fontWeight: FontWeight.w500)),
                                TextSpan(text: 'Dhaka\n'),
                                TextSpan(text: 'City: ',style: TextStyle(fontWeight: FontWeight.w500)),
                                TextSpan(text: 'Dhaka\n'),
                                TextSpan(text: 'State: ',style: TextStyle(fontWeight: FontWeight.w500)),
                                TextSpan(text: 'Dhaka\n'),
                                TextSpan(text: 'Postal Code: ',style: TextStyle(fontWeight: FontWeight.w500)),
                                TextSpan(text: '1700\n'),
                                TextSpan(text: 'From: ',style: TextStyle(fontWeight: FontWeight.w500)),
                                TextSpan(text: 'Bangladesh\n'),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: size.width*.02),

                    ///Update Buttons
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       _buttonBuilder(themeProvider, size, Icons.camera_alt),
                       SizedBox(width: size.width*.03),
                       _buttonBuilder(themeProvider, size, Icons.edit),
                       SizedBox(width: size.width*.03),
                       _buttonBuilder(themeProvider, size, Icons.vpn_key_sharp),
                     ],
                   )


                  ],
                ),
              ),
              SizedBox(height: size.width*.03),

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
      );

  Future<void> _getImageFromGallery(ThemeProvider themeProvider)async{
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery,maxWidth: 400,maxHeight: 400);
    if(pickedFile!=null)
      setState(()=> _image = File(pickedFile.path));
    else showSnackBar(context,'No image selected!',themeProvider);
  }

  Widget _buttonBuilder(ThemeProvider themeProvider, Size size, IconData iconData)=>Container(
    width: size.width*.12,
    height: size.width*.12,
    decoration: BoxDecoration(
        color: themeProvider.fabToggleBgColor(),
        borderRadius: BorderRadius.all(Radius.circular(size.width*.08),
        )
    ),
    child: TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        minimumSize: Size(size.width*.12,size.width*.12),
      ),
      child: Icon(iconData,color: Colors.white,size: size.width*.07),
      onPressed: (){
        if(iconData==Icons.camera_alt) _getImageFromGallery(themeProvider);
        else if(iconData==Icons.vpn_key_sharp) Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChangePassword()));
        else if(iconData==Icons.edit) Navigator.push(context,
            MaterialPageRoute(builder: (context) => UpdateProfile()));
      },
    ),
  );

  Widget _functionBuilder(ThemeProvider themeProvider, Size size, String name, IconData iconData) => ListTile(
        onTap: (){
          if(name=='Settings') Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChangeThemePage()));
          else if(name=='WishLists') Navigator.push(context,
              MaterialPageRoute(builder: (context) => WishListPage()));
          else if(name=='Order History') Navigator.push(context,
              MaterialPageRoute(builder: (context) => OrderHistory()));
          else if(name=='Notifications') Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationList()));

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

  Widget _floatingActionButton(Size size, ThemeProvider themeProvider) =>
      FabCircularMenu(
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
        fabOpenIcon: Icon(
          FontAwesomeIcons.solidCommentAlt,
          color: Colors.white,
          size: size.width * .06,
        ),
        fabCloseIcon: Icon(Icons.close, color: Colors.white),
        fabMargin: EdgeInsets.only(right: 5, bottom: 5),
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
            padding: EdgeInsets.all(20.0),
            child: Icon(FontAwesomeIcons.commentAlt,
                color: Colors.white, size: size.width * .075),
          ),
          RawMaterialButton(
            onPressed: () {
              print("You pressed 3");
              fabKey.currentState.close();
            },
            shape: CircleBorder(),
            padding: EdgeInsets.all(20.0),
            child: Icon(FontAwesomeIcons.envelope,
                color: Colors.white, size: size.width * .08),
          ),
          RawMaterialButton(
            onPressed: () {
              print("You pressed 2");
              fabKey.currentState.close();
            },
            shape: CircleBorder(),
            padding: EdgeInsets.all(20.0),
            child: Icon(FontAwesomeIcons.whatsapp,
                color: Colors.white, size: size.width * .085),
          ),
          RawMaterialButton(
            onPressed: () {
              print("You pressed 1");
              fabKey.currentState.close();
            },
            shape: CircleBorder(),
            padding: EdgeInsets.all(20.0),
            child: Icon(Icons.local_phone_outlined,
                color: Colors.white, size: size.width * .08),
          ),
        ],
      );
}
