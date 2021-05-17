import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProductCartTile extends StatelessWidget {
  int index;

  ProductCartTile({this.index});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: size.width * .35,
      // height: size.width*.3,
      decoration: BoxDecoration(
        color: themeProvider.toggleCartColor(),
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5)
            ),
            child: Image.asset(
              index%2==0?'assets/product_image/cycle.jpg':'assets/product_image/product.jpg',
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(height: size.width*.02),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width * .35,
              padding: EdgeInsets.only(left: 5,right: 5,bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Quality Avon Trux Bicycles Model-66TF',
                      maxLines: 2,
                      style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.032)),
                  SizedBox(height: size.width*.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Tk.800',
                          maxLines: 1,
                          style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.038,fontWeight: FontWeight.w500)),
                      SizedBox(width: size.width*.02),
                      Text('Tk.1000',
                          maxLines: 1,
                          style: TextStyle(color: themeProvider.toggleTextColor(),
                              fontSize: size.width*.029,fontWeight: FontWeight.w400,
                              decoration: TextDecoration.lineThrough)),
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
              child: Text('-20%',style: TextStyle(color: Colors.white,fontSize: size.width*.03),),
            ),
          )
        ],
      ),
    );
  }
}