import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HowToOrder extends StatelessWidget {
  const HowToOrder({Key key}) : super(key: key);

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
          'How To Order',
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
          Text('payment-methods',style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.07,fontWeight: FontWeight.w500,),),
          SizedBox(height: size.width*.05),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              //text: 'Hello ',
              style: TextStyle(fontSize: size.width*.038,color: themeProvider.toggleTextColor()),
              children: <TextSpan>[
                TextSpan(text: 'Available Payment Methods\n\n',style: TextStyle(fontSize: size.width*.044,fontWeight: FontWeight.w500),),
                TextSpan(text: '1. bKash\n'),
                TextSpan(text: '2. Rocket\n'),
                TextSpan(text: '3. Visa/Master Card\n'),
                TextSpan(text: '4. Direct Bank Transfer\n'),
                TextSpan(text: '5. Cash on delivery system\n'),

              ],
            ),
          ),
        ],
      ),
    ),
  );
}
