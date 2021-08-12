import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  String orderId;
  OrderDetails({this.orderId});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  int _counter=0;
  bool _isLoading=false;

  void _customInit(APIProvider apiProvider)async{
    setState(() {
      _counter++;
      _isLoading=true;
    });
    Map map = {"order_id":widget.orderId};
    bool result= await apiProvider.getOrderInfo(map);
    if(result){
      setState(()=> _isLoading=false);
    }else{
      setState(()=> _isLoading=false);
      showErrorMgs('Something went wrong');
    }
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
          'Order Details',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _isLoading
          ?Center(child: threeBounce(themeProvider))
          : _bodyUI(themeProvider,apiProvider, size),

    );
  }
  Widget _bodyUI(ThemeProvider themeProvider, APIProvider apiProvider, Size size)=>SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: size.width*.03,vertical: size.width*.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Order No
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Order No: ${apiProvider.orderInfoModel.content.orderNo}',
              style: TextStyle(color: themeProvider.toggleTextColor(),
                  fontWeight: FontWeight.bold,
              fontSize: size.width*.04)),

              Text('Ordering Date: ${DateFormat('dd-MM-yy – hh:mm aa').format(apiProvider.orderInfoModel.content.orderDate)}',
                style: TextStyle(color: themeProvider.toggleTextColor(),
                    fontSize: size.width*.034))
            ],
          ),
          SizedBox(height: size.width*.08),

          Text('Order Status:',
              style: TextStyle(color: themeProvider.toggleTextColor(),
                  fontWeight: FontWeight.w500,
                  fontSize: size.width*.04)),
          SizedBox(height: size.width*.04),

          ///Tracking Bar
          _trackingBarBuilder(apiProvider.orderInfoModel.content.orderStatus.status,
              size, themeProvider),
          SizedBox(height: size.width*.08),

          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              //text: 'Hello ',
                style: TextStyle(fontSize: size.width*.04,color: themeProvider.toggleTextColor()),
                children: <TextSpan>[
                  TextSpan(text: 'Payment Type: ',style: TextStyle(fontWeight: FontWeight.w500)),
                  TextSpan(text: apiProvider.orderInfoModel.content.paymentInfo.paymentType),
                  TextSpan(text: '\n\nShipping Address: ',style: TextStyle(fontWeight: FontWeight.w500)),
                  TextSpan(text: apiProvider.orderInfoModel.content.shippingInfo.shippingAddress),
                  TextSpan(text: '\n\nProduct Info:',style: TextStyle(fontWeight: FontWeight.w500)),
                ]
            ),
          ),

          ListView.builder(
            itemCount: apiProvider.orderInfoModel.content.products.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index)=>
                _productTile(index, themeProvider, apiProvider,size),
          )

        ],
      ),
    ),
  );

  Widget _productTile(int index,ThemeProvider themeProvider, APIProvider apiProvider,Size size)=>Container(
    padding: EdgeInsets.symmetric(vertical: 10),
    margin: EdgeInsets.only(bottom: 5),
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
                color: Colors.grey,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: CachedNetworkImage(
                  imageUrl: 'https://baghmama.com.bd/images/user/57.png',
                  placeholder: (context, url) => Image.asset('assets/placeholder.png'),
                  errorWidget: (context, url, error) => Icon(Icons.error,color: Colors.grey),
                  height: size.width * .18,
                  width: size.width * .18,
                  fit: BoxFit.fill,
                ),
              ),
            ),

            Container(
              alignment: Alignment.topLeft,
              padding:EdgeInsets.only(top: 5, bottom: 5),
              width: size.width * .67,
              //height: 65,
              //color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  ///Name Container
                  Text(
                    'Thi is product name',
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: size.width*.038,
                        color: themeProvider.toggleTextColor(),
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: size.width*.01),

                  ///Color & Size Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      apiProvider.orderInfoModel.content.products[index].productSize!=''
                          ?Text(
                        'Size: ${apiProvider.orderInfoModel.content.products[index].productSize}',
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: size.width*.035,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400),
                      ):Container(),
                      apiProvider.orderInfoModel.content.products[index].productSize!=''
                          ?SizedBox(width: size.width*.02)
                          :Container(),
                      apiProvider.orderInfoModel.content.products[index].productColor!=''
                          ?Text(
                        'Color: ${apiProvider.orderInfoModel.content.products[index].productColor}',
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: size.width*.035,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400),
                      ):Container(),
                    ],
                  ),
                  SizedBox(height: size.width*.01),

                  ///Price Row
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       discountPrice!=0
                  //           ? '${themeProvider.currency}${themeProvider.toggleCurrency(discountPrice.toString())}'
                  //           : '${themeProvider.currency}${themeProvider.toggleCurrency(databaseHelper.cartList[index].pPrice)}',
                  //       maxLines: 1,
                  //       style: TextStyle(
                  //           fontSize:  size.width*.04, color: themeProvider.orangeWhiteToggleColor(),fontWeight: FontWeight.w500),
                  //     ),
                  //     SizedBox(width: size.width*.02),
                  //
                  //     databaseHelper.cartList[index].pDiscount!='0'
                  //         ?Text('(${themeProvider.currency}${themeProvider.toggleCurrency(databaseHelper.cartList[index].pPrice)})',
                  //       maxLines: 1,
                  //       style: TextStyle(
                  //           fontSize:  size.width*.035,
                  //           color: Colors.grey,
                  //           fontWeight: FontWeight.w400,
                  //           decoration: TextDecoration.lineThrough),
                  //     ):Container(),
                  //   ],
                  // ),

                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _trackingBarBuilder(String status, Size size,ThemeProvider themeProvider)=>
      Column(
        children: [
          //Icon Row
          status=='Not seen yet'
              ?Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.green,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.green),
                Icon(CupertinoIcons.smallcircle_circle,
                  color: Colors.green,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
              ],
            ),
          )
              :status=='Processing'
              ?Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.green,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.green),
                Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.green,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.green),
                Icon(CupertinoIcons.smallcircle_circle,
                  color: Colors.green,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
              ],
            ),
          )
              :status=='Shipping'
              ?Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.green,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.green),
                Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.green,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.green),
                Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.green,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.green),
                Icon(CupertinoIcons.smallcircle_circle,
                  color: Colors.green,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
              ],
            ),
          )
              :status=='Delivered'
              ?Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.green,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.green),
                Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.green,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.green),
                Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.green,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.green),
                Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.green,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
              ],
            ),
          )
              :status=='Cancelled'
              ?Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.green,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.smallcircle_circle,
                  color: Colors.grey,size: size.width*.055,),
              ],
            ),
          )
              :status=='Returned'
              ?Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.green,size: size.width*.055,),
              ],
            ),
          )
              :Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
                Container(
                    width: size.width*.09,
                    height: size.width*.007,
                    color: Colors.grey),
                Icon(CupertinoIcons.circle,
                  color: Colors.grey,size: size.width*.055,),
              ],
            ),
          ),
          SizedBox(height: size.width*.04),

          //Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Unreviewed',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: themeProvider.toggleTextColor(),
                      fontSize: size.width*.029)),
              Text('Processing',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: themeProvider.toggleTextColor(),
                      fontSize: size.width*.029)),
              Text('Shipping',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: themeProvider.toggleTextColor(),
                      fontSize: size.width*.029)),
              Text('Delivered',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: themeProvider.toggleTextColor(),
                      fontSize: size.width*.029)),
              Text('Cancelled',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: themeProvider.toggleTextColor(),
                      fontSize: size.width*.029)),
              Text('Returned',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: themeProvider.toggleTextColor(),
                      fontSize: size.width*.029)),
            ],
          )
        ],
      );

}
