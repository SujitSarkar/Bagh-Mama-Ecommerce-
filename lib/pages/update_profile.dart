import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
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
          'Update Profile',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(themeProvider, size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider, Size size) => SingleChildScrollView(
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: size.width*.03),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.width * .04),
                _textFieldBuilder(themeProvider, size, 'First Name'),
                SizedBox(height: size.width * .04),
                _textFieldBuilder(themeProvider, size, 'Last Name'),
                SizedBox(height: size.width * .04),
                _textFieldBuilder(themeProvider, size, 'Email'),
                SizedBox(height: size.width * .04),
                _textFieldBuilder(themeProvider, size, 'Mobile Number'),
                SizedBox(height: size.width * .04),
                _textFieldBuilder(themeProvider, size, 'Password'),
                SizedBox(height: size.width * .04),
                _textFieldBuilder(themeProvider, size, 'Confirm Password'),
                SizedBox(height: size.width * .04),
                _textFieldBuilder(themeProvider, size, 'Address'),
                SizedBox(height: size.width * .04),
                _textFieldBuilder(themeProvider, size, 'Division/State'),
                SizedBox(height: size.width * .04),
                _textFieldBuilder(themeProvider, size, 'District/City'),
                SizedBox(height: size.width * .04),
                _textFieldBuilder(themeProvider, size, 'Postal Code'),
                SizedBox(height: size.width * .04),
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
                ),
                SizedBox(height: size.width * .03),
              ]),
        ),
  );

  Widget _textFieldBuilder(
          ThemeProvider themeProvider, Size size, String hint) =>
      TextFormField(
        style: TextStyle(
            color: themeProvider.toggleTextColor(), fontSize: size.width * .04),
        decoration: boxFormDecoration.copyWith(
          labelText: hint,
          labelStyle:
          TextStyle(color: Colors.grey, fontSize: size.width * .04),
          contentPadding: EdgeInsets.symmetric(vertical: size.width*.038,horizontal: size.width*.038), //Change this value to custom as you like
          isDense: true,
        ),
      );
}
