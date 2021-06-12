import 'package:bagh_mama/models/shipping_methods_model.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  int _paymentRadioValue=1;

  @override
  void initState() {
    super.initState();
    if(widget.shippingMethod.cost!='free'){
      totalWithDeliveryCost='${double.parse(widget.totalAmount)+double.parse(widget.shippingMethod.cost)}';
    }
    else{
      totalWithDeliveryCost = widget.totalAmount;
    }
  }
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
          'Review Your Order',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(themeProvider, size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider, Size size) =>
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
              _radioTileBuilder(1, 'Card Payment', themeProvider, size),
              _radioTileBuilder(2, 'BKash', themeProvider, size),
              _radioTileBuilder(3, 'Rocket', themeProvider, size),
              SizedBox(height: size.width * .07),

              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
                  ),
                  onPressed: (){},
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
}
