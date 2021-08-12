import 'package:bagh_mama/pages/no_internet_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _isLoading=false;
  TextEditingController _email = TextEditingController();
  TextEditingController _token= TextEditingController();
  TextEditingController _verificationCode= TextEditingController();
  TextEditingController _password= TextEditingController();
  TextEditingController _confirmPassword= TextEditingController();


  int _counter=0;
  _customInit(ThemeProvider themeProvider)async{
    setState(()=>_counter++);
    //themeProvider.checkConnectivity();
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    if(_counter==0) _customInit(themeProvider);

    return Scaffold(
      backgroundColor: themeProvider.togglePageBgColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Reset Password',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: themeProvider.internetConnected? _bodyUI(themeProvider,apiProvider, size):NoInternet(),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider,APIProvider apiProvider, Size size)=>Center(
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
          _textFieldBuilder(themeProvider, size, 'Email Address'),
          SizedBox(height: size.width*.03),
          _token.text.isNotEmpty? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _textFieldBuilder(themeProvider, size, 'Token'),
              SizedBox(height: size.width*.03),
              _textFieldBuilder(themeProvider, size, 'Verification Code'),
              SizedBox(height: size.width*.03),
              _textFieldBuilder(themeProvider, size, 'New Password'),
              SizedBox(height: size.width*.03),
              _textFieldBuilder(themeProvider, size, 'Confirm New Password'),
              SizedBox(height: size.width*.03),
            ],
          ):Container(),

          _isLoading?threeBounce(themeProvider): ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
              ),
              onPressed: ()async{
                _formValidation(apiProvider);
                // await themeProvider.checkConnectivity().then((value){
                //   if(themeProvider.internetConnected==true){
                //     _formValidation(apiProvider);
                //   } else showErrorMgs('No internet connection!');
                // },onError: (error)=>showErrorMgs(error.toString()));
              },
              child: Text(_token.text.isEmpty? 'Send Code': 'Reset Password',style: TextStyle(fontSize: size.width*.04),)
          ),
        ],
      ),
    ),
  );

  void _formValidation(APIProvider apiProvider)async{
    ///Send Code
    if(_token.text.isEmpty){
      if(_email.text.isNotEmpty){
        setState(()=>_isLoading=true);
        Map map= {"username":"${_email.text}"};
        await apiProvider.sendVerificationCode(map).then((token){
          if(token.isNotEmpty){
            setState(() {
              _token.text=token;
              _isLoading=false;
            });
          }else showErrorMgs('Failed !');
        });
      }else showInfo('Enter Email Address');
    }
    ///Reset Password
    else{
      if(_verificationCode.text.isNotEmpty &&
          _password.text.isNotEmpty && _confirmPassword.text.isNotEmpty){
        if(_password.text==_confirmPassword.text){
          setState(()=>_isLoading=true);
          Map map = {
            "username": "${_email.text}",
            "code": "${_verificationCode.text}",
            "session_token": "${_token.text}",
            "password": "${_password.text}",
            "confirm": "${_confirmPassword.text}"
          };
          await apiProvider.resetPassword(map).then((value){
            if(value){
              setState(()=> _isLoading=false);
              Navigator.pop(context);
            }else {
              setState(()=> _isLoading=false);
              showErrorMgs('Password Reset Failed !');
            }
          });
        }else showInfo('Password Not Matched');
      }else showInfo('Complete All Field');
    }
  }

  Widget _textFieldBuilder(ThemeProvider themeProvider, Size size, String hint)=> TextFormField(
    controller:hint=='Email Address'
        ? _email
        :hint=='Token'?_token
        :hint=='Verification Code'? _verificationCode
        :hint=='New Password'? _password
        :_confirmPassword,
    readOnly: hint=='Token'
        ?true
        :hint=='Email Address' && _token.text.isNotEmpty
        ?true
        :false,
    keyboardType: hint=='Your Email Address'? TextInputType.emailAddress: TextInputType.text,
    style: TextStyle(
        color: themeProvider.toggleTextColor(),
        fontSize: size.width*.04
    ),
    decoration: boxFormDecoration(size).copyWith(
      labelText: hint,
      contentPadding: EdgeInsets.symmetric(vertical: size.width*.038,horizontal: size.width*.038), //Change this value to custom as you like
      isDense: true,
    ),
  );
}
