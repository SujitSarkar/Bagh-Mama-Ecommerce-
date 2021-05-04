import 'package:bagh_mama/pages/product_details_page.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/screens/cart_screen.dart';
import 'package:bagh_mama/variables/color_variables.dart';
import 'package:bagh_mama/widget/category_product_cart_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SubcategoryProductList extends StatefulWidget {
  @override
  _SubcategoryProductListState createState() => _SubcategoryProductListState();
}

class _SubcategoryProductListState extends State<SubcategoryProductList> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.togglePageBgColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text('Subcategory List',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
            fontSize: size.width*.045
          ),),
        actions: [
          IconButton(
              icon: Icon(FontAwesomeIcons.filter,size: size.width*.05,),
              onPressed: (){},
            splashRadius: size.width*.06,
          ),
          IconButton(
              icon: Icon(FontAwesomeIcons.slidersH,size: size.width*.05,),
              onPressed: (){},
            splashRadius: size.width*.06,
          ),
          Padding(
            padding: EdgeInsets.only(top: 19,bottom:9,right: 15,left: 15),
            child: InkWell(
              child: Stack(children:[
                Icon(FontAwesomeIcons.shoppingCart,color: Colors.grey,size: size.width*.06,),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(size.width*.007),
                    decoration: BoxDecoration(
                        color: CColor.lightThemeColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Text('9+',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: size.width*.02,fontWeight: FontWeight.w500,color: Colors.white),),
                  ),
                )
              ] ),
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen())),
            ),
          )
        ],
      ),
      body: _bodyUI(size, themeProvider),
    );
  }

  Widget  _bodyUI(Size size, ThemeProvider themeProvider)=>Container(
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
      itemCount: 50,
      itemBuilder: (context, index){
        return InkWell(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails())),
            child: ProductCartTile(index: index,));
      },
    ),
  );
}
