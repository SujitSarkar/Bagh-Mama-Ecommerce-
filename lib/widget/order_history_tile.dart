import 'package:bagh_mama/models/order_model.dart';
import 'package:bagh_mama/pages/order_details.dart';
import 'package:bagh_mama/pages/order_history_list.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OrderHistoryTile extends StatelessWidget {
  OrderModel orderModel;
   OrderHistoryTile({this.orderModel});

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
                  TextSpan(text: orderModel.orderNo.toString()),
                  TextSpan(text: '\nOrdering Date: ',style: TextStyle(fontWeight: FontWeight.w500)),
                  TextSpan(text: DateFormat('dd-MMM-yyyy – hh:mm aa').format(orderModel.date)),
                ]
            ),
          ),
          SizedBox(height: size.width * .02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: ()async{
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderDetails(
                    orderId: orderModel.orderNo,
                  )));
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey,width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  padding: EdgeInsets.symmetric(horizontal: size.width * .01,vertical: size.width * .01),
                  child: Text('View Details',
                    style: TextStyle(
                        color: themeProvider.orangeWhiteToggleColor(),
                        fontSize: size.width*.035),
                  ),
                ),
                borderRadius:BorderRadius.all(Radius.circular(5)),
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
