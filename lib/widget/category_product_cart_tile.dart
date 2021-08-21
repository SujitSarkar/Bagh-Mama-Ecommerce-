import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProductCartTile extends StatelessWidget {
  int index;
  var productsModel;
  ProductCartTile({this.index,this.productsModel});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final double discountPrice = double.parse(themeProvider.toggleCurrency(productsModel.content[index].priceStockChart[0].sP))
        - double.parse(themeProvider.toggleCurrency(productsModel.content[index].priceStockChart[0].sP))*(productsModel.content[index].discount/100);
    return Container(
      width: size.width * .35,
      // height: size.width*.3,
      decoration: BoxDecoration(
        color: themeProvider.toggleCartColor(),
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: size.width * .5,
                height: size.width*.22,
                margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                child: CachedNetworkImage(
                  imageUrl: productsModel.content[index].thumbnailImage,
                  placeholder: (context, url) => Image.asset('assets/logo_512.png',
                    width: size.width * .5,
                    height: size.width*.22,
                    fit: BoxFit.cover),
                  errorWidget: (context, url, error) => Image.asset('assets/logo_512.png',
                    width: size.width * .5,
                    height: size.width*.22,
                    fit: BoxFit.cover),
                  width: size.width * .5,
                  height: size.width*.22,
                  fit: BoxFit.contain,
                ),
              ),
              productsModel.content[index].discount!=0? Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: size.width*.07,
                  width: size.width*.1,
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: themeProvider.orangeBlackToggleColor().withOpacity(0.8),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(size.width*.1),
                    ),
                  ),
                  child: Text('-${productsModel.content[index].discount}% ',style: TextStyle(color: Colors.white,fontSize: size.width*.03),),
                ),
              ):Container()
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6,vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${productsModel.content[index].name}',
                    maxLines: 2,
                    style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.03)),
                SizedBox(height: size.width*.02),
                productsModel.content[index].discount!=0? Text('${themeProvider.currency}${themeProvider.toggleCurrency(productsModel.content[index].priceStockChart[0].sP)}',
                    maxLines: 1,
                    style: TextStyle(color: themeProvider.toggleTextColor(),
                        fontSize: size.width*.026,fontWeight: FontWeight.w400,
                        decoration: TextDecoration.lineThrough)):Container(),
                SizedBox(height: size.width*.01),
                Text('${themeProvider.currency}${productsModel.content[index].discount!=0? discountPrice: themeProvider.toggleCurrency(productsModel.content[index].priceStockChart[0].sP)}',
                    maxLines: 1,
                    style: TextStyle(color: themeProvider.orangeWhiteToggleColor(),fontSize: size.width*.032,fontWeight: FontWeight.w500)),


              ],
            ),
          ),
        ],
      )
    );
  }
}