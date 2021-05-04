import 'package:bagh_mama/pages/ordered_product_list.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OrderHistoryTile extends StatefulWidget {
  int index;
  OrderHistoryTile(this.index);

  @override
  _OrderHistoryTileState createState() => _OrderHistoryTileState();
}

class _OrderHistoryTileState extends State<OrderHistoryTile> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.width*.03,horizontal: size.width*.03),
      margin: EdgeInsets.only(bottom: size.width*.03,left: size.width*.03,right: size.width*.03),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey,width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              //text: 'Hello ',
              style: TextStyle(fontSize: size.width*.038,color: themeProvider.toggleTextColor()),
              children: <TextSpan>[
                TextSpan(text: 'Order No: ',style: TextStyle(fontWeight: FontWeight.w500)),
                TextSpan(text: '05210310072269\n'),
                TextSpan(text: 'Ordering Date: ',style: TextStyle(fontWeight: FontWeight.w500)),
                TextSpan(text: '2021-05-03 22:07:38\n'),
                TextSpan(text: 'Payment Type: ',style: TextStyle(fontWeight: FontWeight.w500)),
                TextSpan(text: 'Cash On Delivery\n'),
                TextSpan(text: 'Status: ',style: TextStyle(fontWeight: FontWeight.w500)),
                TextSpan(text: 'Not seen yet'),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 5),
                  child: Text('View Products',style: TextStyle(color: themeProvider.orangeWhiteToggleColor(),fontSize: size.width*.035),),
                ),
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderedProductList())),
              ),
              InkWell(
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 5),
                  child: Text('Cancel Order',style: TextStyle(color: Colors.grey,fontSize: size.width*.035),),
                ),
                onTap: (){},
              )
            ],
          )
        ],
      ),
    );
  }
}