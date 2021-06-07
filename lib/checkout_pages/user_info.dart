import 'package:bagh_mama/checkout_pages/review_order.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/variables/public_data.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class UserInfoPage extends StatefulWidget {
  String itemTotal;
  String itemSavings;
  String couponDiscount;
  String totalAmount;
  UserInfoPage({this.itemTotal, this.itemSavings, this.couponDiscount,this.totalAmount});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  bool _isLoading=true;
  String _shippingMethod;
  String _shippingId;
  int _counter=0;
  SharedPreferences pref;
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _shippingAddress = TextEditingController();

  void _customInit(APIProvider apiProvider)async{
    setState(()=>_counter++);
    Map map ={"location":"1"};
    await apiProvider.getShippingMethods(map).then((value){
      setState(()=>_isLoading=false);
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  void _initializeData()async{
    pref = await SharedPreferences.getInstance();
    _name.text = pref.getString('name');
    _email.text = pref.getString('username');
    _mobile.text = pref.getString('mobile');
    _shippingAddress.text = pref.getString('fullAddress');
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    if(_counter==0) _customInit(apiProvider);

    return Scaffold(
      backgroundColor: themeProvider.whiteBlackToggleColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Your Information',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _isLoading
          ?Center(child: threeBounce(themeProvider))
          :_bodyUI(themeProvider,apiProvider, size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider,APIProvider apiProvider, Size size)=>SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width*.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.width * .02),
              Text('You are logged in with ${_name.text}',style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.05,fontWeight: FontWeight.w500,),),
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
                    value: _shippingMethod,
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
                    onChanged: (newValue)=> setState(() => _shippingMethod = newValue),
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
        controller: hint=='Full name'?_name
            :hint=='Email address'?_email
            :hint=='Mobile number'?_mobile
            :_shippingAddress,
        maxLines: hint=='Shipping Address'?3:1,
        style: TextStyle(
            color: themeProvider.toggleTextColor(), fontSize: size.width * .04),
        decoration: boxFormDecoration(size).copyWith(
          labelText: hint,
          alignLabelWithHint:hint=='Shipping Address'? true:false,
          contentPadding: EdgeInsets.symmetric(vertical: size.width*.038,horizontal: size.width*.038), //Change this value to custom as you like
          isDense: true,
        ),
      );
}
