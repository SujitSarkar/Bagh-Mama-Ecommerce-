import 'package:bagh_mama/pages/filter_subcategory_product.dart';
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
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  bool _isFiltered=false;

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
            onPressed: ()async {
              _isFiltered = await Navigator.push(context, MaterialPageRoute(builder: (context)=>FilterSubcategoryProduct()));
              print(_isFiltered);
            },
            splashRadius: size.width*.06,
          ),

          PopupMenuButton<int>(
            key: _key,
            icon: Icon(FontAwesomeIcons.slidersH,size: size.width*.05,),
            onSelected: (int val){
              print('Selected: $val');
            },
            itemBuilder: (context) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem(child: Text('New',style: _menuItemTextStyle(themeProvider,size)), value: 1,),
                PopupMenuItem(child: Text('Popular',style: _menuItemTextStyle(themeProvider,size)), value: 2),
                PopupMenuItem(child: Text('Price Low to High',style: _menuItemTextStyle(themeProvider,size)), value: 4),
                PopupMenuItem(child: Text('Price High to Low',style: _menuItemTextStyle(themeProvider,size)), value: 3),
                PopupMenuItem(child: Text('Discount Low to High',style: _menuItemTextStyle(themeProvider,size)), value: 6),
                PopupMenuItem(child: Text('Discount High to Low',style: _menuItemTextStyle(themeProvider,size)), value: 5),
              ];
            },
            tooltip: 'Sort Product',
            color: themeProvider.whiteBlackToggleColor(),
            offset: Offset(0,size.width*.075),
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

  TextStyle _menuItemTextStyle(ThemeProvider themeProvider,Size size)=> TextStyle(
    color: themeProvider.toggleTextColor(),
    fontSize: size.width*.04,
    fontWeight: FontWeight.w500,
  );

  // void _showFilterModal(ThemeProvider themeProvider, Size size){
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (_){
  //         return Container(
  //           color: themeProvider.whiteBlackToggleColor(),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Padding(
  //                     padding: EdgeInsets.only(left: size.width*.03),
  //                     child: Text('Filter Product',style: _menuItemTextStyle(themeProvider, size)),
  //                   ),
  //                   IconButton(icon: Icon(Icons.cancel_outlined,color: Colors.grey,),
  //                       onPressed: ()=>Navigator.pop(context))
  //                 ],
  //               ),
  //               Expanded(
  //                 child: ListView(
  //                   children: [
  //                     ///Min Max Field
  //                     Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: size.width*.03),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Container(
  //                             width: size.width*.3,
  //                             child: TextField(
  //                               decoration: boxFormDecoration(size).copyWith(
  //                                 labelText: 'min price',
  //                                 contentPadding: EdgeInsets.symmetric(vertical: size.width*.02,horizontal: size.width*.02), //Change this value to custom as you like
  //                                 isDense: true,
  //                               ),
  //                             ),
  //                           ),
  //                           Container(
  //                             width: size.width*.3,
  //                             child: TextField(
  //                               decoration: boxFormDecoration(size).copyWith(
  //                                 labelText: 'max price',
  //                                 contentPadding: EdgeInsets.symmetric(vertical: size.width*.02,horizontal: size.width*.02), //Change this value to custom as you like
  //                                 isDense: true,
  //                               ),
  //                             ),
  //                           ),
  //                           Container(
  //                             width: size.width*.3,
  //                             height: size.width*.095,
  //                             decoration: BoxDecoration(
  //                                 color: themeProvider.fabToggleBgColor(),
  //                                 borderRadius: BorderRadius.all(Radius.circular(5))
  //                             ),
  //                             child: TextButton(
  //                               style: TextButton.styleFrom(
  //                                 primary: Colors.white,
  //                               ),
  //                               child: Text('Apply',style: TextStyle(fontSize: size.width*.04),),
  //                               onPressed: (){},
  //                             ),
  //                           )
  //
  //                         ],
  //                       ),
  //                     ),
  //
  //                     ///Availability
  //                     Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: size.width*.03, vertical: size.width*.03),
  //                       child: Text('Availability',style: TextStyle(color: Colors.grey,fontSize: size.width*.04),),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //
  //             ],
  //           ),
  //         );
  //       }
  //   );
  // }
}
