import 'package:bagh_mama/pages/product_details_page.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/ordered_product_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderedProductList extends StatefulWidget {
  @override
  _OrderedProductListState createState() => _OrderedProductListState();
}

class _OrderedProductListState extends State<OrderedProductList> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.whiteBlackToggleColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Products',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(themeProvider, size),
    );
  }

  _bodyUI(ThemeProvider themeProvider, Size size)=>ListView.builder(
    itemCount: 4,
    itemBuilder: (context, index)=>InkWell(
        child: OrderedProductTile(index),
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails())),
    ),
  );
}
