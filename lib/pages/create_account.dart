import 'package:bagh_mama/pages/no_internet_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccount extends StatefulWidget {

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool _isObscure=true;
  TextEditingController _firstName= TextEditingController();
  TextEditingController _lastName= TextEditingController();
  TextEditingController _email= TextEditingController();
  TextEditingController _phone= TextEditingController();
  TextEditingController _address= TextEditingController();
  TextEditingController _state= TextEditingController();
  TextEditingController _city= TextEditingController();
  TextEditingController _postalCode= TextEditingController();
  TextEditingController _country= TextEditingController();
  TextEditingController _password= TextEditingController();
  TextEditingController _confirmPassword= TextEditingController();
  int _counter=0;
  bool _isLoading=false;
  void _customInit(APIProvider apiProvider,ThemeProvider themeProvider)async{
    setState(()=>_counter++);
    themeProvider.checkConnectivity();
    }

    @override
    Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    if(_counter==0) _customInit(apiProvider,themeProvider);

    return Scaffold(
      backgroundColor: themeProvider.whiteBlackToggleColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Create Account',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: themeProvider.internetConnected? _bodyUI(themeProvider,apiProvider, size):NoInternet(),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider,APIProvider apiProvider, Size size) => SingleChildScrollView(
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
            _textFieldBuilder(themeProvider, size, 'Country'),
            SizedBox(height: size.width * .04),
            _isLoading
                ? threeBounce(themeProvider)
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
                    ),
                    onPressed: ()async{
                      await themeProvider.checkConnectivity().then((value){
                        if(themeProvider.internetConnected==true) _registerUser(apiProvider);
                        else showErrorMgs('No internet connection!');
                      },onError: (error)=>showErrorMgs(error.toString()));
                    },
                    child: Text('Create an account',style: TextStyle(fontSize: size.width*.04),)
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

  void _registerUser(APIProvider apiProvider)async{
    if(_firstName.text.isNotEmpty && _lastName.text.isNotEmpty && _email.text.isNotEmpty
    && _phone.text.isNotEmpty && _password.text.isNotEmpty && _confirmPassword.text.isNotEmpty
    && _address.text.isNotEmpty && _state.text.isNotEmpty && _city.text.isNotEmpty
    && _postalCode.text.isNotEmpty){
      if(_email.text.contains('@')){
        if(_email.text.contains('.com')){
          if(_password.text==_confirmPassword.text){
            setState(()=>_isLoading=true);
            Map data = {
              "username": "${_email.text}",
              "password": "${_password.text}",
              "confirm-password": "${_confirmPassword.text}",
              "first_name": "${_firstName.text}",
              "last_name": "${_lastName.text}",
              "email": "${_email.text}",
              "address": "${_address.text}",
              "city": "${_city.text}",
              "state": "${_state.text}",
              "postalcode": "${_postalCode.text}",
              "mobile_number": "${_phone.text}",
              "country": "${_country.text.isEmpty?"" :_country.text}"
            };
            apiProvider.registerUser(data).then((registerUserModel){
              if(registerUserModel.content.success==true){
                setState(()=>_isLoading=false);
                showSuccessMgs('Registration Success');
                Navigator.pop(context);
              }else{
                setState(()=>_isLoading=false);
                showErrorMgs(registerUserModel.content.errordesc.toString());
              }
            });
          }else showInfo('Password not matched');
        }else showInfo('Invalid email address, \'.com\' is missing');
      }else showInfo('Invalid email address, \'@\' is missing');
    }else showInfo('Field can\'t be empty');
  }

  Widget _textFieldBuilder(
      ThemeProvider themeProvider, Size size, String hint) =>
      TextFormField(
        controller: hint=='First Name' ?_firstName
            :hint=='Last Name'?_lastName
            :hint=='Email'?_email
            :hint=='Mobile Number'?_phone
            :hint=='Address'?_address
            :hint=='Password'?_password
            :hint=='Confirm Password'? _confirmPassword
            :hint=='Division/State'?_state
            :hint=='District/City'?_city
            :hint=='Postal Code'?_postalCode
            :_country,
        obscureText: hint=='Password' || hint=='Confirm Password'?_isObscure:false,
        style: TextStyle(
            color: themeProvider.toggleTextColor(), fontSize: size.width * .04),
        decoration: boxFormDecoration(size).copyWith(
          labelText: hint,
          contentPadding: EdgeInsets.symmetric(vertical: size.width*.038,horizontal: size.width*.038), //Change this value to custom as you like
          isDense: true,
          suffixIcon: hint=='Password' || hint=='Confirm Password'?
               IconButton(icon: Icon(_isObscure? CupertinoIcons.eye_slash: CupertinoIcons.eye,color: Colors.grey,),
              onPressed: ()=> setState(()=> _isObscure=!_isObscure)):null,
        ),
      );
}
