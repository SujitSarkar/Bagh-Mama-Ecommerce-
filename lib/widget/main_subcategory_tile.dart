import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MainSubcategoryTile extends StatelessWidget {
  int index;

  MainSubcategoryTile({this.index});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
          color: themeProvider.whiteBlackToggleColor(),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: size.width*.15,
            width: size.width*.15,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                    image: AssetImage( index%2==0?'assets/product_image/cycle.jpg':'assets/product_image/product.jpg'),
                    fit: BoxFit.cover
                )
            ),
          ),
          SizedBox(height: size.width*.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text('Juice &\nDrink',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.03,fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}