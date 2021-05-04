import 'package:bagh_mama/checkout_pages/review_order.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/variables/public_data.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key key,}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {

  String _deliveryOption;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _shippingAddressController = TextEditingController();

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
          'User Information',
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.width * .02),
              Text('You are logged in with Sarkar',style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.05,fontWeight: FontWeight.w500,),),
              SizedBox(height: size.width * .04),
              _textFieldBuilder(themeProvider, size, 'Full name'),
              SizedBox(height: size.width * .04),
              _textFieldBuilder(themeProvider, size, 'Email address'),
              SizedBox(height: size.width * .04),
              _textFieldBuilder(themeProvider, size, 'Mobile number'),
              SizedBox(height: size.width * .04),
              _textFieldBuilder(themeProvider, size, 'Shipping Address'),
              SizedBox(height: size.width * .04),

              Container(
                padding: EdgeInsets.symmetric(vertical: size.width*.038,horizontal: size.width*.038),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: _deliveryOption,
                    isExpanded: true,
                    hint: Text("Select Delivery Option",style: TextStyle(
                        color: Colors.grey,
                        fontSize: size.width*.04)),
                    items: PublicData.deliveryOptionList.map((category){
                      return DropdownMenuItem(
                        child: Text(category,style: TextStyle(
                          color: themeProvider.toggleTextColor(),
                          fontSize: size.width*.04,)),
                        value: category,
                      );
                    }).toList(),
                    onChanged: (newValue)=> setState(() => _deliveryOption = newValue),
                    dropdownColor: themeProvider.whiteBlackToggleColor(),
                  ),
                ),
              ),
              SizedBox(height: size.width * .07),

              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
                  ),
                  onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ReviewOrder())),
                  child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: Text('Save & Continue',style: TextStyle(fontSize: size.width*.04),))
              )
            ],
          )
      )
  );

  Widget _textFieldBuilder(
      ThemeProvider themeProvider, Size size, String hint) =>
      TextFormField(
        controller: hint=='Full name'?_nameController
            :hint=='Email address'?_addressController
            :hint=='Mobile number'?_mobileController
            :_shippingAddressController,
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
