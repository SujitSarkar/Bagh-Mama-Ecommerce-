import 'package:bagh_mama/widget/wishlist_tile.dart';
import 'package:flutter/material.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class WishListPage extends StatefulWidget {
  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
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
      body: SafeArea(
        child: _bodyUI(themeProvider,size),
      ),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider, Size size)=>
      ListView.builder(
    physics: ClampingScrollPhysics(),
    itemCount: 3,
    itemBuilder: (context,index)=>WishlistTile(index),
  );
}
