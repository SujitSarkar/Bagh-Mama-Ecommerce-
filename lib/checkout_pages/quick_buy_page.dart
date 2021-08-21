import 'package:bagh_mama/models/shipping_location_model.dart';
import 'package:bagh_mama/models/shipping_methods_model.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCAdditionalInitializer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCEMITransactionInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCShipmentInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/General.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';

// ignore: must_be_immutable
class QuickBuyPage extends StatefulWidget {
  String productId;
  String productName;
  String productSize;
  String productColor;
  int productQuantity;
  String productPrice;
  bool isCampaign;

  QuickBuyPage(
      {this.productId,
      this.productName,
      this.productSize,
      this.productColor,
      this.productQuantity,
      this.productPrice,
      this.isCampaign});

  @override
  _QuickBuyPageState createState() => _QuickBuyPageState();
}

class _QuickBuyPageState extends State<QuickBuyPage> {
  int productQuantity = 1;

  //bool _isLoading1=true;
  bool _isLoading2 = true;
  String totalPrice;
  ShippingMethodsModel _shippingMethod;

  // ShippingLocationModel _shippingLocation;
  int _counter = 0;
  SharedPreferences pref;
  TextEditingController _name = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _shippingAddress = TextEditingController();
  String totalWithDeliveryCost = '';
  int _paymentRadioValue = 0;
  TextEditingController _coupon = TextEditingController();

  void _customInit(APIProvider apiProvider) async {
    setState(() => _counter++);
    pref = await SharedPreferences.getInstance();
    Map map;
    if (widget.isCampaign) {
      map = {"location":"1","campaigns": true};
    }else{map = {"location":"1","campaigns": false};}
    apiProvider.getShippingMethods(map).then((value) {
      setState(()=>_isLoading2 = false);
    });
    if(pref.getString('username')!=null){
      if(apiProvider.userInfoModel==null){
        await apiProvider.getUserInfo(pref.getString('username'));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    totalPrice = widget.productPrice;
    pref = await SharedPreferences.getInstance();
    _name.text = pref.getString('name') ?? '';
    _mobile.text = pref.getString('mobile') ?? '';
    _shippingAddress.text = pref.getString('fullAddress') ?? '';
    _email.text = pref.getString('username') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    if (_counter == 0) _customInit(apiProvider);

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
      body: _bodyUI(themeProvider, apiProvider, size),
    );
  }

  Widget _bodyUI(
          ThemeProvider themeProvider, APIProvider apiProvider, Size size) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
                            ? TextSpan(
                                text: 'Size: ${widget.productSize}  ',
                                style: TextStyle(
                                    fontSize: size.width * .032,
                                    color: Colors.grey))
                            : TextSpan(),
                        widget.productColor.isNotEmpty
                            ? TextSpan(
                                text: 'Color: ${widget.productColor}\n',
                                style: TextStyle(
                                    fontSize: size.width * .032,
                                    color: Colors.grey))
                            : TextSpan(),
                        TextSpan(text: 'Quantity: $productQuantity Unit\n'),
                        TextSpan(
                            text:
                                'Unit Price: ${themeProvider.currency}${themeProvider.toggleCurrency(widget.productPrice)}\n'),
                        TextSpan(
                            text:
                                'Total Price: ${themeProvider.currency}${themeProvider.toggleCurrency(totalPrice)}'),
                      ],
                    ),
                  )),


              ///Product Quantity
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * .35,
                    child: Text(
                      'Product Quantity:',
                      style: TextStyle(
                          color: themeProvider.toggleTextColor(),
                          fontSize: size.width * .04),
                    ),
                  ),
                  Container(
                    width: size.width * .45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ///Decrease button
                        IconButton(
                          onPressed: () async {
                            if (productQuantity > 1) {
                              setState(() {
                                productQuantity--;
                                totalPrice = (int.parse(widget.productPrice) *
                                        productQuantity)
                                    .toString();
                              });
                            }
                          },
                          icon: Icon(
                            Icons.remove_circle_outline,
                            size: size.width * .06,
                            color: Colors.grey,
                          ),
                          splashRadius: size.width * .06,
                        ),
                        Text(
                          '$productQuantity',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: size.width * .044,
                              fontWeight: FontWeight.bold),
                        ),

                        ///Increase button
                        IconButton(
                          onPressed: () async {
                            closeLoadingDialog();
                            setState(() {
                              productQuantity++;
                              totalPrice = (int.parse(widget.productPrice) *
                                      productQuantity)
                                  .toString();
                            });
                          },
                          icon: Icon(
                            Icons.add_circle_outline_rounded,
                            size: size.width * .06,
                            color: Colors.grey,
                          ),
                          splashRadius: size.width * .06,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: size.width*.04),

              ///Coupon Field
              Container(
                height: size.width*.12,
                width: size.width,
                decoration: BoxDecoration(
                    color: themeProvider.whiteBlackToggleColor(),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Colors.grey,width: 0.5)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width*.6,
                      height: size.width*.12,
                      padding: EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: _coupon,
                        style: TextStyle(
                            color: themeProvider.toggleTextColor(),
                            fontSize: size.width*.04
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: size.width*.034), //Change this value to custom as you like
                          isDense: true,
                          alignLabelWithHint: true,
                          hintText: 'Type your voucher code',
                          hintStyle: TextStyle(
                              color: themeProvider.toggleTextColor(),
                              fontSize: size.width*.04
                          ),
                          enabled: true,
                          border: UnderlineInputBorder(
                              borderSide: BorderSide.none
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width*.31,
                      decoration: BoxDecoration(
                          color: themeProvider.fabToggleBgColor(),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)
                          )
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          minimumSize: Size(size.width*.12, size.width*.31),
                        ),
                        child: Text('Apply Coupon',style: TextStyle(fontSize: size.width*.04),),
                        onPressed: ()async{
                          if(_coupon.text.isNotEmpty){
                            showLoadingDialog('Please Wait');
                            Map map= {"coupon_code":"${_coupon.text}"};
                            await apiProvider.getCouponDiscount(map).then((value){
                              if(value==false){
                                closeLoadingDialog();
                                showInfo('No Discount Found');
                              }else{
                                closeLoadingDialog();
                                showInfo('Something went wrong');
                              }
                            });
                          }else showInfo('Missing Coupon Code');
                        },
                      ),
                    )
                  ],
                ),
              ),

              ///Shipping Location
              // _isLoading1
              //     ?Center(child: threeBounce(themeProvider))
              //     :Container(
              //   padding: EdgeInsets.symmetric(vertical: size.width*.01,horizontal: size.width*.03),
              //   decoration: BoxDecoration(
              //       border: Border.all(color: Colors.grey,width: 1),
              //       borderRadius: BorderRadius.all(Radius.circular(5))
              //   ),
              //   child: DropdownButtonHideUnderline(
              //     child: DropdownButton<ShippingLocationModel>(
              //       value: _shippingLocation,
              //       isExpanded: true,
              //       hint: Text("Select Delivery Location",style: TextStyle(
              //           color: Colors.grey,
              //           fontSize: size.width*.04)),
              //       onChanged: (value)async{
              //         setState((){
              //           _shippingLocation = value;
              //           _isLoading2=true;
              //           _shippingMethod=null;
              //         });
              //         Map map;
              //         if(widget.isCampaign){
              //           map = {"location":"${_shippingLocation.status}","campaigns": true};
              //         }else{
              //           map = {"location":"${_shippingLocation.status}"};
              //         }
              //         apiProvider.getShippingMethods(map).then((value){
              //           setState((){
              //             _isLoading2=false;
              //           });
              //         });
              //       },
              //       dropdownColor: themeProvider.whiteBlackToggleColor(),
              //       items: apiProvider.shippingLocationList
              //           .map<DropdownMenuItem<ShippingLocationModel>>((ShippingLocationModel model){
              //         return DropdownMenuItem<ShippingLocationModel>(
              //           value: model,
              //           child: Text('${model.city}',
              //               style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.04)),
              //         );
              //       }).toList(),
              //     ),
              //   ),
              // ),
              SizedBox(height: size.width * .04),

              ///Shipping Methods
              _isLoading2
                  ? Center(child: threeBounce(themeProvider))
                  : apiProvider.shippingMethodsList.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              vertical: size.width * .03,
                              horizontal: size.width * .03),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<ShippingMethodsModel>(
                              value: _shippingMethod,
                              isExpanded: true,
                              itemHeight: size.width * .22,
                              hint: Text("Select Delivery Option",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: size.width * .04)),
                              onChanged: (value) {
                                setState(() {
                                  _shippingMethod = value;
                                  if (_shippingMethod.cost.toLowerCase() ==
                                      'Free'.toLowerCase()) {
                                    totalPrice =
                                        (int.parse(widget.productPrice) *
                                                productQuantity)
                                            .toString();
                                  } else {
                                    totalPrice = 0.0.toString();
                                    totalPrice =
                                        (int.parse(widget.productPrice) *
                                                productQuantity)
                                            .toString();
                                    totalPrice = (double.parse(totalPrice) +
                                            double.parse(_shippingMethod.cost))
                                        .toString();
                                  }
                                });
                              },
                              dropdownColor:
                                  themeProvider.whiteBlackToggleColor(),
                              items: apiProvider.shippingMethodsList
                                  .map<DropdownMenuItem<ShippingMethodsModel>>(
                                      (ShippingMethodsModel model) {
                                return DropdownMenuItem<ShippingMethodsModel>(
                                  value: model,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: size.width * .15,
                                        height: size.height * .08,
                                        decoration: BoxDecoration(
                                            //color: Colors.red,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'https://baghmama.com.bd/${model.methodLogo}'),
                                                fit: BoxFit.cover)),
                                      ),
                                      SizedBox(width: size.width * .01),
                                      Expanded(
                                        child: Container(
                                          // height: size.height*.08,
                                          //color: Colors.green,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('${model.methodName}',
                                                  style: TextStyle(
                                                      color: themeProvider
                                                          .toggleTextColor(),
                                                      fontSize:
                                                          size.width * .036)),
                                              Text('Cost: ${model.cost}',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize:
                                                          size.width * .032)),
                                              Text(
                                                  'Time: ${model.estimateTime}',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize:
                                                          size.width * .032))
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
                        )
                      : Container(),
              SizedBox(height: size.width * .04),

              _textFieldBuilder(themeProvider, size, 'Full Name'),
              SizedBox(height: size.width * .04),
              _textFieldBuilder(themeProvider, size, 'Mobile Number'),
              SizedBox(height: size.width * .04),
              _textFieldBuilder(themeProvider, size, 'Email Address'),
              SizedBox(height: size.width * .04),
              _textFieldBuilder(themeProvider, size, 'Shipping Address'),
              SizedBox(height: size.width * .04),

              Text('Select Payment Option',
                  style: TextStyle(
                      color: themeProvider.toggleTextColor(),
                      fontSize: size.width * .04)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio(
                    fillColor: MaterialStateProperty.all(
                        themeProvider.orangeWhiteToggleColor()),
                    value: 1,
                    groupValue: _paymentRadioValue,
                    onChanged: (int change) {
                      setState(() {
                        _paymentRadioValue = change;
                        print('$_paymentRadioValue');
                      });
                    },
                  ),
                  Image.asset(
                    'assets/ssl_commerz.png',
                    height: 30,
                  ),
                ],
              ),
              _radioTileBuilder(2, 'Cash On Delivery', themeProvider, size),
              SizedBox(height: size.width * .07),

              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          themeProvider.fabToggleBgColor())),
                  onPressed: () {
                    if (_shippingMethod != null) {
                      if (_name.text.isNotEmpty &&
                          _mobile.text.isNotEmpty &&
                          _shippingAddress.text.isNotEmpty &&
                          _email.text.isNotEmpty) {
                        if (_paymentRadioValue == 0)
                          showInfo('Select Payment Option');
                        else {
                          if (_paymentRadioValue == 1)
                            _playNow(apiProvider);
                          else if (_paymentRadioValue == 2)
                            placeOrder(apiProvider);
                        }
                      } else
                        showInfo('Missing Your Information');
                    } else
                      showInfo('Select Delivery Option');
                  },
                  child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: Text(
                        'Continue To Payment',
                        style: TextStyle(fontSize: size.width * .04),
                      )))
            ],
          ),
        ),
      );

  Widget _textFieldBuilder(
          ThemeProvider themeProvider, Size size, String hint) =>
      TextFormField(
        controller: hint == 'Full Name'
            ? _name
            : hint == 'Mobile Number'
                ? _mobile
                : hint == 'Email Address'
                    ? _email
                    : _shippingAddress,
        maxLines: hint == 'Shipping Address' ? 3 : 1,
        style: TextStyle(
            color: themeProvider.toggleTextColor(), fontSize: size.width * .04),
        decoration: boxFormDecoration(size).copyWith(
          labelText: hint,
          alignLabelWithHint: hint == 'Shipping Address' ? true : false,
          contentPadding: EdgeInsets.symmetric(
              vertical: size.width * .038, horizontal: size.width * .038),
          //Change this value to custom as you like
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
          onChanged: (int change) {
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

  Future<void> _playNow(APIProvider apiProvider) async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
            //Use the ipn if you have valid one, or it will fail the transaction.
            ipn_url: "https://www.baghmama.com.bd",
            multi_card_name: '',
            currency: SSLCurrencyType.BDT,
            product_category: "Food",
            sdkType: SSLCSdkType.LIVE,
            store_id: "baghmamacombdlive",
            store_passwd: "60F4FA2FC9CCB58807",
            total_amount: double.parse(totalPrice),
            tran_id: DateTime.now().millisecondsSinceEpoch.toString()));
    sslcommerz
        .addEMITransactionInitializer(
            sslcemiTransactionInitializer: SSLCEMITransactionInitializer(
                emi_options: 1, emi_max_list_options: 3, emi_selected_inst: 2))
        .addShipmentInfoInitializer(
            sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
                shipmentMethod: "yes",
                numOfItems: 5,
                shipmentDetails: ShipmentDetails(
                    shipAddress1:
                        apiProvider.userInfoModel.content.state.toString(),
                    shipCity: apiProvider.userInfoModel.content.city.toString(),
                    shipCountry: "Bangladesh",
                    shipName: _shippingMethod.methodName.toString(),
                    shipPostCode: apiProvider.userInfoModel.content.postalcode
                        .toString())))
        .addCustomerInfoInitializer(
            customerInfoInitializer: SSLCCustomerInfoInitializer(
                customerState:
                    apiProvider.userInfoModel.content.state.toString(),
                customerName: _name.text,
                customerEmail: _email.text,
                customerAddress1: _shippingAddress.text,
                customerCity: _shippingAddress.text,
                customerPostCode:
                    apiProvider.userInfoModel.content.postalcode.toString(),
                customerCountry: "Bangladesh",
                customerPhone: pref.getString('mobile')))
        .addProductInitializer(
            sslcProductInitializer:
                // ***** ssl product initializer for general product STARTS*****
                SSLCProductInitializer(
                    productName: widget.productName,
                    productCategory: "All",
                    general: General(
                        general: "General Purpose",
                        productProfile: "Product Profile")))
        .addAdditionalInitializer(
            sslcAdditionalInitializer:
                SSLCAdditionalInitializer(valueA: "SSL_VERIFYPEER_FALSE"));
    var result = await sslcommerz.payNow();
    if (result is PlatformException) {
      print("the response is: " +
          result.message.toString() +
          " code: " +
          result.code);
    } else {
      SSLCTransactionInfoModel model = result;
      //print('Payment Status: ${model.status}');
      //showSuccessMgs('"Transaction Status: ${model.status}"');
      if (model.status == 'VALID') {
        showSuccessMgs('Payment Success');
        placeOrder(apiProvider, model: model);
      } else {
        showErrorMgs('Payment Failed!');
      }
    }
  }

  void placeOrder(APIProvider apiProvider,
      {SSLCTransactionInfoModel model}) async {
    showLoadingDialog('Ordering...');
    var sslResponseArray;
    if (model != null) {
      sslResponseArray =
        {
          "status": model.status,
          "error": "",
          "tran_date": model.tranDate,
          "val_id": model.valId,
          "amount": model.amount,
          "currency": model.currencyType,
          "card_issuer": model.cardIssuer,
          "card_brand": model.cardBrand,
          "card_sub_brand": "",
          "card_type": model.cardType,
          "card_no": model.cardNo,
          "bank_tran_id": model.bankTranId,
          "tran_id": model.tranId,
          "risk_title": model.riskTitle,
          "currency_amount": model.currencyAmount,
          "value_a": model.valueA
        };
    } else {
      sslResponseArray = '';
    }
    Map map = {
      "fullName": _name.text,
      "mobileNumber": _mobile.text,
      "email": _email.text,
      "fullAddress": _shippingAddress.text,
      "shippingId": _shippingMethod.id.toString(),
      "shippingName": _name.text,
      "shippingNumber": _mobile.text,
      "shippingAddress": _shippingAddress.text,
      "orderLocation": apiProvider.userInfoModel.content.city.toString(),
      "products": [
        {
          "p": widget.productId.toString(),
          "s": widget.productSize.toString(),
          "c": widget.productColor.toString(),
          "q": productQuantity.toString()
        }
      ],
      "gatewayResponse": sslResponseArray,
      "pmntMethod": _paymentRadioValue == 1 ? 'SSLCommerz' : 'Cash On Delivery',
      "pmntAmount": totalPrice.toString(),
      "pmntCurrency": "BDT"
    };
    await apiProvider.placeOrder(map).then((value) {
      if (value) {
        closeLoadingDialog();
        showSuccessMgs('Order Success');
        Navigator.pop(context);
        Navigator.pop(context);
      } else
        showErrorMgs('Error');
    });
  }
}
