import 'package:bagh_mama/pages/no_internet_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {

  TextEditingController firstName= TextEditingController();
  TextEditingController lastName= TextEditingController();
  TextEditingController email= TextEditingController();
  TextEditingController phone= TextEditingController();
  TextEditingController address= TextEditingController();
  TextEditingController state= TextEditingController();
  TextEditingController country= TextEditingController();
  TextEditingController city= TextEditingController();
  TextEditingController postalCode= TextEditingController();
  int _counter=0;
  bool _isLoading=false;
  SharedPreferences pref;

  void _customInit(APIProvider apiProvider,ThemeProvider themeProvider)async{
    setState(()=>_counter++);
    themeProvider.checkConnectivity();
    pref = await SharedPreferences.getInstance();
    if(pref.getString('username')!=null){
      if(apiProvider.userInfoModel==null){
        await apiProvider.getUserInfo(pref.getString('username'));
      }
    }
    firstName.text = apiProvider.userInfoModel.content.firstName;
    lastName.text = apiProvider.userInfoModel.content.lastName;
    email.text = apiProvider.userInfoModel.content.email;
    phone.text = apiProvider.userInfoModel.content.mobileNumber;
    address.text = apiProvider.userInfoModel.content.address;
    state.text = apiProvider.userInfoModel.content.state;
    country.text = apiProvider.userInfoModel.content.country;
    city.text = apiProvider.userInfoModel.content.city;
    postalCode.text = apiProvider.userInfoModel.content.postalcode;
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
          'Update Profile',
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
                            if(themeProvider.internetConnected==true) _updateUserInfo(apiProvider);
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
                ),
                SizedBox(height: size.width * .03),
              ]),
        ),
  );

  void _updateUserInfo(APIProvider apiProvider)async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(()=> _isLoading=true);
    print(pref.getString('userId'));
    Map data={
      "id": int.parse(pref.getString('userId')),
      "first_name": "${firstName.text}",
      "last_name": "${lastName.text}",
      "email": "${email.text}",
      "address": "${address.text}",
      "city": "${city.text}",
      "state": "${state.text}",
      "postalcode": "${postalCode.text}",
      "mobile_number": "${phone.text}",
      "country": "${country.text}"
    };
    apiProvider.updateUserInfo(data).then((value){
          if(value==true){
            apiProvider.getUserInfo(pref.getString('username')).then((value){
              setState(()=> _isLoading=false);
              showSuccessMgs('Successfully updated');
              Navigator.pop(context);
            });
          }else{
            setState(()=> _isLoading=false);
            showErrorMgs('Unable to update, try again later');
          }
    });
  }

  Widget _textFieldBuilder(
          ThemeProvider themeProvider, Size size, String hint) =>
      TextFormField(
        controller: hint=='First Name' ?firstName
            :hint=='Last Name'?lastName
            :hint=='Email'?email
            :hint=='Mobile Number'?phone
            :hint=='Address'?address
            :hint=='Division/State'?state
            :hint=='District/City'?city
            :hint=='Country'?country
            :postalCode,
        style: TextStyle(
            color: themeProvider.toggleTextColor(), fontSize: size.width * .04),
        decoration: boxFormDecoration(size).copyWith(
          labelText: hint,
          contentPadding: EdgeInsets.symmetric(vertical: size.width*.038,horizontal: size.width*.038), //Change this value to custom as you like
          isDense: true,
        ),
      );
}
