import 'package:bagh_mama/models/shipping_location_model.dart';
import 'package:bagh_mama/models/shipping_methods_model.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class QuickBuyPage extends StatefulWidget {
  String productId;
  String productName;
  String productSize;
  String productColor;
  int productQuantity;
  String productPrice;


  QuickBuyPage({this.productId, this.productName, this.productSize,
      this.productColor, this.productQuantity, this.productPrice});

  @override
  _QuickBuyPageState createState() => _QuickBuyPageState();
}

class _QuickBuyPageState extends State<QuickBuyPage> {
  int productQuantity=1;
  bool _isLoading1=true;
  bool _isLoading2=false;
  String totalPrice;
  ShippingMethodsModel _shippingMethod;
  ShippingLocationModel _shippingLocation;
  int _counter=0;
  SharedPreferences pref;
  TextEditingController _name = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _shippingAddress = TextEditingController();
  String totalWithDeliveryCost='';
  int _paymentRadioValue=1;

  void _customInit(APIProvider apiProvider)async{
    setState(()=>_counter++);
    await apiProvider.getShippingLocations().then((value){
      setState(()=>_isLoading1=false);
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  void _initializeData()async{
    totalPrice=widget.productPrice;
    pref = await SharedPreferences.getInstance();
    _name.text = pref.getString('name')??'';
    _mobile.text = pref.getString('mobile')??'';
    _shippingAddress.text = pref.getString('fullAddress')??'';
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
          'Review Your Order',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(themeProvider,apiProvider, size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider,APIProvider apiProvider, Size size) =>
      SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * .03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: size.width * .03),
              _dottedContainer(
                  themeProvider,
                  size,
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      //text: 'Hello ',
                      style: TextStyle(
                          fontSize: size.width * .038,
                          color: themeProvider.toggleTextColor()),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Product Details\n',
                          style: TextStyle(
                              fontSize: size.width * .044,
                              fontWeight: FontWeight.w500),
                        ),
                        TextSpan(text: '${widget.productName}\n'),
                        widget.productSize.isNotEmpty
                            ? TextSpan(text: 'Size: ${widget.productSize}  ',style: TextStyle(
                            fontSize: size.width * .032,
                            color: Colors.grey))
                            :TextSpan(),
                        widget.productColor.isNotEmpty
                            ? TextSpan(text: 'Color: ${widget.productColor}\n',style: TextStyle(
                            fontSize: size.width * .032,
                            color: Colors.grey))
                            :TextSpan(),
                        TextSpan(text: 'Quantity: $productQuantity Unit\n'),
                        TextSpan(text: 'Unit Price: ${themeProvider.currency}${themeProvider.toggleCurrency(widget.productPrice)}\n'),
                        TextSpan(text: 'Total Price: ${themeProvider.currency}${themeProvider.toggleCurrency(totalPrice)}'),
                      ],
                    ),
                  )),

              ///Product Quantity
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: size.width*.35,
                    child: Text('Product Quantity:',
                      style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.04),),
                  ),
                  Container(
                    width: size.width*.45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ///Decrease button
                        IconButton(
                          onPressed: ()async{
                            if(productQuantity>1){
                              setState((){
                                productQuantity--;
                                totalPrice = (int.parse(widget.productPrice)*productQuantity).toString();
                              });
                            }
                          },
                          icon: Icon(Icons.remove_circle_outline,size: size.width*.06,color: Colors.grey,), splashRadius: size.width*.06,),
                        Text('$productQuantity',style: TextStyle(color: Colors.grey,fontSize: size.width*.044,fontWeight: FontWeight.bold),),
                        ///Increase button
                        IconButton(
                          onPressed: ()async{
                            closeLoadingDialog();
                            setState((){
                              productQuantity++;
                              totalPrice = (int.parse(widget.productPrice)*productQuantity).toString();
                            });
                          },
                          icon: Icon(Icons.add_circle_outline_rounded,size: size.width*.06,color: Colors.grey,),splashRadius: size.width*.06,),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.width * .04),

              ///Shipping Location
              _isLoading1
                  ?Center(child: threeBounce(themeProvider))
                  :Container(
                padding: EdgeInsets.symmetric(vertical: size.width*.01,horizontal: size.width*.03),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ShippingLocationModel>(
                    value: _shippingLocation,
                    isExpanded: true,
                    hint: Text("Select Delivery Location",style: TextStyle(
                        color: Colors.grey,
                        fontSize: size.width*.04)),
                    onChanged: (value)async{
                      setState((){
                        _shippingLocation = value;
                        _isLoading2=true;
                      });
                      Map map = {"location":"${_shippingLocation.status}"};
                      apiProvider.getShippingMethods(map).then((value){
                        setState((){
                          _isLoading2=false;
                        });
                      });
                    },
                    dropdownColor: themeProvider.whiteBlackToggleColor(),
                    items: apiProvider.shippingLocationList
                        .map<DropdownMenuItem<ShippingLocationModel>>((ShippingLocationModel model){
                      return DropdownMenuItem<ShippingLocationModel>(
                        value: model,
                        child: Text('${model.city}',
                            style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.04)),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: size.width * .04),

              ///Shipping Methods
              _isLoading2
                    ?Center(child: threeBounce(themeProvider))
                    :apiProvider.shippingMethodsList.isNotEmpty? Container(
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
              ):Container(),
              SizedBox(height: size.width * .04),

              _textFieldBuilder(themeProvider, size, 'Full Name'),
              SizedBox(height: size.width * .04),
              _textFieldBuilder(themeProvider, size, 'Mobile Number'),
              SizedBox(height: size.width * .04),
              _textFieldBuilder(themeProvider, size, 'Shipping Address'),
              SizedBox(height: size.width * .04),
              _radioTileBuilder(1, 'Card Payment', themeProvider, size),
              _radioTileBuilder(2, 'BKash', themeProvider, size),
              _radioTileBuilder(3, 'Rocket', themeProvider, size),
              SizedBox(height: size.width * .07),

              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
                  ),
                  onPressed: () {},
                  child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: Text('Continue To Payment',style: TextStyle(fontSize: size.width*.04),))
              )
            ],
          ),
        ),
      );

  Widget _textFieldBuilder(
      ThemeProvider themeProvider, Size size, String hint) =>
      TextFormField(
        controller: hint=='Full Name'?_name
            :hint=='Mobile Number'?_mobile
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

  Widget _radioTileBuilder(int radioValue, String hint,
      ThemeProvider themeProvider, Size size) =>
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        minVerticalPadding: 0.0,
        horizontalTitleGap: 0,
        dense: true,
        leading: Radio(
          fillColor:
          MaterialStateProperty.all(themeProvider.orangeWhiteToggleColor()),
          value: radioValue,
          groupValue: _paymentRadioValue,
          onChanged: (int change){
            setState(() {
              _paymentRadioValue = change;
              print('$_paymentRadioValue');
            });
          },
        ),
        title: Text(
          hint,
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .04),
        ),
      );

  Widget _dottedContainer(
      ThemeProvider themeProvider, Size size, Widget richText) =>
      Container(
        width: size.width,
        padding: EdgeInsets.symmetric(
            horizontal: size.width * .03, vertical: size.width * .03),
        decoration: DottedDecoration(
          color: Colors.grey,
          shape: Shape.box,
          strokeWidth: 1,
          dash: [2],
          borderRadius: BorderRadius.circular(5),
        ),
        child: richText,
      );
}
