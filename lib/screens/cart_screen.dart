import 'package:bagh_mama/checkout_pages/user_info.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/cart_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
          'Cart List',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(themeProvider, size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider, Size size)=>ListView(
    children: [
      ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: 3,
        shrinkWrap: true,
        itemBuilder: (context,index)=>CartTile(index),
      ),

      Container(
        height: size.width*.12,
        width: size.width,
        margin: EdgeInsets.symmetric(horizontal: size.width*.03),
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
              // color: Colors.red,
              padding: EdgeInsets.only(left: 10),
              child: TextField(
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
                onPressed: (){},
              ),
            )
          ],
        ),
      ),
      SizedBox(height: size.width*.07),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width*.03),
        child: Divider(height: 0.5,color: Colors.grey),
      ),
      SizedBox(height: size.width*.07),

      Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width*.03),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Item Total',
                  style: TextStyle(color: themeProvider.toggleTextColor(),
                    fontSize: size.width*.04),
                ),
                Text('Tk.100.00',
                  style: TextStyle(color: themeProvider.toggleTextColor(),
                      fontSize: size.width*.04),
                ),
              ],
            ),
            SizedBox(height: size.width*.02),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Item Savings',
                  style: TextStyle(color: themeProvider.toggleTextColor(),
                    fontSize: size.width*.04),
                ),
                Text('Tk.100.00',
                  style: TextStyle(color: themeProvider.toggleTextColor(),
                      fontSize: size.width*.04),
                ),
              ],
            ),
            SizedBox(height: size.width*.02),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Coupon Discount',
                  style: TextStyle(color: themeProvider.toggleTextColor(),
                    fontSize: size.width*.04),
                ),
                Text('Tk.50.00',
                  style: TextStyle(color: themeProvider.toggleTextColor(),
                      fontSize: size.width*.04),
                ),
              ],
            ),
            SizedBox(height: size.width*.04),
            Divider(height: 0.5,color: Colors.grey),
            SizedBox(height: size.width*.04),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Total',
                  style: TextStyle(color: themeProvider.toggleTextColor(),
                      fontSize: size.width*.044,fontWeight: FontWeight.w500),
                ),
                Text('Tk.350.00',
                  style: TextStyle(color: themeProvider.toggleTextColor(),
                      fontSize: size.width*.044,fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: size.width*.07),

      Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width*.03),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
          ),
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>UserInfoPage())),
            child: Text('Proceed To Checkout',style: TextStyle(fontSize: size.width*.04),)
        ),
      ),
      SizedBox(height: 30,),
    ],
  );
}
