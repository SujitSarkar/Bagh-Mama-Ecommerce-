import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomeProductCartTile extends StatelessWidget {
  int index;
  HomeProductCartTile({this.index});
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: size.width * .35,
      // height: size.width*.3,
      margin: EdgeInsets.only(right: size.width * .03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Avon Trux Bicycles Model-66TF',
                  maxLines: 3,
                  style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.032)),
              SizedBox(height: size.width*.02),
              Text('Tk.1000',
                  maxLines: 1,
                  style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.038,fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
