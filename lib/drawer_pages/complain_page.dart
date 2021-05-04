import 'package:bagh_mama/drawer_pages/submit_complain.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComplainPage extends StatelessWidget {
  const ComplainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
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
          'Complain',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(themeProvider, size, context),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider, Size size, BuildContext context) =>
      SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * .03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.width * .03),
              _titleBuilder(themeProvider, size, 'Order & Refund Related Issues'),
              SizedBox(height: size.width * .03),
              _buttonBuilder(themeProvider, size, 'Want to cancel order ?',context),
              SizedBox(height: size.width * .01),
              _buttonBuilder(themeProvider, size, 'Percel not received ?',context),
              SizedBox(height: size.width * .01),
              _buttonBuilder(themeProvider, size, 'Product returned but not refunded ?',context),
              SizedBox(height: size.width * .01),
              _buttonBuilder(themeProvider, size, 'Want to return product ?',context),
              SizedBox(height: size.width * .01),
              _buttonBuilder(themeProvider, size, 'I haven\'t received my parcel but it shows "Delivered" ?',context),
              SizedBox(height: size.width * .01),
              _buttonBuilder(themeProvider, size, 'How can I get a refund if my credit card is no longer valid or has expired ?',context),
              SizedBox(height: size.width * .05),

              _titleBuilder(themeProvider, size, 'Account Related Issues'),
              SizedBox(height: size.width * .03),
              _buttonBuilder(themeProvider, size, 'I want to delete my account ?',context),
              SizedBox(height: size.width * .01),
              _buttonBuilder(themeProvider, size, 'I want to change my default email ?',context),
              SizedBox(height: size.width * .01),
              _buttonBuilder(themeProvider, size, 'I forgot my password, How can I reset ?',context),
              SizedBox(height: size.width * .01),
              _buttonBuilder(themeProvider, size, 'I want to unsubscribe from BaghMama newsletter ?',context),
              SizedBox(height: size.width * .05),

              _titleBuilder(themeProvider, size, 'Payment Related Issues'),
              SizedBox(height: size.width * .03),
              _buttonBuilder(themeProvider, size, 'How do I pay on BaghMama ?',context),
              SizedBox(height: size.width * .01),
              _buttonBuilder(themeProvider, size, 'Is there any Hidden Charge ?',context),
              SizedBox(height: size.width * .01),
              _buttonBuilder(themeProvider, size, 'Is return service is free ?',context),
              SizedBox(height: size.width * .01),
              _buttonBuilder(themeProvider, size, 'How safe is my payment data ?',context),
              SizedBox(height: size.width * .05),
            ],
          ),
        ),
      );

  Widget _titleBuilder(ThemeProvider themeProvider, Size size, String title) =>
      Text(title, style: TextStyle(
        color: themeProvider.toggleTextColor(),
        fontSize: size.width * .05,
        fontWeight: FontWeight.w500,),);

  Widget _buttonBuilder(ThemeProvider themeProvider, Size size,String question,BuildContext context) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * .03),
        margin: EdgeInsets.only(bottom: size.width * .02),
        child: InkWell(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SubmitComplain(question: question,))),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey,width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              padding: EdgeInsets.symmetric(horizontal: size.width * .03,vertical: size.width * .02),
              child: Text(question,
                style: TextStyle(
                    color: themeProvider.orangeWhiteToggleColor(),
                    fontSize: size.width*.035),
        ),
            ),
          borderRadius:BorderRadius.all(Radius.circular(5)),
        ),
      );
}
