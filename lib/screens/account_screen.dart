import 'dart:io';
import 'package:bagh_mama/pages/change_password.dart';
import 'package:bagh_mama/pages/change_theme.dart';
import 'package:bagh_mama/pages/login_page.dart';
import 'package:bagh_mama/pages/no_internet_page.dart';
import 'package:bagh_mama/pages/notification_list.dart';
import 'package:bagh_mama/pages/order_history_list.dart';
import 'package:bagh_mama/pages/update_profile.dart';
import 'package:bagh_mama/pages/wishlist_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/sqlite_database_helper.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  File _image;
  int _counter=0;
  SharedPreferences pref;
  bool _isLoading=true;

  void _customInit(ThemeProvider themeProvider, APIProvider apiProvider,DatabaseHelper databaseHelper)async{
    pref = await SharedPreferences.getInstance();
    setState(()=> _counter++);
    //await themeProvider.checkConnectivity();
    if(databaseHelper.cartList.isEmpty) await databaseHelper.getCartList();
    if(pref.getString('username')!=null){
      if(apiProvider.userInfoModel==null){
        await apiProvider.getUserInfo(pref.getString('username'));
      }
    }
    if(apiProvider.basicContactInfo==null) await apiProvider.getBasicContactInfo();
    setState(()=> _isLoading=false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);
    if(_counter==0 && themeProvider.internetConnected) _customInit(themeProvider,apiProvider,databaseHelper);

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
        body:themeProvider.internetConnected? _bodyUI(size, themeProvider,apiProvider,databaseHelper):NoInternet(),
        floatingActionButton: Builder(
          builder: (context) => _floatingActionButton(size, themeProvider,apiProvider),
        ),
      ),
    );
  }

  Widget _bodyUI(Size size, ThemeProvider themeProvider,APIProvider apiProvider,DatabaseHelper databaseHelper) =>
      _isLoading
          ?Center(child: threeBounce(themeProvider))
          :Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                            height: size.width * .45,
                            width: size.width * .45,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                            ),
                            child: apiProvider.userInfoModel!=null
                                ?ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: CachedNetworkImage(
                                  imageUrl: apiProvider.userInfoModel.content.profilePic,
                                  placeholder: (context, url) => Image.asset('assets/placeholder.png',
                                      height: size.width * .45,
                                      width: size.width * .45,
                                      fit: BoxFit.cover),
                                  errorWidget: (context, url, error) => Image.asset('assets/placeholder.png',
                                      height: size.width * .45,
                                      width: size.width * .45,
                                      fit: BoxFit.cover),
                                  height: size.width * .45,
                                  width: size.width * .45,
                                  fit: BoxFit.cover,
                                ))
                                : ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: Image.asset('assets/user.PNG',
                                      height: size.width * .45,
                                      width: size.width * .45,
                                      fit: BoxFit.cover),
                                )
                          ),

                        ///User Information
                        apiProvider.userInfoModel!=null? Container(
                          width: size.width*.45,
                          child:RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              //text: 'Hello',
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
                                apiProvider.userInfoModel.content.country.isNotEmpty?TextSpan(text: 'From: ',style: TextStyle(fontWeight: FontWeight.w500)):TextSpan(),
                                apiProvider.userInfoModel.content.country.isNotEmpty? TextSpan(text: '${apiProvider.userInfoModel.content.country}\n'):TextSpan(),
                              ],
                            ),
                          ),
                        ):TextButton(
                            onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage())),
                            child: Text('Login',style: TextStyle(color: themeProvider.orangeWhiteToggleColor())))
                      ],
                    ),
                    SizedBox(height: size.width*.02),

                    ///Update Buttons
                    apiProvider.userInfoModel!=null? Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       _buttonBuilder(themeProvider,apiProvider, size, Icons.camera_alt),
                       SizedBox(width: size.width*.03),
                       _buttonBuilder(themeProvider,apiProvider, size, Icons.edit),
                       SizedBox(width: size.width*.03),
                       _buttonBuilder(themeProvider,apiProvider, size, Icons.vpn_key_sharp),
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
                    pref.getString('username')!=null? _functionBuilder(apiProvider, themeProvider,databaseHelper, size, 'WishLists', FontAwesomeIcons.solidHeart):Container(),
                    Divider(color: Colors.grey,height: 0.5),
                    pref.getString('username')!=null? _functionBuilder(apiProvider,themeProvider,databaseHelper, size, 'Order History', FontAwesomeIcons.shoppingBasket):Container(),
                    Divider(color: Colors.grey,height: 0.5),
                    pref.getString('username')!=null? _functionBuilder(apiProvider,themeProvider,databaseHelper, size, 'Notifications', FontAwesomeIcons.solidBell):Container(),
                    pref.getString('username')!=null?Divider(color: Colors.grey,height: 0.5):Container(),
                    _functionBuilder(apiProvider,themeProvider,databaseHelper, size, 'Settings', FontAwesomeIcons.cog),
                    Divider(color: Colors.grey,height: 0.5),
                    _functionBuilder(apiProvider, themeProvider, databaseHelper, size, 'Change Currency', FontAwesomeIcons.dollarSign),
                    Divider(color: Colors.grey,height: 0.5),
                    pref.getString('username')!=null
                        ? _functionBuilder(apiProvider,themeProvider,databaseHelper, size, 'Logout', FontAwesomeIcons.signOutAlt)
                        :_functionBuilder(apiProvider,themeProvider,databaseHelper, size, 'Account Create', FontAwesomeIcons.signInAlt),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Future<void> _getImageFromGallery(ThemeProvider themeProvider,APIProvider apiProvider)async{
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      setState(() {
        showLoadingDialog('Updating please wait');
        _image = File(pickedFile.path);
      });
     await apiProvider.requestWithFile(files: _image, fileKey: 'ppic').then((value)async{
       if(value){
         await apiProvider.getUserInfo(pref.getString('username'));
         closeLoadingDialog();
         showSuccessMgs('Success');
       }else{
         closeLoadingDialog();
         showErrorMgs('Failed!\nTry Again');
       }
      });
    }
    else showSnackBar(context,'No image selected!',themeProvider);
  }

  Widget _buttonBuilder(ThemeProvider themeProvider,APIProvider apiProvider, Size size, IconData iconData)=>Container(
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
      onPressed: ()async{
        if(iconData==Icons.camera_alt){
          _getImageFromGallery(themeProvider,apiProvider);
          // await themeProvider.checkConnectivity().then((value){
          //   if(themeProvider.internetConnected==true) _getImageFromGallery(themeProvider,apiProvider);
          //   else showErrorMgs('No internet connection!');
          // },onError: (error)=>showErrorMgs(error.toString()));
        }
        else if(iconData==Icons.vpn_key_sharp) Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChangePassword()));
        else if(iconData==Icons.edit) Navigator.push(context,
            MaterialPageRoute(builder: (context) => UpdateProfile()));
      },
    ),
  );

  Widget _functionBuilder(APIProvider apiProvider, ThemeProvider themeProvider, DatabaseHelper databaseHelper, Size size, String name, IconData iconData) => ListTile(
        onTap: ()async{
          if(name=='Settings') Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChangeThemePage()));
          else if(name=='Change Currency') _selectCurrency(themeProvider,size);
          else if(name=='WishLists') Navigator.push(context,
              MaterialPageRoute(builder: (context) => WishListPage()));
          else if(name=='Order History') Navigator.push(context,
              MaterialPageRoute(builder: (context) => OrderHistory()));
          else if(name=='Notifications') Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationList()));
          else if(name=='Account Create') Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));

          else if(name=='Logout') {
            showLoadingDialog('Logging Out...');
            // databaseHelper.cartList.forEach((element) async{
            //   await databaseHelper.deleteCart(element.pId);
            //   });
              pref.clear();
              await GoogleSignIn().signOut();
              apiProvider.userInfoModel=null;
              apiProvider.clearWishlist();
              apiProvider.clearNotificationList();
              closeLoadingDialog();

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

  void _selectCurrency(ThemeProvider themeProvider,Size size){
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Currency',style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.05),),
          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
          backgroundColor: themeProvider.whiteBlackToggleColor(),
          children: [
            SimpleDialogOption(onPressed: (){
              themeProvider.currencyTo='BDT';
              themeProvider.currency='TK.';
              Navigator.pop(context);
            },child: Text('BDT',
                style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.04)),),
            SimpleDialogOption(onPressed: (){
              themeProvider.currencyTo='USD';
              themeProvider.currency ="\u0024 ";
              Navigator.pop(context);
            },child: Text('USD',
                style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.04)),),
          ],
        );
      },
      animationType: DialogTransitionType.slideFromBottom,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
    );
  }

  Widget _floatingActionButton(Size size, ThemeProvider themeProvider,APIProvider apiProvider) =>
      FabCircularMenu(
        key: fabKey,
        // Cannot be `Alignment.center`
        alignment: Alignment.bottomRight,
        ringColor: themeProvider.toggleFabRingBgColor(),
        ringDiameter: 400.0,
        ringWidth: 80.0,
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
        onDisplayChange: (isOpen) {},
        children: <Widget>[
          Container(),
          RawMaterialButton(
            onPressed: () {
              _launchSocialApp('sms:${apiProvider.basicContactInfo.content.mobile2}');
              fabKey.currentState.close();
            },
            shape: CircleBorder(),
            padding: EdgeInsets.all(20.0),
            child: Icon(FontAwesomeIcons.comment,
                color: Colors.white, size: size.width * .075),
          ),
          RawMaterialButton(
            onPressed: () {
              _launchSocialApp('mailto:${apiProvider.basicContactInfo.content.email}'
                  '?subject=Mail%20To%20Baghmama&body=Type%20your%20message%20here');
              fabKey.currentState.close();
            },
            shape: CircleBorder(),
            padding: EdgeInsets.all(20.0),
            child: Icon(FontAwesomeIcons.envelope,
                color: Colors.white, size: size.width * .08),
          ),
          RawMaterialButton(
            onPressed: () {
              _launchSocialApp('whatsapp://send?phone=${apiProvider.basicContactInfo.content.mobile2}'
                 '&text=Type%20your%20message%20here');
              fabKey.currentState.close();
            },
            shape: CircleBorder(),
            padding: EdgeInsets.all(20.0),
            child: Icon(FontAwesomeIcons.whatsapp,
                color: Colors.white, size: size.width * .085),
          ),
          RawMaterialButton(
            onPressed: () {
              _launchSocialApp('tel:${apiProvider.basicContactInfo.content.mobile2}');
              fabKey.currentState.close();
            },
            shape: CircleBorder(),
            padding: EdgeInsets.all(20.0),
            child: Icon(Icons.local_phone_outlined,
                color: Colors.white, size: size.width * .08),
          ),
        ],
      );

  Future<void> _launchSocialApp(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showInfo('Failed !\nTry Again');
    }
  }
}
