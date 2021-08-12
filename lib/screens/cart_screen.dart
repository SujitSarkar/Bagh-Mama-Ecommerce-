import 'package:bagh_mama/checkout_pages/user_info.dart';
import 'package:bagh_mama/models/cart_model.dart';
import 'package:bagh_mama/pages/login_page.dart';
import 'package:bagh_mama/pages/product_details_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/sqlite_database_helper.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _counter=0;
  bool _isLoading=false;
  SharedPreferences _sharedPreferences;
  double _itemSavings=0.0;
  double _couponDiscount=0.0;
  double _total=0.0;
  TextEditingController _coupon = TextEditingController();

  void _customInit(DatabaseHelper databaseHelper)async{
    setState(()=> _counter++);
    _sharedPreferences = await SharedPreferences.getInstance();
    if(databaseHelper.cartList.isEmpty) await databaseHelper.getCartList();
     _itemSavings=0.0;
     _couponDiscount=0.0;
     _total=0.0;
      for(int i=0; i<databaseHelper.cartList.length;i++){
        setState(() {
          _itemSavings = _itemSavings +  int.parse(databaseHelper.cartList[i].pQuantity)
              * (int.parse(databaseHelper.cartList[i].pPrice)*
                  (int.parse(databaseHelper.cartList[i].pDiscount)/100));
          _total = (_total + ((double.parse(databaseHelper.cartList[i].pPrice) -
              double.parse(databaseHelper.cartList[i].pPrice)*(int.parse(databaseHelper.cartList[i].pDiscount)/100)) *
              int.parse(databaseHelper.cartList[i].pQuantity)));
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);
    if(_counter==0)_customInit(databaseHelper);

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
      body: _isLoading
          ?Center(child: threeBounce(themeProvider))
          : _bodyUI(themeProvider,databaseHelper,apiProvider, size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider,DatabaseHelper databaseHelper,
      APIProvider apiProvider, Size size)=>
      databaseHelper.cartList.isEmpty
          ? Center(child: Text('Empty Cart !',style: TextStyle(
        color: themeProvider.toggleTextColor(),
        fontSize: size.width*.045
      )))
          :ListView(
    children: [
      ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: databaseHelper.cartList.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                  productId: int.parse(databaseHelper.cartList[index].pId),
                  //categoryId: apiProvider.categoryProductModel.content[index].categoryId,
                )));
              },
              child: _cartTile(index, size, databaseHelper, themeProvider)
          );
        },
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
                Text('${databaseHelper.cartList.length} Unit',
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
                Text('${themeProvider.currency}${themeProvider.toggleCurrency(_itemSavings.toString())}',
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
                Text('${themeProvider.currency}${themeProvider.toggleCurrency(_couponDiscount.toString())}',
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
                Text('${themeProvider.currency}${themeProvider.toggleCurrency(_total.toString())}',
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
            onPressed: (){
            if(_sharedPreferences.getString('username')!=null){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>UserInfoPage(
                itemTotal: '${databaseHelper.cartList.length}',
                itemSavings: _itemSavings.toString(),
                couponDiscount: _couponDiscount.toString(),
                totalAmount: _total.toString(),
              )));
            }else{
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
            }
            },
            child: Text('Proceed To Checkout',style: TextStyle(fontSize: size.width*.04),)
        ),
      ),
      SizedBox(height: 30),
    ],
  );

  Widget _cartTile(int index, Size size, DatabaseHelper databaseHelper,
      ThemeProvider themeProvider){
    final double discountPrice = int.parse(databaseHelper.cartList[index].pPrice) -
        (int.parse(databaseHelper.cartList[index].pPrice)*
            (int.parse(databaseHelper.cartList[index].pDiscount)/100));
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: size.width*.03),
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Image Container
              Container(
                height: size.width * .3,
                width: size.width * .3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.grey,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: CachedNetworkImage(
                    imageUrl: databaseHelper.cartList[index].pImageLink,
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
                width: size.width * .62,
                //height: 65,
                //color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    ///Name Container
                    Text(
                      databaseHelper.cartList[index].pName,
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
                        databaseHelper.cartList[index].pSize!=''
                            ?Text(
                          'Size: ${databaseHelper.cartList[index].pSize}',
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: size.width*.035,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400),
                        ):Container(),
                        databaseHelper.cartList[index].pSize!=''
                            ?SizedBox(width: size.width*.02)
                            :Container(),
                        databaseHelper.cartList[index].pColor!=''
                            ?Text(
                          'Color: ${databaseHelper.cartList[index].pColor}',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          discountPrice!=0
                              ? '${themeProvider.currency}${themeProvider.toggleCurrency(discountPrice.toString())}'
                              : '${themeProvider.currency}${themeProvider.toggleCurrency(databaseHelper.cartList[index].pPrice)}',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize:  size.width*.04, color: themeProvider.orangeWhiteToggleColor(),fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: size.width*.02),

                        databaseHelper.cartList[index].pDiscount!='0'
                            ?Text('(${themeProvider.currency}${themeProvider.toggleCurrency(databaseHelper.cartList[index].pPrice)})',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize:  size.width*.035,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.lineThrough),
                        ):Container(),
                      ],
                    ),
                    ///Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Icon(Icons.delete_outline,size: size.width*.07,
                              color: themeProvider.toggleTextColor()),
                          onTap: ()async{
                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return ClassicGeneralDialogWidget(
                                  titleText: 'Remove This Product?',
                                  positiveText: 'Yes',
                                  negativeText: 'No',
                                  negativeTextStyle: TextStyle(
                                      color: Colors.green
                                  ),
                                  positiveTextStyle: TextStyle(
                                      color: Colors.redAccent
                                  ),
                                  onPositiveClick: () async{
                                    showLoadingDialog('Removing');
                                    await databaseHelper.deleteCart(databaseHelper.cartList[index].pId).then((value){
                                      closeLoadingDialog();
                                      _customInit(databaseHelper);
                                      Navigator.pop(context);
                                    });
                                  },
                                  onNegativeClick: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                              animationType: DialogTransitionType.slideFromBottom,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(milliseconds: 500),
                            );
                          },
                          //splashRadius: ,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: ()async{
                                int quantity= int.parse(databaseHelper.cartList[index].pQuantity);
                                if(quantity>1) {
                                  showLoadingDialog('Updating');
                                  quantity--;
                                  CartModel cartModel= CartModel(databaseHelper.cartList[index].pId,
                                      databaseHelper.cartList[index].pSize,
                                      databaseHelper.cartList[index].pName,
                                      databaseHelper.cartList[index].pDiscount,
                                      databaseHelper.cartList[index].pColor,
                                      quantity.toString(),
                                      databaseHelper.cartList[index].pImageLink,
                                      databaseHelper.cartList[index].pPrice);
                                  await databaseHelper.updateCart(cartModel).then((value){
                                    closeLoadingDialog();
                                    _customInit(databaseHelper);
                                  });
                                }
                              },
                              icon: Icon(Icons.remove_circle_outline,size: size.width*.06,color: themeProvider.toggleTextColor(),), splashRadius: size.width*.06,
                            ),
                            SizedBox(width: size.width*.01),
                            Text(databaseHelper.cartList[index].pQuantity,style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.05,fontWeight: FontWeight.w400),),
                            SizedBox(width: size.width*.01),
                            IconButton(
                              onPressed: ()async{
                                int quantity= int.parse(databaseHelper.cartList[index].pQuantity);
                                showLoadingDialog('Updating');
                                quantity++;
                                CartModel cartModel= CartModel(databaseHelper.cartList[index].pId,
                                    databaseHelper.cartList[index].pSize,
                                    databaseHelper.cartList[index].pName,
                                    databaseHelper.cartList[index].pDiscount,
                                    databaseHelper.cartList[index].pColor,
                                    quantity.toString(),
                                    databaseHelper.cartList[index].pImageLink,
                                    databaseHelper.cartList[index].pPrice);
                                await databaseHelper.updateCart(cartModel).then((value){
                                  _customInit(databaseHelper);
                                  closeLoadingDialog();
                                });
                              },
                              icon: Icon(Icons.add_circle_outline_rounded,size: size.width*.06,color: themeProvider.toggleTextColor(),),splashRadius: size.width*.06,),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
