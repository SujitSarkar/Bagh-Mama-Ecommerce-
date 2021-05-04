import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.togglePageBgColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        centerTitle: true,
        title: Text(
          'Login',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(themeProvider, size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider, Size size)=>Center(
    child: Container(
      height: size.width,
      margin: EdgeInsets.symmetric(horizontal: size.width*.06),
      padding: EdgeInsets.symmetric(horizontal: size.width*.03),
      decoration: BoxDecoration(
        color: themeProvider.toggleCartColor(),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _textFieldBuilder(themeProvider, size, 'Your Email Address'),
          SizedBox(height: size.width*.03),
          _textFieldBuilder(themeProvider, size, 'Password'),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: (){},
                child: Text('Create new account',style: TextStyle(
                    color: themeProvider.orangeWhiteToggleColor(),
                    fontSize: size.width*.035
                ),),
              ),

              TextButton(
                  onPressed: (){},
                  child: Text('Forgot password?',style: TextStyle(
                      color: themeProvider.orangeWhiteToggleColor(),
                      fontSize: size.width*.035
                  ),),
              ),
            ],
          ),
          SizedBox(height: size.width*.03),

          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
              ),
              onPressed: (){},
              child: Text('Log In',style: TextStyle(fontSize: size.width*.04),)
          ),
        ],
      ),
    ),
  );

  Widget _textFieldBuilder(ThemeProvider themeProvider, Size size, String hint)=> TextFormField(
    style: TextStyle(
        color: themeProvider.toggleTextColor(),
        fontSize: size.width*.04
    ),
    decoration: boxFormDecoration.copyWith(
      labelText: hint,
      labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: size.width*.04
      ),
      contentPadding: EdgeInsets.symmetric(vertical: size.width*.038,horizontal: size.width*.038), //Change this value to custom as you like
      isDense: true,
    ),
  );
}
