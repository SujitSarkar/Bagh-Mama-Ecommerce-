import 'dart:io';
import 'package:bagh_mama/pages/change_password.dart';
import 'package:bagh_mama/pages/change_theme.dart';
import 'package:bagh_mama/pages/login_page.dart';
import 'package:bagh_mama/pages/notification_list.dart';
import 'package:bagh_mama/pages/order_history_list.dart';
import 'package:bagh_mama/pages/update_profile.dart';
import 'package:bagh_mama/pages/wishlist_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  File _image;
  int _counter=0;
  SharedPreferences pref;

  void _customInit(APIProvider apiProvider)async{
    setState(()=> _counter++);
    pref = await SharedPreferences.getInstance();
    if(pref.getString('username')!=null){
      if(apiProvider.userInfoModel==null){
        await apiProvider.getUserInfo(pref.getString('username'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    if(_counter==0) _customInit(apiProvider);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
        body: _bodyUI(size, themeProvider,apiProvider),
        floatingActionButton: Builder(
          builder: (context) => _floatingActionButton(size, themeProvider),
        ),
      ),
    );
  }

  Widget _bodyUI(Size size, ThemeProvider themeProvider,APIProvider apiProvider) => Container(
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
                                        image: _image==null? NetworkImage('https://i.picsum.photos/id/1079/4496/3000.jpg?hmac=G-dJcpU08vEMqjUz2rb3IxjOG99rcePqW9BF1IsPLf0')
                                            :FileImage(_image),
                                        fit: BoxFit.cover)),
                              ),
                            ],
                          ),
                        ),

                        ///User Information
                        apiProvider.userInfoModel!=null? Container(
                          width: size.width*.45,
                          child:RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              //text: 'Hello ',
                              style: TextStyle(fontSize: size.width*.038,color: themeProvider.toggleTextColor()),
                              children: <TextSpan>[
                                TextSpan(text: '${apiProvider.userInfoModel.content.firstName} ${apiProvider.userInfoModel.content.lastName}\n',style: TextStyle(fontSize: size.width*.05,fontWeight: FontWeight.w500)),
                                TextSpan(text: '${apiProvider.userInfoModel.content.email}\n'),
                                TextSpan(text: '${apiProvider.userInfoModel.content.mobileNumber}\n\n'),
                                TextSpan(text: 'Address: ',style: TextStyle(fontWeight: FontWeight.w500)),
                                apiProvider.userInfoModel.content.address.isNotEmpty? TextSpan(text: '${apiProvider.userInfoModel.content.address}\n'):TextSpan(),
                                TextSpan(text: 'City: ',style: TextStyle(fontWeight: FontWeight.w500)),
                                apiProvider.userInfoModel.content.city.isNotEmpty? TextSpan(text: '${apiProvider.userInfoModel.content.city}\n'):TextSpan(),
                                TextSpan(text: 'State: ',style: TextStyle(fontWeight: FontWeight.w500)),
                                apiProvider.userInfoModel.content.state.isNotEmpty? TextSpan(text: '${apiProvider.userInfoModel.content.state}\n'):TextSpan(),
                                TextSpan(text: 'Postal Code: ',style: TextStyle(fontWeight: FontWeight.w500)),
                                apiProvider.userInfoModel.content.postalcode.isNotEmpty?TextSpan(text: '${apiProvider.userInfoModel.content.postalcode}\n'):TextSpan(),
                                TextSpan(text: 'From: ',style: TextStyle(fontWeight: FontWeight.w500)),
                                apiProvider.userInfoModel.content.country.isNotEmpty? TextSpan(text: '${apiProvider.userInfoModel.content.country}\n'):TextSpan(),
                              ],
                            ),
                          ),
                        ):TextButton(
                            onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage())),
                            child: Text('Login',style: TextStyle(color: themeProvider.orangeWhiteToggleColor()),))
                      ],
                    ),
                    SizedBox(height: size.width*.02),

                    ///Update Buttons
                    apiProvider.userInfoModel!=null? Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       _buttonBuilder(themeProvider, size, Icons.camera_alt),
                       SizedBox(width: size.width*.03),
                       _buttonBuilder(themeProvider, size, Icons.edit),
                       SizedBox(width: size.width*.03),
                       _buttonBuilder(themeProvider, size, Icons.vpn_key_sharp),
                     ],
                   ):Container()


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
                    _functionBuilder(apiProvider, themeProvider, size, 'WishLists', FontAwesomeIcons.solidHeart),
                    Divider(color: Colors.grey,height: 0.5),
                    _functionBuilder(apiProvider,themeProvider, size, 'Order History', FontAwesomeIcons.shoppingBasket),
                    Divider(color: Colors.grey,height: 0.5),
                    _functionBuilder(apiProvider,themeProvider, size, 'Notifications', FontAwesomeIcons.bell),
                    Divider(color: Colors.grey,height: 0.5),
                    _functionBuilder(apiProvider,themeProvider, size, 'Settings', FontAwesomeIcons.cog),
                    Divider(color: Colors.grey,height: 0.5),
                    _functionBuilder(apiProvider,themeProvider, size, 'Logout', FontAwesomeIcons.signOutAlt),

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

  Widget _functionBuilder(APIProvider apiProvider, ThemeProvider themeProvider, Size size, String name, IconData iconData) => ListTile(
        onTap: (){
          if(name=='Settings') Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChangeThemePage()));
          else if(name=='WishLists') Navigator.push(context,
              MaterialPageRoute(builder: (context) => WishListPage()));
          else if(name=='Order History') Navigator.push(context,
              MaterialPageRoute(builder: (context) => OrderHistory()));
          else if(name=='Notifications') Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationList()));
          else if(name=='Logout') {
            pref.clear();
            apiProvider.userInfoModel=null;
          }

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
