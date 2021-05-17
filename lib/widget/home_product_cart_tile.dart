import 'package:bagh_mama/models/products_model.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomeProductCartTile extends StatelessWidget {
  ProductsModel productsModel;
  int index;
  HomeProductCartTile({this.index,this.productsModel});
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final double discountPrice = int.parse(productsModel.content[index].priceStockChart[0].sP) - int.parse(productsModel.content[index].priceStockChart[0].sP)*(productsModel.content[index].discount/100);
    return Container(
      width: size.width * .35,
      // height: size.width*.3,
      margin: EdgeInsets.only(right: size.width * .03),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5)
            ),
            child: Image.asset(
              'assets/product_image/cycle.jpg',
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width * .35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${productsModel.content[index].name}',
                      maxLines: 3,
                      style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.032)),
                  SizedBox(height: size.width*.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Tk.${productsModel.content[index].discount!=0? discountPrice: productsModel.content[index].priceStockChart[0].sP}',
                          maxLines: 1,
                          style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.038,fontWeight: FontWeight.w500)),
                      SizedBox(width: size.width*.02),
                      productsModel.content[index].discount!=0? Text('Tk.${productsModel.content[index].priceStockChart[0].sP}',
                          maxLines: 1,
                          style: TextStyle(color: themeProvider.toggleTextColor(),
                              fontSize: size.width*.029,fontWeight: FontWeight.w400,
                          decoration: TextDecoration.lineThrough)):Container(),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            right: 0,
            top: 0,
            child: Container(
              height: size.width*.06,
              width: size.width*.1,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: themeProvider.orangeBlackToggleColor().withOpacity(0.8),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                ),
              ),
              child: Text('-${productsModel.content[index].discount}%',style: TextStyle(color: Colors.white,fontSize: size.width*.03),),
            ),
          )
        ],
      ),
    );
  }
}
