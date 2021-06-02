import 'package:bagh_mama/provider/api_provider.dart';
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
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    return Container(
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
          color: themeProvider.whiteBlackToggleColor(),
        // color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: size.width*.16,
            width: size.width*.4,
            alignment: Alignment.center,
            padding:EdgeInsets.symmetric(horizontal: 3,vertical: 2),
            decoration: BoxDecoration(
              color: themeProvider.toggleCartColor(),
              borderRadius: BorderRadius.all(Radius.circular(3)),
                border: Border.all(color: themeProvider.orangeWhiteToggleColor(),width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(apiProvider.subCategoryList[index].header,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.03,fontWeight: FontWeight.bold)),
                //SizedBox(height: size.width*.02),
                apiProvider.subCategoryList[index].sub.isNotEmpty
                    ?Icon(Icons.arrow_drop_down,color: themeProvider.toggleTextColor(),size: size.width*.04)
                    :Container(),
                Text(apiProvider.subCategoryList[index].sub,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.03,fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          // SizedBox(height: size.width*.02),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 5),
          //   child: Text('Drinks &\nJuice',
          //       maxLines: 2,
          //       textAlign: TextAlign.center,
          //       style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.032)),
          // ),
        ],
      ),
    );
  }
}