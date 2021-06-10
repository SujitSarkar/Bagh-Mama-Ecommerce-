import 'package:bagh_mama/pages/all_product_list.dart';
import 'package:bagh_mama/pages/new_arrival_product_list.dart';
import 'package:bagh_mama/pages/no_internet_page.dart';
import 'package:bagh_mama/pages/popular_product_list.dart';
import 'package:bagh_mama/pages/product_details_page.dart';
import 'package:bagh_mama/pages/search_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/sqlite_database_helper.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/screens/cart_screen.dart';
import 'package:bagh_mama/variables/color_variables.dart';
import 'package:bagh_mama/variables/public_data.dart';
import 'package:bagh_mama/widget/category_product_cart_tile.dart';
import 'package:bagh_mama/widget/home_product_cart_tile.dart';
import 'package:bagh_mama/widget/navigation_drawer.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:bagh_mama/widget/round_subcategory_tile.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin,TickerProviderStateMixin{
  TabController _controller;
  int _tabIndex=0;
  int _counter=0;
  bool _isLoading=false;
  // @override
  // void initState() {
  //   super.initState();
  //   _controller = TabController(length: 7, vsync: this);
  // }

  Future<void> _customInit(ThemeProvider themeProvider,APIProvider apiProvider,DatabaseHelper databaseHelper)async{
    setState(()=>_counter++);
    themeProvider.checkConnectivity();
    if(apiProvider.allCategoryList.isEmpty) await apiProvider.getProductCategories();
    _controller = TabController(length: apiProvider.mainCategoryList.length, vsync: this);
    if(apiProvider.mainCategoryWithId.isEmpty) await apiProvider.getMainCategoryWithId();
    if(apiProvider.networkImageList.isEmpty) await apiProvider.getBannerImageList();
    if(apiProvider.allProductModel==null) await apiProvider.getAllProducts();
    if(apiProvider.newArrivalProductModel==null) await apiProvider.getNewArrivalProducts();
    if(apiProvider.popularProductModel==null) await apiProvider.getPopularProducts();
    if(apiProvider.socialContactInfo==null) await apiProvider.getSocialContactInfo();
    await databaseHelper.getCartList();
  }
  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);
    if(themeProvider.internetConnected && _counter==0) _customInit(themeProvider,apiProvider,databaseHelper);

    return themeProvider.internetConnected? Scaffold(
      backgroundColor: themeProvider.toggleBgColor(),
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: themeProvider.toggleBgColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey
        ),
        ///Search Bar
        title: Container(
          width: size.width,
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  apiProvider.categoryProductModel=null;
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage()));
                },
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: Container(
                  width: size.width*.66,
                  height: 40,
                  // color: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: Border.all(width: 1,color: Colors.grey[400])
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search,color: Colors.grey),
                      SizedBox(width: size.width*.02),
                      Text('Search Product',style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        fontSize: size.width*.045
                      ),),
                    ],
                  ),
                ),
              ),

              InkWell(
                  child: Stack(children:[
                    Icon(FontAwesomeIcons.shoppingCart,color: Colors.grey,),
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
                        child: Text('${databaseHelper.cartList.length>9?'9+':databaseHelper.cartList.length}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: size.width*.02,fontWeight: FontWeight.w500,color: Colors.white),),
                      ),
                    )
                  ] ),
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen())),
              )
            ],
          ),
        ),

        bottom: apiProvider.mainCategoryList.isNotEmpty? TabBar(
          onTap: (covariant)async{
            setState(()=> _tabIndex = covariant);
            if(_tabIndex!=0){
              apiProvider.updateSubCategoryList(apiProvider.mainCategoryList[_tabIndex]);
              ///Get Category Product
              String categoryId;
              setState(()=>_isLoading=true);
              for(int i=0;i<apiProvider.mainCategoryWithId.length;i++){
                if(apiProvider.mainCategoryWithId[i].main==apiProvider.mainCategoryList[_tabIndex]){
                  categoryId= apiProvider.mainCategoryWithId[i].id.toString();
                }
              }
              Map map = {
                "category_id": "$categoryId",
                "fetch_scope": "main"
              };
              // print(categoryId);
              await apiProvider.getCategoryProducts(map).then((value){
                setState(()=>_isLoading=false);
              });
            }
          },
          isScrollable: true,
          controller: _controller,
         indicator: BoxDecoration(
           border: Border(
             bottom: BorderSide(
               width: 3.5,
               color: themeProvider.orangeWhiteToggleColor(),)
           )
         ),
          //indicatorColor: Colors.green,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: PublicData.categoryWidgetList(apiProvider,themeProvider),
        ):PreferredSize(
            child: Container(), preferredSize: Size.fromHeight(50.0)),
      ),

      body: _tabIndex==0? _bodyUI_1(size,themeProvider,apiProvider,databaseHelper):_bodyUI_2(size, themeProvider,apiProvider),
    ):Scaffold(body: NoInternet());
  }

  Widget _bodyUI_1(Size size,ThemeProvider themeProvider,APIProvider apiProvider, DatabaseHelper databaseHelper)=>
      apiProvider.networkImageList.isEmpty || apiProvider.newArrivalProductModel==null ||
           apiProvider.popularProductModel==null || apiProvider.allProductModel==null
          ?Center(child: threeBounce(themeProvider))
          :Container(
    color: themeProvider.togglePageBgColor(),
    child: RefreshIndicator(
      backgroundColor: themeProvider.togglePageBgColor(),
      onRefresh: ()async{
        await apiProvider.getNewArrivalProducts();
        await apiProvider.getPopularProducts();
        await apiProvider.getAllProducts();
      },
      child: ListView(
        children: [
          SizedBox(height: size.width*.04),
          ///Image Slider
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width*.03),
            height: size.height*.18,
            width: size.width,
            decoration: BoxDecoration(
                color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/placeholder.png'),
                fit: BoxFit.cover
              )
            ),
            child: Carousel(
              boxFit: BoxFit.cover,
              dotSize: 0.0,
              autoplayDuration: Duration(seconds: 7),
              dotIncreaseSize: 0.0,
              dotBgColor: Colors.transparent,
              images: apiProvider.networkImageList,
            ),
          ),
          SizedBox(height: size.width*.08),

          ///New Arrivals
          //header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('New Arrivals',
                    style: TextStyle(color: Colors.grey,fontSize: size.width*.05)),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>NewArrivalProductList()));
                  },
                  child: Text('View All',
                      style: TextStyle(color: themeProvider.fabToggleBgColor(),fontSize: size.width*.04)),
                ),
              ],
            ),
          ),
          SizedBox(height: size.width*.03),
          Container(
            height: size.width*.5,
            //color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: apiProvider.newArrivalProductModel.content.length>50?50
                  :apiProvider.newArrivalProductModel.content.length,
              itemBuilder: (context, index)=>InkWell(
                onTap: (){
                  print(apiProvider.newArrivalProductModel.content[index].id);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                    productId: apiProvider.newArrivalProductModel.content[index].id,
                    categoryId: apiProvider.newArrivalProductModel.content[index].categoryId,
                  )));
                },
                  child: ProductTile(index: index,productsModel: apiProvider.newArrivalProductModel)),
            ),
          ),
          SizedBox(height: size.width*.08),


          ///Popular Products
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Popular Products',
                    style: TextStyle(color: Colors.grey,fontSize: size.width*.05)),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PopularProductList()));
                  },
                  child: Text('View All',
                      style: TextStyle(color: themeProvider.fabToggleBgColor(),fontSize: size.width*.04)),
                ),
              ],
            ),
          ),
          SizedBox(height: size.width*.03),
          Container(
            height: size.width*.5,
            //color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              itemCount: apiProvider.popularProductModel.content.length>50?50
                  :apiProvider.popularProductModel.content.length,
              itemBuilder: (context, index)=>InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                      productId: apiProvider.popularProductModel.content[index].id,
                      categoryId: apiProvider.popularProductModel.content[index].categoryId,
                    )));
                  },
                  child: ProductTile(index: index,productsModel: apiProvider.popularProductModel)),
            ),
          ),
          SizedBox(height: size.width*.08),

          ///All Products
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Just For You',
                    style: TextStyle(color: Colors.grey,fontSize: size.width*.05)),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AllProductList()));
                  },
                  child: Text('View All',
                      style: TextStyle(color: themeProvider.fabToggleBgColor(),fontSize: size.width*.04)),
                ),
              ],
            ),
          ),
          apiProvider.allProductModel==null
              ?Center(child: Container(child: Text('No Product !',
            style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.04),)))
              : Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: .65,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10
              ),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: apiProvider.allProductModel.content.length>50?50
                  :apiProvider.allProductModel.content.length,
              itemBuilder: (context, index){
                return InkWell(
                    onTap: (){},
                    child: ProductCartTile(index: index,productsModel: apiProvider.allProductModel));
              },
            ),
          ),
          SizedBox(height: size.width*.08),

        ],
      ),
    ),
  );

  Widget _bodyUI_2(Size size, ThemeProvider themeProvider,APIProvider apiProvider)=> ListView(
    children: [
      SizedBox(height: size.width*.05),
      ///Subcategory Section
      Container(
        height: size.width*.16,
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: apiProvider.subCategoryList.length,
          itemBuilder: (context, index)=>InkWell(
              onTap: (){
                setState(() {
                  _isLoading=true;
                });
                Map map = {"category_id":"${apiProvider.subCategoryList[index].id}"};
                apiProvider.getCategoryProducts(map).then((value){
                  setState(() {
                    _isLoading=false;
                  });
                });
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>SubcategoryProductList()));
              },
              child: RoundSubcategoryTile(index: index)),
        ),
      ),
      SizedBox(height: size.width*.02),

      _isLoading
          ?Center(child: Padding(
        padding:  EdgeInsets.only(top: 100),
            child: threeBounce(themeProvider),
          ))
          : apiProvider.categoryProductModel==null
          ? Center(child: Padding(
            padding:  EdgeInsets.only(top: 100),
            child: Text('Select SubCategory',style: TextStyle(color: themeProvider.toggleTextColor())),
          ))
          : apiProvider.categoryProductModel.content.isEmpty
          ?Center(child: Padding(
            padding:  EdgeInsets.only(top: 100),
            child: Text('No Product',style: TextStyle(color: themeProvider.toggleTextColor())),
          ))
          : Container(
        // height: size.height,
        color: themeProvider.togglePageBgColor(),
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: .65,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10
        ),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: apiProvider.categoryProductModel.content.length,
          itemBuilder: (context, index){
              return InkWell(
                onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                      productId: apiProvider.categoryProductModel.content[index].id,
                      categoryId: apiProvider.categoryProductModel.content[index].categoryId,
                    )));
                },
                  child: ProductCartTile(index: index,productsModel: apiProvider.categoryProductModel));
          },
        ),
      )
    ],
  );
}