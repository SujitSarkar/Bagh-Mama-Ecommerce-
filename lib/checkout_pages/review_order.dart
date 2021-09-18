import 'package:bagh_mama/models/cart_model.dart';
import 'package:bagh_mama/models/nagad_payment_model.dart';
import 'package:bagh_mama/models/shipping_methods_model.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/sqlite_database_helper.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sslcommerz/model/SSLCAdditionalInitializer.dart';
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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'nagad_payment_webview.dart';

// ignore: must_be_immutable
class ReviewOrder extends StatefulWidget {
  String itemTotal;
  String itemSavings;
  String couponDiscount;
  String totalAmount;
  ShippingMethodsModel shippingMethod;
  String name;
  String email;
  String mobile;
  String address;
  ReviewOrder({this.itemTotal, this.itemSavings, this.couponDiscount,
      this.totalAmount, this.shippingMethod, this.name, this.email, this.mobile,
      this.address});

  @override
  _ReviewOrderState createState() => _ReviewOrderState();
}

class _ReviewOrderState extends State<ReviewOrder> {
  String totalWithDeliveryCost='';
  int _paymentRadioValue=0;
  int _counter = 0;
  bool _isLoading=true;

  @override
  void initState() {
    super.initState();
    if(widget.shippingMethod.cost.toLowerCase()!='Free'.toLowerCase()){
      totalWithDeliveryCost='${double.parse(widget.totalAmount)+double.parse(widget.shippingMethod.cost)}';
    }
    else{
      totalWithDeliveryCost = widget.totalAmount;
    }
  }

  void _customInit(APIProvider apiProvider) async {
    setState(() => _counter++);
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getString('username')!=null){
      if(apiProvider.userInfoModel==null){
        await apiProvider.getUserInfo(pref.getString('username'));
      }
    }
    await apiProvider.getPaymentGateways();
    setState(()=>_isLoading=false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);
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
      body: _isLoading? Center(child: threeBounce(themeProvider))
          :_bodyUI(themeProvider,apiProvider,databaseHelper,size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider,APIProvider apiProvider,DatabaseHelper databaseHelper, Size size) =>
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
                          text: 'Product Total\n',
                          style: TextStyle(
                              fontSize: size.width * .044,
                              fontWeight: FontWeight.w500),
                        ),
                        TextSpan(text: 'Total In Cart : '),
                        TextSpan(text: '${widget.itemTotal} item(s)\n'),
                        TextSpan(text: 'Total Amount : '),
                        TextSpan(text: '${themeProvider.currency}${themeProvider.toggleCurrency(widget.totalAmount)}'),
                      ],
                    ),
                  )),
              SizedBox(height: size.width * .07),

              _dottedContainer(themeProvider, size, RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  //text: 'Hello ',
                  style: TextStyle(
                      fontSize: size.width * .038,
                      color: themeProvider.toggleTextColor()),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Delivery Cost\n',
                      style: TextStyle(
                          fontSize: size.width * .044,
                          fontWeight: FontWeight.w500),
                    ),
                    TextSpan(text: 'Delivery Location : '),
                    TextSpan(text: '${widget.address}\n'),
                    TextSpan(text: 'Delivery Charge : '),
                    TextSpan(text: '${widget.shippingMethod.cost.toLowerCase()=='free'?''
                        :themeProvider.currency}${widget.shippingMethod.cost.toLowerCase()=='free'? 'Free'
                    :themeProvider.toggleCurrency(widget.shippingMethod.cost)}'),
                  ],
                ),
              )),
              SizedBox(height: size.width * .07),

            _dottedContainer(themeProvider, size, RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                //text: 'Hello ',
                style: TextStyle(
                    fontSize: size.width * .038,
                    color: themeProvider.toggleTextColor()),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Discount\n',
                    style: TextStyle(
                        fontSize: size.width * .044,
                        fontWeight: FontWeight.w500),
                  ),
                  TextSpan(text: 'Product Discount : '),
                  TextSpan(text: '${themeProvider.currency}${themeProvider.toggleCurrency(widget.itemSavings)}\n'),
                  TextSpan(text: 'Coupon Discount : '),
                  TextSpan(text: '${themeProvider.currency}${themeProvider.toggleCurrency(widget.couponDiscount)}'),
                  // TextSpan(text: 'Other Discount : '),
                  // TextSpan(text: 'TK 0.0'),
                ],
              ),
            )),
              SizedBox(height: size.width * .07),
              _dottedContainer(themeProvider, size, RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  //text: 'Hello ',
                  style: TextStyle(
                      fontSize: size.width * .05,
                      color: themeProvider.toggleTextColor()),
                  children: <TextSpan>[
                    TextSpan(text: 'Order Total\n'),
                    TextSpan(text: '${themeProvider.currency}${themeProvider.toggleCurrency(totalWithDeliveryCost)}'),

                  ],
                ),
              )),
              SizedBox(height: size.width * .04),

              ///SSL Commerz Radio
              apiProvider.paymentGateways.contains('SSLCommerz')? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio(
                    fillColor:
                    MaterialStateProperty.all(themeProvider.orangeWhiteToggleColor()),
                    value: 1,
                    groupValue: _paymentRadioValue,
                    onChanged: (int change){
                      setState(() {
                        _paymentRadioValue = change;
                        print('$_paymentRadioValue');
                      });
                    },
                  ),
                  Image.asset('assets/ssl_commerz.png',height: 30,),
                ],
              ):Container(),
              ///Nagad Radio
              apiProvider.paymentGateways.contains('Nagad')? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio(
                    fillColor: MaterialStateProperty.all(
                        themeProvider.orangeWhiteToggleColor()),
                    value: 2,
                    groupValue: _paymentRadioValue,
                    onChanged: (int change) {
                      setState(() {
                        _paymentRadioValue = change;
                        print('$_paymentRadioValue');
                      });
                    },
                  ),
                  Image.asset(
                    'assets/nagad.png',
                    height: 30,
                  ),
                ],
              ):Container(),
              apiProvider.paymentGateways.contains('Cash On Delivery')
                  ? _radioTileBuilder(3, 'Cash On Delivery', themeProvider, size):Container(),
              SizedBox(height: size.width * .07),

              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
                  ),
                  onPressed: (){
                    if(_paymentRadioValue==0)showInfo('Select Payment Option');
                    else{
                      if(_paymentRadioValue==1) _paySSlCommerzNow(apiProvider, databaseHelper);
                      if(_paymentRadioValue==2) _payNagad(apiProvider, databaseHelper);
                      if(_paymentRadioValue==3) placeOrder(apiProvider, databaseHelper);
                    }
                  },
                  child: Container(
                    width: size.width,
                      alignment: Alignment.center,
                      child: Text('Continue To Payment',style: TextStyle(fontSize: size.width*.04),))
              )
            ],
          ),
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

  Future<void> _paySSlCommerzNow(APIProvider apiProvider, DatabaseHelper databaseHelper) async {
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
            total_amount: double.parse(totalWithDeliveryCost),
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
                shipName: widget.shippingMethod.methodName.toString(),
                shipPostCode: apiProvider.userInfoModel.content.postalcode
                    .toString())))
        .addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerState:
            apiProvider.userInfoModel.content.state.toString(),
            customerName: widget.name,
            customerEmail: widget.email,
            customerAddress1: widget.address,
            customerCity: apiProvider.userInfoModel.content.city.toString(),
            customerPostCode:
            apiProvider.userInfoModel.content.postalcode.toString(),
            customerCountry: "Bangladesh",
            customerPhone: widget.mobile
        ))
        .addProductInitializer(
        sslcProductInitializer:
        // ***** ssl product initializer for general product STARTS*****
        SSLCProductInitializer(
            productName: databaseHelper.cartList[0].pName,
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
        placeOrder(apiProvider,databaseHelper, model: model);
      } else {
        showErrorMgs('Payment Failed!');
      }
    }
  }

  Future<void> _payNagad(APIProvider apiProvider, DatabaseHelper databaseHelper)async{
    showLoadingDialog('Please wait');
    Map map={
      "payment_amount":  double.parse(totalWithDeliveryCost)
    };
    await apiProvider.initNagadPayment(map).then((value)async{
      if(value){
        closeLoadingDialog();
        print(apiProvider.initNagadModel.content.redirectUrl);
        bool result =await Navigator.push(context, MaterialPageRoute(builder: (context)=>
            NagadPaymentWebView(initUrl: apiProvider.initNagadModel.content.redirectUrl)));

        if(result==true){
          showLoadingDialog('Please wait');
          Map map={ "payment_ref_id":apiProvider.initNagadModel.content.paymentRefId};
          await apiProvider.nagadPaymentCheck(map).then((value){
            closeLoadingDialog();
            if(apiProvider.nagadPaymentModel.content.status.toLowerCase()=='success'){
              placeOrder(apiProvider, databaseHelper, nagadPaymentModel: apiProvider.nagadPaymentModel);
            }
          });
        }
        if(result==false){
          showInfo('Incomplete Payment');
        }
      }
      else{
        closeLoadingDialog();
        print('Failed! Try again');
      }
    });
  }

  void placeOrder(APIProvider apiProvider, DatabaseHelper databaseHelper,
      {SSLCTransactionInfoModel model,NagadPaymentModel nagadPaymentModel})async{
    showLoadingDialog('Ordering...');

    var _orderingProductList=[];
    databaseHelper.cartList.forEach((element) {
      Map map = {
        "p": element.pId,
        "s": element.pSize,
        "c": element.pColor,
        "q": element.pQuantity,
      };
      _orderingProductList.add(map);
    });
    var paymentResponseObject;
    if (model != null && nagadPaymentModel==null) {
      paymentResponseObject =
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
    }
    else if(model == null && nagadPaymentModel!=null){
      paymentResponseObject={
        "merchantId": nagadPaymentModel.content.merchantId,
        "orderId": nagadPaymentModel.content.orderId,
        "paymentRefId": nagadPaymentModel.content.paymentRefId,
        "amount": nagadPaymentModel.content.amount,
        "clientMobileNo": nagadPaymentModel.content.clientMobileNo,
        "merchantMobileNo": nagadPaymentModel.content.merchantMobileNo,
        "orderDateTime": nagadPaymentModel.content.orderDateTime,
        "issuerPaymentDateTime": nagadPaymentModel.content.issuerPaymentDateTime,
        "issuerPaymentRefNo": nagadPaymentModel.content.issuerPaymentRefNo,
        "additionalMerchantInfo": nagadPaymentModel.content.additionalMerchantInfo,
        "status": nagadPaymentModel.content.status,
        "statusCode": nagadPaymentModel.content.statusCode,
        "cancelIssuerDateTime": nagadPaymentModel.content.cancelIssuerDateTime,
        "cancelIssuerRefNo": nagadPaymentModel.content.cancelIssuerRefNo
      };
    }
    else {
      paymentResponseObject = '';
    }
    Map map ={
      "fullName": widget.name,
      "mobileNumber": widget.mobile,
      "email": widget.email,
      "fullAddress": widget.address,
      "shippingId": widget.shippingMethod.id.toString(),
      "shippingName":  widget.name,
      "shippingNumber": widget.mobile,
      "shippingAddress": widget.address,
      "orderLocation": widget.shippingMethod.location,
      "products": _orderingProductList,
      "gatewayResponse": paymentResponseObject,
      "pmntMethod": _paymentRadioValue == 1
          ? 'SSLCommerz'
          : _paymentRadioValue == 2 ?'Nagad'
          : 'Cash On Delivery',
      "pmntAmount":"$totalWithDeliveryCost",
      "pmntCurrency":"BDT"
    };
    await apiProvider.placeOrder(map).then((value){
      if(value){
        closeLoadingDialog();
        showSuccessMgs('Order Success');
        databaseHelper.deleteAllCartList();
        Navigator.pop(context);
        Navigator.pop(context);
      }
      else showErrorMgs('Error');
    });
  }
}

