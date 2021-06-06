import 'package:bagh_mama/pages/product_details_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/category_product_cart_tile.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isLoading=false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.toggleBgColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.toggleBgColor(),
        leadingWidth: 0.0,
        leading: Icon(Icons.arrow_back,color: Colors.transparent),
        elevation: 0.0,
        title: Container(
          width: size.width,
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){},
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: Container(
                  height: 40,
                  width: size.width*.74,
                  // color: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      border: Border.all(width: 1,color: Colors.grey[400])
                  ),
                  child: TextField(
                    style: TextStyle(
                      color: themeProvider.toggleTextColor(),
                        fontSize: size.width*.04
                    ),
                    onSubmitted: (val){
                      setState(()=>_isLoading=true);
                      Map map = {"search": "${val.toLowerCase()}"};
                      apiProvider.getCategoryProducts(map).then((value){
                        setState(()=>_isLoading=false);
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      prefixIcon: Icon(Icons.search,color: Colors.grey),
                      hintText: 'Search Product',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: size.width*.045
                    ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none
                      ),
                    ),
                    autofocus: true,
                  ),
                ),
              ),

              InkWell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 2),
                  child: Text('Cancel',style: TextStyle(color: Colors.grey,fontSize: size.width*.04)),
                ),
                onTap: (){
                  apiProvider.categoryProductModel=null;
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.all(Radius.circular(10)),
              )
            ],
          ),
        ),
      ),
      body: _bodyUI(size, themeProvider, apiProvider),
    );
  }

  Widget  _bodyUI(Size size, ThemeProvider themeProvider, APIProvider apiProvider)=> _isLoading
      ?Center(child: threeBounce(themeProvider))
      : apiProvider.categoryProductModel==null
      ? Center(child: Text('Search Product',style: TextStyle(color: themeProvider.toggleTextColor())))
      : apiProvider.categoryProductModel.content.isEmpty?Center(child: Text('No Product Found!',
      style: TextStyle(color: themeProvider.toggleTextColor())))
      : Container(
    // height: size.height,
    color: themeProvider.togglePageBgColor(),
    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .71,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
      ),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: apiProvider.categoryProductModel.content.length,
      itemBuilder: (context, index){
        return InkWell(
            onTap: (){
              print(apiProvider.categoryProductModel.content[index].id);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                productId: apiProvider.categoryProductModel.content[index].id,
                categoryId: apiProvider.categoryProductModel.content[index].categoryId,
              )));
            },
            child: ProductCartTile(index: index,productsModel: apiProvider.categoryProductModel));
      },
    ),
  );
}
