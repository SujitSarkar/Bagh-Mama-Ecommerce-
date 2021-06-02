import 'package:bagh_mama/provider/api_provider.dart';
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
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    return Container(
        height: size.width*.15,
        width: size.width*.15,
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
          color: themeProvider.whiteBlackToggleColor(),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.grey)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Container(
          //   height: size.width*.15,
          //   width: size.width*.15,
          //   decoration: BoxDecoration(
          //       color: Colors.grey,
          //       borderRadius: BorderRadius.all(Radius.circular(5)),
          //       image: DecorationImage(
          //           image: AssetImage( index%2==0?'assets/product_image/cycle.jpg':'assets/product_image/product.jpg'),
          //           fit: BoxFit.cover
          //       )
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(apiProvider.subCategoryList[index].header,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.028,fontWeight: FontWeight.bold)),
          ),
          //SizedBox(height: size.width*.02),
          apiProvider.subCategoryList[index].sub.isNotEmpty
              ?Icon(Icons.arrow_drop_down,color: themeProvider.toggleTextColor(),size: size.width*.05)
              :Container(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(apiProvider.subCategoryList[index].sub,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.028,fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}