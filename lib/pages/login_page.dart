import 'package:bagh_mama/pages/create_account.dart';
import 'package:bagh_mama/pages/forgot_password_page.dart';
import 'package:bagh_mama/pages/no_internet_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading=false;
  bool _isObscure=true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  int _counter=0;
  _customInit(ThemeProvider themeProvider)async{
    setState(()=>_counter++);
    themeProvider.checkConnectivity();
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
        centerTitle: true,
        title: Text(
          'Login',
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
          _textFieldBuilder(themeProvider, size, 'Your Email Address'),
          SizedBox(height: size.width*.03),
          _textFieldBuilder(themeProvider, size, 'Password'),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateAccount()));
                },
                child: Text('Create new account',style: TextStyle(
                    color: themeProvider.orangeWhiteToggleColor(),
                    fontSize: size.width*.035
                ),),
              ),

              TextButton(
                  onPressed: () async{
                    await themeProvider.checkConnectivity().then((value){
                      if(themeProvider.internetConnected==true){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordPage()));
                      }
                      else showErrorMgs('No internet connection!');
                    },onError: (error)=>showErrorMgs(error.toString()));

                    },
                  child: Text('Forgot password?',style: TextStyle(
                      color: themeProvider.orangeWhiteToggleColor(),
                      fontSize: size.width*.035
                  ),),
              ),
            ],
          ),
          SizedBox(height: size.width*.03),

          _isLoading?threeBounce(themeProvider): ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
              ),
              onPressed: ()async{
                await themeProvider.checkConnectivity().then((value){
                  if(themeProvider.internetConnected==true) _validateForm(apiProvider);
                  else showErrorMgs('No internet connection!');
                },onError: (error)=>showErrorMgs(error.toString()));
              },
              child: Text('Log In',style: TextStyle(fontSize: size.width*.04),)
          ),
        ],
      ),
    ),
  );

  void _validateForm(APIProvider apiProvider){
    if(_emailController.text.isNotEmpty){
      if(_passwordController.text.isNotEmpty){
        if(_emailController.text.contains('@')){
          if(_emailController.text.contains('.com')){
            setState(()=> _isLoading=true);
            apiProvider.validateUser(_emailController.text, _passwordController.text).then((isValidate){
              if(isValidate){
                apiProvider.getUserInfo(_emailController.text).then((value){
                  if(value){
                    showSuccessMgs('Success');
                    setState(()=> _isLoading=false);
                    Navigator.pop(context);
                  }else{
                    setState(()=> _isLoading=false);
                    showErrorMgs('Unable to get user, try again later');
                  }
                });
                setState(()=> _isLoading=false);
              }
              else{
                setState(()=> _isLoading=false);
                showErrorMgs('Wrong email address or password');
              }
            });
          }else showInfo('Invalid email address, \'.com\' is missing');
        }else showInfo('Invalid email address, \'@\' is missing');
      }else showInfo('Enter password');
    }else showInfo('Enter email address');
  }

  Widget _textFieldBuilder(ThemeProvider themeProvider, Size size, String hint)=> TextFormField(
    controller: hint=='Your Email Address'? _emailController:_passwordController,
    keyboardType: hint=='Your Email Address'? TextInputType.emailAddress: TextInputType.text,
    style: TextStyle(
        color: themeProvider.toggleTextColor(),
        fontSize: size.width*.04
    ),
    obscureText: hint=='Your Email Address'?false:_isObscure,
    decoration: boxFormDecoration(size).copyWith(
      suffixIcon: hint=='Your Email Address'?null
          : IconButton(icon: Icon(_isObscure? CupertinoIcons.eye_slash: CupertinoIcons.eye,color: Colors.grey,),
          onPressed: ()=> setState(()=> _isObscure=!_isObscure)),
      labelText: hint,
      contentPadding: EdgeInsets.symmetric(vertical: size.width*.038,horizontal: size.width*.038), //Change this value to custom as you like
      isDense: true,
    ),
  );


}
