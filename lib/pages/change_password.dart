import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
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
        title: Text(
          'Change Password',
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
      height: size.width*.8,
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
          _textFieldBuilder(themeProvider, size, 'New Password'),
          SizedBox(height: size.width*.03),
          _textFieldBuilder(themeProvider, size, 'Confirm New Password'),
          SizedBox(height: size.width*.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
                  ),
                  onPressed: (){},
                  child: Text('Update',style: TextStyle(fontSize: size.width*.04),)
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[600])
                  ),
                  onPressed: ()=>Navigator.pop(context),
                  child: Text('Cancel',style: TextStyle(fontSize: size.width*.04),)
              ),
            ],
          )
        ],
      ),
    ),
  );

  Widget _textFieldBuilder(ThemeProvider themeProvider, Size size, String hint)=> TextFormField(
    style: TextStyle(
      color: themeProvider.toggleTextColor(),
      fontSize: size.width*.04
    ),
    decoration: InputDecoration(
      labelText: hint,
      labelStyle: TextStyle(
        color: Colors.grey,
          fontSize: size.width*.04
      ),
      border: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey
          )
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey
          )
      ),
      disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey
          )
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey
          )
      ),
    ),
  );
}
