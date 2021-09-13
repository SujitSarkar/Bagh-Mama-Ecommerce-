import 'package:bagh_mama/models/user_info_model.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OrderHistoryTile extends StatelessWidget {
  CustomerOrder orderModel;
   OrderHistoryTile({this.orderModel});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: size.width*.03,horizontal: size.width*.03),
      margin: EdgeInsets.only(bottom: size.width*.02,top: size.width*.02,left: size.width*.03,right: size.width*.03),
      decoration: BoxDecoration(
        color: themeProvider.toggleCartColor(),
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  //text: 'Hello ',
                    style: TextStyle(fontSize: size.width*.038,color: themeProvider.toggleTextColor()),
                    children: <TextSpan>[
                      TextSpan(text: 'Order No: ',style: TextStyle(fontWeight: FontWeight.w500)),
                      TextSpan(text: orderModel.orderNo.toString(),style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xDDFF8C00))),
                    ]
                ),
              ),
              Text(orderModel.pstatus,
                  style: TextStyle(color: Colors.grey,fontSize: size.width*.04,fontStyle: FontStyle.italic))
            ],
          ),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              //text: 'Hello ',
                style: TextStyle(fontSize: size.width*.038,color: themeProvider.toggleTextColor()),
                children: <TextSpan>[
                  TextSpan(text: '\nPlaced on ',style: TextStyle(fontWeight: FontWeight.w500)),
                  TextSpan(text: DateFormat('dd-MMM-yyyy, hh:mm aa').format(orderModel.date)),
                ]
            ),
          ),
          //SizedBox(height: size.width * .02),

          ListView.builder(
            itemCount: orderModel.products.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index)=>
                _productTile(orderModel.products[index],themeProvider,size),
          ),
        ],
      ),
    );
  }

  Widget _productTile(Product product,ThemeProvider themeProvider,Size size)=>Container(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Image Container
            Container(
              height: size.width * .25,
              width: size.width * .25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: CachedNetworkImage(
                  imageUrl: product.productImage,
                  placeholder: (context, url) => Image.asset('assets/logo_512.png'),
                  errorWidget: (context, url, error) => Icon(Icons.error,color: Colors.grey),
                  height: size.width * .18,
                  width: size.width * .18,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                padding:EdgeInsets.only(top: 5, bottom: 5,left: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///Name Container
                    Text(
                      '${product.productName}',
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: size.width*.038,
                          color: themeProvider.toggleTextColor(),
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: size.width*.01),
                    Text(
                      'Price: ${product.productPrice}',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: size.width*.035,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
