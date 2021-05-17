import 'package:bagh_mama/pages/subcategory_product_list.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/variables/public_data.dart';
import 'package:bagh_mama/widget/main_subcategory_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Categories',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(size, themeProvider),
    );
  }

  Widget _bodyUI(Size size, ThemeProvider themeProvider) => Container(
        height: size.height,
        width: size.width,
        color: themeProvider.togglePageBgColor(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///SideBar
            Container(
              width: size.width * .24,
              color: themeProvider.whiteBlackToggleColor(),
              child: ListView.builder(
                itemCount: PublicData.productCategoryList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedIndex = index);
                    },
                    child: Container(
                      color: index == _selectedIndex
                          ? themeProvider.selectedToggleColor()
                          : themeProvider.whiteBlackToggleColor(),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        PublicData.productCategoryList[index],
                        style: TextStyle(
                            fontSize: size.width * .03,
                            fontWeight: index == _selectedIndex
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: themeProvider.toggleTextColor()),
                      ),
                    ),
                  );
                },
              ),
            ),

            ///Main Page Section
            Container(
              width: size.width * .74,
              color: themeProvider.whiteBlackToggleColor(),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Banner Image
                  Container(
                    height: size.width * .3,
                    // width: size.width*.74,
                    padding: EdgeInsets.only(right: 10),
                    child: Image.network('https://i.pinimg.com/originals/cc/18/8c/cc188c604e58cffd36e1d183c7198d21.jpg',
                        fit: BoxFit.fitWidth),
                  ),
                  SizedBox(height: size.width * .03),

                  GridView.builder(
                    physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: .8,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: 14,
                      itemBuilder: (context, index) => InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SubcategoryProductList())),
                          child: MainSubcategoryTile(index: index))),
                ],
              ),
            )
          ],
        ),
      );
}
