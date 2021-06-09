import 'package:bagh_mama/pages/subcategory_product_list.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/main_subcategory_tile.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _counter=0;

  _customInit(APIProvider apiProvider)async{
    setState(()=>_counter++);
    if(apiProvider.mainCategoryList.isEmpty) await apiProvider.getProductCategories();
    apiProvider.updateSubCategoryList('All');
    setState(() => apiProvider.selectedIndex = 0);
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    if(_counter==0) _customInit(apiProvider);

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
      body: _bodyUI(size, themeProvider,apiProvider),
    );
  }

  Widget _bodyUI(Size size, ThemeProvider themeProvider,APIProvider apiProvider) => Container(
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
              child: apiProvider.mainCategoryList.isNotEmpty
                  ? ListView.builder(
                itemCount: apiProvider.mainCategoryList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      apiProvider.updateSubCategoryList(apiProvider.mainCategoryList[index]);
                      setState(() => apiProvider.selectedIndex = index);
                    },
                    child: Container(
                      color: index == apiProvider.selectedIndex
                          ? themeProvider.selectedToggleColor()
                          : themeProvider.whiteBlackToggleColor(),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        apiProvider.mainCategoryList[index],
                        style: TextStyle(
                            fontSize: size.width * .03,
                            fontWeight: index == apiProvider.selectedIndex
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: themeProvider.toggleTextColor()),
                      ),
                    ),
                  );
                },
              ): threeBounce(themeProvider),
            ),

            ///Main Page Section
            Container(
              width: size.width * .74,
              //color: themeProvider.whiteBlackToggleColor(),
              child: GridView.builder(
                  physics: ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: apiProvider.subCategoryList.length,
                  itemBuilder: (context, index) => InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SubcategoryProductList(
                                    categoryId: apiProvider.subCategoryList[index].id,
                                    subCategoryName: apiProvider.subCategoryList[index].sub,
                                  ))),
                      child: MainSubcategoryTile(index: index))),
            )
          ],
        ),
      );
}
