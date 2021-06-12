import 'package:bagh_mama/pages/product_details_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishListPage extends StatefulWidget {
  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  int _counter=0;
  bool _isLoading=true;
  SharedPreferences sharedPreferences;

  _customInit(APIProvider apiProvider)async{
    setState(()=> _counter++);
    sharedPreferences = await SharedPreferences.getInstance();
    if(apiProvider.wishListIdList.isNotEmpty && apiProvider.wishList.isEmpty){
      await apiProvider.getWishListProduct().then((value){
        setState(()=> _isLoading=false);
        print(_isLoading);
      });
    }else setState(()=> _isLoading=false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    if(_counter==0) _customInit(apiProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeProvider.whiteBlackToggleColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Wishlists',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body:SafeArea(
        child:_isLoading
            ?Center(child: threeBounce(themeProvider))
            :  _bodyUI(themeProvider,apiProvider,size),
      ),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider,APIProvider apiProvider, Size size)=>
      apiProvider.wishList.isEmpty
          ?Center(child: Text('Empty Wishlist !',style: TextStyle(
          color: themeProvider.toggleTextColor(),
          fontSize: size.width*.045
      )))
          :ListView.builder(
    itemCount: apiProvider.wishList.length,
    itemBuilder: (context,index)=>_wishListCartTile(themeProvider, apiProvider, size, index),
  );

  Widget _wishListCartTile(ThemeProvider themeProvider, APIProvider apiProvider, Size size,int index){
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
                  //color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.grey,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: CachedNetworkImage(
                    imageUrl: apiProvider.wishList[index].pImageLink,
                    placeholder: (context, url) => Image.asset('assets/placeholder.png',
                      height: size.width * .3,
                      width: size.width * .3,
                      fit: BoxFit.cover,),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: size.width * .18,
                    width: size.width * .18,
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              ///Name & Price Container
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
                    Text(
                      apiProvider.wishList[index].pName,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: size.width*.038,
                          color: themeProvider.toggleTextColor(),
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: size.width*.02),
                    Text(
                      '${themeProvider.currency}${themeProvider.toggleCurrency(apiProvider.wishList[index].pPrice)}',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize:  size.width*.04, color: themeProvider.toggleTextColor(),fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: size.width*.04),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                              productId: int.parse(apiProvider.wishList[index].pId),
                            )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey,width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            padding: EdgeInsets.symmetric(horizontal: size.width * .03,vertical: size.width * .015),
                            child: Text('Details',
                              style: TextStyle(
                                  color: themeProvider.orangeWhiteToggleColor(),
                                  fontSize: size.width*.033),
                            ),
                          ),
                          borderRadius:BorderRadius.all(Radius.circular(5)),
                        ),
                        InkWell(
                          child: Icon(Icons.delete_outline,size: size.width*.07,color: themeProvider.toggleTextColor(),),
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
                                    showLoadingDialog('Removing...');
                                    Map map = {
                                      "user_id":int.parse(sharedPreferences.getString('userId')),
                                      "product_id":int.parse(apiProvider.wishList[index].pId)
                                    };
                                    await apiProvider.removeItemFromWishList(map).then((value)async{
                                      if(value){
                                        await apiProvider.getUserInfo(sharedPreferences.getString('username')).then((value)async{
                                          await apiProvider.getWishListProduct().then((value)async{
                                            closeLoadingDialog();
                                            showSuccessMgs('Product Removed');
                                            Navigator.pop(context);
                                          });
                                        });
                                      }else{
                                        closeLoadingDialog();
                                        showErrorMgs('Failed !');
                                      }
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
