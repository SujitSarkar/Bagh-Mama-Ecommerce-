import 'package:bagh_mama/drawer_pages/about_us.dart';
import 'package:bagh_mama/drawer_pages/complain_page.dart';
import 'package:bagh_mama/drawer_pages/payment_method_page.dart';
import 'package:bagh_mama/drawer_pages/privacy_policy_page.dart';
import 'package:bagh_mama/drawer_pages/refund_policy_page.dart';
import 'package:bagh_mama/drawer_pages/shop_page.dart';
import 'package:bagh_mama/drawer_pages/terms_condition_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  int _counter=0;

  _customInit(APIProvider apiProvider)async{
    setState(()=>_counter++);
    if(apiProvider.socialContactInfo==null) await apiProvider.getSocialContactInfo();
    if(apiProvider.basicContactInfo==null) await apiProvider.getBasicContactInfo();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    if(_counter==0) _customInit(apiProvider);

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.width*.03),
                      Image.asset('assets/logo.png',height: size.width*.12,fit: BoxFit.cover),
                      SizedBox(height: size.width*.07),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'Shop', FontAwesomeIcons.storeAlt),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'Terms & Condition', FontAwesomeIcons.gavel),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'Payment Methods', FontAwesomeIcons.fileInvoiceDollar),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'Refund Policy', FontAwesomeIcons.undo),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'About Us', FontAwesomeIcons.infoCircle),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'Privacy Policy', FontAwesomeIcons.userSecret),
                      Divider(color: Colors.grey,height: 0.5),
                      _functionBuilder(themeProvider, size, 'Complain', FontAwesomeIcons.solidQuestionCircle),
                      Divider(color: Colors.grey,height: 0.5),
                      SizedBox(height: size.width*.04),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _socialIconBuilder(FontAwesomeIcons.facebookSquare,apiProvider, themeProvider, size),
                          _socialIconBuilder(FontAwesomeIcons.twitterSquare,apiProvider, themeProvider, size),
                          _socialIconBuilder(FontAwesomeIcons.instagramSquare,apiProvider, themeProvider, size),
                          _socialIconBuilder(FontAwesomeIcons.youtubeSquare,apiProvider, themeProvider, size),
                          _socialIconBuilder(FontAwesomeIcons.pinterestSquare,apiProvider, themeProvider, size),
                          _socialIconBuilder(FontAwesomeIcons.skype,apiProvider, themeProvider, size),
                        ],
                      )
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

  Widget _socialIconBuilder(IconData iconData, APIProvider apiProvider, ThemeProvider themeProvider,Size size)=>InkWell(
    onTap: (){
      if(iconData==FontAwesomeIcons.facebookSquare)
        launchInWebViewWithJavaScript(context, apiProvider.socialContactInfo.content.facebook,);
      else if(iconData== FontAwesomeIcons.twitterSquare)
        launchInWebViewWithJavaScript(context, apiProvider.socialContactInfo.content.twitter);
      else if(iconData== FontAwesomeIcons.instagramSquare)
        launchInWebViewWithJavaScript(context, apiProvider.socialContactInfo.content.instagram);
      else if(iconData== FontAwesomeIcons.youtubeSquare)
        launchInWebViewWithJavaScript(context, apiProvider.socialContactInfo.content.youtube);
      else if(iconData== FontAwesomeIcons.googlePlusSquare)
        launchInWebViewWithJavaScript(context, apiProvider.socialContactInfo.content.yahoo);
      else if(iconData== FontAwesomeIcons.skype)
        launchInWebViewWithJavaScript(context, apiProvider.socialContactInfo.content.skype);

    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: size.width*.017,vertical: size.width*.01),
        child: Icon(iconData,size: size.width*.075,color:themeProvider.orangeWhiteToggleColor())
    ),
  );

  Widget _functionBuilder(ThemeProvider themeProvider, Size size, String name, IconData iconData) => ListTile(
    onTap: (){
      if(name=='Shop') Navigator.push(context,
          MaterialPageRoute(builder: (context) => ShopPage()));
      else if(name=='Terms & Condition') Navigator.push(context,
          MaterialPageRoute(builder: (context) => TermsConditionPage()));
      else if(name=='Payment Methods') Navigator.push(context,
          MaterialPageRoute(builder: (context) => PaymentMethodPage()));
      else if(name=='Refund Policy') Navigator.push(context,
          MaterialPageRoute(builder: (context) => RefundPolicyPage()));
      else if(name=='About Us') Navigator.push(context,
          MaterialPageRoute(builder: (context) => AboutUsPage()));
      else if(name=='Privacy Policy') Navigator.push(context,
          MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
      else if(name=='Complain') Navigator.push(context,
          MaterialPageRoute(builder: (context) => ComplainPage()));

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

  Future<void> launchInWebViewWithJavaScript(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      showAnimatedDialog(
        barrierDismissible: true,
          context: context,
          animationType: DialogTransitionType.slideFromBottomFade,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 500),
          builder: (context){
            return AlertDialog(
              title: Text('Status',textAlign: TextAlign.center),
              content: Text('Something went wrong!\nplease try again',textAlign: TextAlign.center,),
            );
          }
      );
    }
  }
}
