import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'no_internet_page.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  int _counter=0;
  bool _isLoading = false;

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
        title: Text(
          'Change Password',
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
          _isLoading
              ?threeBounce(themeProvider)
              :Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
                  ),
                  onPressed: ()async{
                    await themeProvider.checkConnectivity().then((value){
                      if(themeProvider.internetConnected==true){
                        _formValidation(apiProvider);
                      }
                      else showErrorMgs('No internet connection!');
                    },onError: (error)=>showErrorMgs(error.toString()));
                  },
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

  void _formValidation(APIProvider apiProvider)async{
    if(_password.text.isNotEmpty && _confirmPassword.text.isNotEmpty){
      if(_password.text==_confirmPassword.text){
        setState(()=> _isLoading=true);
        SharedPreferences pref = await SharedPreferences.getInstance();
        Map map = {
          "id": "${pref.getString('userId')}",
          "password": "${_password.text}",
          "confirm": "${_confirmPassword.text}"
        };
        await apiProvider.updatePassword(map).then((value){
          if(value){
            showSuccessMgs('Success');
            Navigator.pop(context);
          }else {
            setState(()=> _isLoading=false);
            showErrorMgs('Password Update Failed !');
          }
        });
      }else showInfo('Password Not Matched');
    }else showInfo('Complete All Field');
  }

  Widget _textFieldBuilder(ThemeProvider themeProvider, Size size, String hint)=> TextFormField(
    controller: hint=='New Password'
        ?_password
        :_confirmPassword,
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
