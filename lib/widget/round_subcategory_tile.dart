import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RoundSubcategoryTile extends StatelessWidget {
  int index;

  RoundSubcategoryTile({this.index});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
          color: themeProvider.whiteBlackToggleColor(),
          borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: size.width*.2,
            width: size.width*.2,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(size.width*.1)),
                border: Border.all(color: themeProvider.orangeWhiteToggleColor(),width: 1),
              image: DecorationImage(
                image: AssetImage( index%2==0?'assets/product_image/cycle.jpg':'assets/product_image/product.jpg'),
                fit: BoxFit.cover
              )
            ),
          ),
          SizedBox(height: size.width*.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text('Drinks &\nJuice',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.032)),
          ),
        ],
      ),
    );
  }
}