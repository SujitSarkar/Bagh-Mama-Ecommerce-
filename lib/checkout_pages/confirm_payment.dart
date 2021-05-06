import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';

class ConfirmPayment extends StatefulWidget {
  const ConfirmPayment({Key key}) : super(key: key);

  @override
  _ConfirmPaymentState createState() => _ConfirmPaymentState();
}

class _ConfirmPaymentState extends State<ConfirmPayment> {
  String _paymentType;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.whiteBlackToggleColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Text(
          'Payment & Confirm',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(themeProvider, size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider, Size size)=>Center(
    child: Container(
      height: size.width,
      margin: EdgeInsets.symmetric(horizontal: size.width*.03),
      padding: EdgeInsets.symmetric(horizontal: size.width*.03),
      decoration: BoxDecoration(
        //color: Colors.red,
        color: themeProvider.togglePageBgColor(),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _cardBuilder(themeProvider, size, 'assets/payment_image/cod.png', 'Cash On Delivery'),
              SizedBox(height: size.width*.04),
              Text('or',style: TextStyle(color: Colors.grey,fontSize: size.width*.035)),
              Divider(color: Colors.grey,thickness: 0.5,height: 0,)
            ],
          ),
          SizedBox(height: size.width*.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _cardBuilder(themeProvider, size, 'assets/payment_image/bkash.png', 'bKash'),
              _cardBuilder(themeProvider, size, 'assets/payment_image/rocket.png', 'Rocket'),
              _cardBuilder(themeProvider, size, 'assets/payment_image/nagad.png', 'Nagad'),
            ],
          )
        ],
      ),
    ),
  );

  Widget _cardBuilder(ThemeProvider themeProvider, Size size, String image, String title)=>InkWell(
    onTap: (){
      if(title=='Cash On Delivery'){
        setState(() {
          _paymentType = 'Cash On Delivery';
        });
        _cashOnDeliveryDialog(size, themeProvider);
      }
      else if(title=='bKash'){
        setState(() {
          _paymentType = 'bKash';
        });
        _paymentDialog(size, themeProvider);
      }
      else if(title=='Rocket'){
        setState(() {
          _paymentType = 'Rocket';
        });
        _paymentDialog(size, themeProvider);
      }
      else if(title=='Nagad'){
        setState(() {
          _paymentType = 'Nagad';
        });
        _paymentDialog(size, themeProvider);
      }
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: size.width*.03,vertical: size.width*.03),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey,width: 1),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image,height: size.width*.2,width: size.width*.2),
          Text(title,style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.04)),
          SizedBox(height: 5),
        ],
      ),
    ),
  );

  void _paymentDialog(Size size, ThemeProvider themeProvider){
    showAnimatedDialog(
        context: context,
        animationType: DialogTransitionType.slideFromBottomFade,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 500),
        builder: (context){
          return AlertDialog(
            backgroundColor: themeProvider.toggleBgColor(),
            contentPadding: EdgeInsets.symmetric(horizontal: size.width*.04),
            scrollable: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_paymentType,style: TextStyle(fontSize: size.width*.05,fontWeight: FontWeight.w500,color: themeProvider.toggleTextColor()),),
                    IconButton(
                      icon: Icon(Icons.cancel_outlined,color: Colors.grey,size: size.width*.06,),
                      onPressed: (){Navigator.pop(context);},
                      splashRadius: size.width*.05,
                    )
                  ],
                ),
                SizedBox(height: size.width*.05),
                _textFieldBuilder(themeProvider, size, '$_paymentType Account Number'),
                SizedBox(height: size.width*.04),
                _textFieldBuilder(themeProvider, size, 'Payment Transaction Id'),
                SizedBox(height: size.width*.05),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
                    ),
                    onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ConfirmPayment())),
                    child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: Text('Place Order',style: TextStyle(fontSize: size.width*.04),))
                ),
                SizedBox(height: size.width*.05),
              ],
            ),
          );
        });
  }

  void _cashOnDeliveryDialog(Size size, ThemeProvider themeProvider){
    showAnimatedDialog(
        context: context,
        animationType: DialogTransitionType.slideFromBottomFade,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 500),
        builder: (context){
          return AlertDialog(
            backgroundColor: themeProvider.toggleBgColor(),
            contentPadding: EdgeInsets.symmetric(horizontal: size.width*.04),
            scrollable: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_paymentType,style: TextStyle(fontSize: size.width*.05,fontWeight: FontWeight.w500,color: themeProvider.toggleTextColor()),),
                    IconButton(
                      icon: Icon(Icons.cancel_outlined,color: Colors.grey,size: size.width*.06,),
                      onPressed: (){Navigator.pop(context);},
                      splashRadius: size.width*.05,
                    )
                  ],
                ),
                SizedBox(height: size.width*.05),

                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
                    ),
                    onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ConfirmPayment())),
                    child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: Text('Place Order',style: TextStyle(fontSize: size.width*.04),))
                ),
                SizedBox(height: size.width*.05),
              ],
            ),
          );
        });
  }

  Widget _textFieldBuilder(ThemeProvider themeProvider, Size size, String hint)=> TextFormField(
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
