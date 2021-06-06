import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  int _counter=0;
  bool _isLoading = true;
  SharedPreferences sharedPreferences;

  _customInit(APIProvider apiProvider)async{
    setState(()=> _counter++);
    sharedPreferences = await SharedPreferences.getInstance();
    if(apiProvider.notificationList.isEmpty){
      await apiProvider.getUserInfo(sharedPreferences.getString('username')).then((value){
        setState(()=> _isLoading=false);
      });
    }else setState(()=> _isLoading=false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    if(_counter==0) _customInit(apiProvider);

    return Scaffold(
      backgroundColor: themeProvider.whiteBlackToggleColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _isLoading
          ?Center(child: threeBounce(themeProvider))
          : _bodyUI(themeProvider,apiProvider, size),
    );
  }

  _bodyUI(ThemeProvider themeProvider,APIProvider apiProvider, Size size)=>ListView.builder(
    itemCount: apiProvider.notificationList.length,
    itemBuilder: (context, index)=>InkWell(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 13,horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0.5
          ), borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: Text(apiProvider.notificationList[index].notificationText,
        style: TextStyle(
          color: themeProvider.toggleTextColor(),
          fontSize: size.width*.04
        ),),
      ),
      onTap: ()async{
        await launchInWebViewWithJavaScript(context, apiProvider.notificationList[index].link);
      },
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
