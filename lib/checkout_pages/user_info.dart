import 'package:bagh_mama/checkout_pages/review_order.dart';
import 'package:bagh_mama/models/shipping_methods_model.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/cupertino.dart';
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
  ShippingMethodsModel _shippingMethod;
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
      body:_bodyUI(themeProvider,apiProvider, size),
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

              ///Shipping dropdown
              _isLoading
                  ?Center(child: threeBounce(themeProvider))
                  :Container(
                padding: EdgeInsets.symmetric(vertical: size.width*.03,horizontal: size.width*.03),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ShippingMethodsModel>(
                    value: _shippingMethod,
                    isExpanded: true,
                    itemHeight: size.width*.22,
                    hint: Text("Select Delivery Option",style: TextStyle(
                        color: Colors.grey,
                        fontSize: size.width*.04)),
                    onChanged: (value)=>
                        setState(() => _shippingMethod = value),
                    dropdownColor: themeProvider.whiteBlackToggleColor(),
                    items: apiProvider.shippingMethodsList
                    .map<DropdownMenuItem<ShippingMethodsModel>>((ShippingMethodsModel model){
                      return DropdownMenuItem<ShippingMethodsModel>(
                        value: model,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width*.15,
                              height: size.height*.08,
                              decoration: BoxDecoration(
                                  //color: Colors.red,
                                image: DecorationImage(
                                  image: NetworkImage('https://baghmama.com.bd/${model.methodLogo}'),
                                  fit: BoxFit.cover
                                )
                              ),
                            ),
                            SizedBox(width: size.width*.01),
                            Expanded(
                              child: Container(
                                // height: size.height*.08,
                                //color: Colors.green,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${model.methodName}',
                                        style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.036)),
                                    Text('Cost: ${model.cost}',
                                        style: TextStyle(color: Colors.grey,fontSize: size.width*.032)),
                                    Text('Time: ${model.estimateTime}',
                                        style: TextStyle(color: Colors.grey,fontSize: size.width*.032))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: size.width * .04),

              Text('*Delivery Cost Will Include',style: TextStyle(color: themeProvider.toggleTextColor(),
              fontSize: size.width*.037),),
              SizedBox(height: size.width * .07),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
                  ),
                  onPressed: (){
                    if(_name.text.isNotEmpty && _email.text.isNotEmpty && _mobile.text.isNotEmpty
                    && _shippingAddress.text.isNotEmpty){
                      if(_shippingMethod!=null){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ReviewOrder(
                          itemTotal: widget.itemTotal,
                          itemSavings: widget.itemSavings,
                          couponDiscount: widget.couponDiscount,
                          totalAmount: widget.totalAmount,
                          shippingMethod: _shippingMethod,
                          name: _name.text,
                          email: _email.text,
                          mobile: _mobile.text,
                          address: _shippingAddress.text,
                        )));
                      }else showInfo('Select Delivery Option');
                    }else showInfo('Complete Your Information');

                  },
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
