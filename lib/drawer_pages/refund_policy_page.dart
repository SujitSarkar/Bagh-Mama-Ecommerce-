import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class RefundPolicyPage extends StatefulWidget {

  @override
  _RefundPolicyPageState createState() => _RefundPolicyPageState();
}

class _RefundPolicyPageState extends State<RefundPolicyPage> {
  int _counter=0;
  bool _isLoading=true;
  String pageContent='';

  _customInit(ThemeProvider themeProvider,APIProvider apiProvider)async{
    setState(()=>_counter++);
    Map map = {"page_name":"shipping-returns"};
    await apiProvider.getPageContent(map).then((value){
      setState(() {
        pageContent = value;
        _isLoading=false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    if(_counter==0) _customInit(themeProvider,apiProvider);

    return Scaffold(
      backgroundColor: themeProvider.whiteBlackToggleColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Shipping Policy',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body:_isLoading
          ?Center(child: threeBounce(themeProvider))
          : _bodyUI(themeProvider,apiProvider, size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider,APIProvider apiProvider, Size size)=>
      SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width*.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: size.width*.03),
              Html(
                data: """$pageContent""",
                style:{
                  'strong':Style(
                      color: themeProvider.toggleTextColor()
                  ),
                  'body':Style(
                      color: themeProvider.toggleTextColor()
                  ),
                  'span':Style(
                      color: themeProvider.toggleTextColor()
                  ),
                  'p':Style(
                      color: themeProvider.toggleTextColor()
                  ),
                  'li':Style(
                      color: themeProvider.toggleTextColor()
                  ),
                  'ul':Style(
                      color: themeProvider.toggleTextColor()
                  ),
                  'table':Style(
                      color: themeProvider.toggleTextColor()
                  ),
                  'tbody':Style(
                      color: themeProvider.toggleTextColor()
                  ),
                  'tr':Style(
                      color: themeProvider.toggleTextColor()
                  ),
                  'td':Style(
                      color: themeProvider.toggleTextColor()
                  ),
                  'th':Style(
                      color: themeProvider.toggleTextColor()
                  ),
                },
              ),
            ],
          ),
        ),
      );
}
