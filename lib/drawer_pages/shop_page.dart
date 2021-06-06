import 'package:bagh_mama/pages/no_internet_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _counter=0;
  _customInit(ThemeProvider themeProvider,APIProvider apiProvider)async{
    setState(()=>_counter++);
    themeProvider.checkConnectivity();
    if(apiProvider.basicContactInfo==null) await apiProvider.getBasicContactInfo();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    if(themeProvider.internetConnected && _counter==0) _customInit(themeProvider,apiProvider);

    return Scaffold(
      backgroundColor: themeProvider.whiteBlackToggleColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Shop',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: themeProvider.internetConnected? _bodyUI(themeProvider,apiProvider, size):NoInternet(),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider,APIProvider apiProvider, Size size)=>SingleChildScrollView(
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: size.width*.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: size.width*.03),
          Text('Store Location',style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.07,fontWeight: FontWeight.w500,),),
          SizedBox(height: size.width*.05),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              //text: 'Hello ',
              style: TextStyle(fontSize: size.width*.038,color: themeProvider.toggleTextColor()),
              children: <TextSpan>[
                TextSpan(text: 'Dhaka Commerce is an award-winning creative design agency.\n\n'),
                TextSpan(text: 'You’ll find the About Page at the top of the menu under the Who section.\n\n'),
                TextSpan(text: 'This the page has a unique feel, thanks to the'
                    ' deconstructed action figures representing the founders, Leigh Whipday and Jonny Lander.\n\n'),
                TextSpan(text: 'The great attention to detail and interactivity also reflect the company’s 16 years of experience.\n\n\n'),
              ],
            ),
          ),
          Html(
              data: """${apiProvider.basicContactInfo.content.address}""",
              style:{
                'strong':Style(
                  color: themeProvider.toggleTextColor()
                ),
                'body':Style(
                  color: themeProvider.toggleTextColor()
                ),
              },
          ),
          Html(
              data: """${apiProvider.basicContactInfo.content.address2}""",
            style:{
              'strong':Style(
                  color: themeProvider.toggleTextColor()
              ),
              'body':Style(
                  color: themeProvider.toggleTextColor()
              ),
            },
          ),
          Padding(
            padding:  EdgeInsets.only(left: 10,top: 10),
            child: Text('Contact Us :',style: TextStyle(color: themeProvider.toggleTextColor(),
                fontSize: size.width*.04,fontWeight: FontWeight.bold),),
          ),
          Html(
            data: """${apiProvider.basicContactInfo.content.mobile1}""",
            style:{
              'strong':Style(
                  color: themeProvider.toggleTextColor()
              ),
              'body':Style(
                  color: themeProvider.toggleTextColor()
              ),
            },
          ),
          Html(
            data: """${apiProvider.basicContactInfo.content.mobile2}""",
            style:{
              'strong':Style(
                  color: themeProvider.toggleTextColor()
              ),
              'body':Style(
                  color: themeProvider.toggleTextColor()
              ),
            },
          ),
          Html(
            data: """${apiProvider.basicContactInfo.content.phone}""",
            style:{
              'strong':Style(
                  color: themeProvider.toggleTextColor()
              ),
              'body':Style(
                  color: themeProvider.toggleTextColor()
              ),
            },
          ),
          Html(
            data: """${apiProvider.basicContactInfo.content.email}""",
            style:{
              'strong':Style(
                  color: themeProvider.toggleTextColor()
              ),
              'body':Style(
                  color: themeProvider.toggleTextColor()
              ),
            },
          ),
        ],
      ),
    ),
  );
}
