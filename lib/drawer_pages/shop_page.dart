import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

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
      body: _bodyUI(themeProvider, size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider, Size size)=>SingleChildScrollView(
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
                TextSpan(text: 'Our shop Locations:House: \n',style: TextStyle(fontWeight: FontWeight.w500)),
                TextSpan(text: '12, Road: 15 ,Sector 14, Uttara, Dhaka - 1230. Bangladesh.',style: TextStyle(fontWeight: FontWeight.w500)),

              ],
            ),
          ),
        ],
      ),
    ),
  );
}
