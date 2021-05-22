import 'package:bagh_mama/pages/no_internet_page.dart';
import 'package:bagh_mama/pages/product_details_page.dart';
import 'package:bagh_mama/pages/search_page.dart';
import 'package:bagh_mama/pages/subcategory_product_list.dart';
import 'package:bagh_mama/provider/api_provider.dart';
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
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  TabController _controller;
  int _tabIndex=0;
  int _counter=0;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = TabController(length: 7, vsync: this);
  // }

  _customInit(ThemeProvider themeProvider,APIProvider apiProvider)async{
    setState(()=>_counter++);
    themeProvider.checkConnectivity();
    if(apiProvider.productCategoriesModel==null) await apiProvider.getProductCategories();
    _controller = TabController(length: apiProvider.productCategoryList.length, vsync: this);
    if(apiProvider.networkImageList.isEmpty) await apiProvider.getBannerImageList();
    if(apiProvider.productsModel==null) await apiProvider.getProducts();
    if(apiProvider.contactInfoModel==null) await apiProvider.getContactInfo();

    final SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getString('username')!=null){
      if(apiProvider.userInfoModel==null){
        await apiProvider.getUserInfo(pref.getString('username'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    if(themeProvider.internetConnected && _counter==0) _customInit(themeProvider,apiProvider);

    return themeProvider.internetConnected? Scaffold(
      backgroundColor: themeProvider.toggleBgColor(),
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: themeProvider.toggleBgColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey
        ),
        title: Container(
          width: size.width,
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage())),
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
                        child: Text('9+',
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

        bottom: apiProvider.productCategoryList.isNotEmpty? TabBar(
          onTap: (covariant){
            setState(()=> _tabIndex = covariant);
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
            child: threeBounce(themeProvider), preferredSize: Size.fromHeight(50.0)),
      ),

      body: _tabIndex==0? _bodyUI_1(size,themeProvider,apiProvider):_bodyUI_2(size, themeProvider),
    ):Scaffold(body: NoInternet(),);
  }

  Widget _bodyUI_1(Size size,ThemeProvider themeProvider,APIProvider apiProvider)=> ListView(
    children: [
      SizedBox(height: size.width*.04),
      ///Image Slider

      apiProvider.networkImageList.isEmpty
          ?Center(child: threeBounce(themeProvider))
          :Container(
        margin: EdgeInsets.symmetric(horizontal: size.width*.03),
        height: size.height*.18,
        width: size.width,
        color: Colors.grey,
        child: Carousel(
          boxFit: BoxFit.cover,
          dotSize: 0.0,
          autoplayDuration: Duration(seconds: 7),
          dotIncreaseSize: 0.0,
          dotBgColor: Colors.transparent,
          // dotColor: Colors.green,
          // dotIncreasedColor: Colors.red,
          //images: apiProvider.networkImageList,
          images: apiProvider.networkImageList,
        ),
      ),
      SizedBox(height: size.width*.04),

      ///Deals of the day
      //header
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text('Deals of the day',
            style: TextStyle(color: Colors.grey,fontSize: size.width*.05)),
      ),
      SizedBox(height: size.width*.03),
      Container(
        height: size.width*.5,
        //color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: apiProvider.productsModel==null? Center(child: threeBounce(themeProvider)): ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: apiProvider.productsModel.content.length,
          itemBuilder: (context, index)=>InkWell(
            onTap: (){
              print(apiProvider.productsModel.content[index].id);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                productId: apiProvider.productsModel.content[index].id,
              )));
            },
              child: HomeProductCartTile(index: index,productsModel: apiProvider.productsModel,)),
        ),
      ),
      SizedBox(height: size.width*.08),


      ///New Arrivals
      //header
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text('New Arrivals',
            style: TextStyle(color: Colors.grey,fontSize: size.width*.05)),
      ),
      SizedBox(height: size.width*.03),
      Container(
        height: size.width*.5,
        //color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: apiProvider.productsModel==null? Center(child: threeBounce(themeProvider)): ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: apiProvider.productsModel.content.length,
          itemBuilder: (context, index)=>InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                  productId: apiProvider.productsModel.content[index].id,
                )));
              },
              child: HomeProductCartTile(index: index,productsModel: apiProvider.productsModel,)),
        ),
      ),
      SizedBox(height: size.width*.08),

    ],
  );

  Widget _bodyUI_2(Size size, ThemeProvider themeProvider)=> ListView(
    children: [
      SizedBox(height: size.width*.03),
      ///Banner Image
      Container(
        height: size.width * .4,
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Image.network('https://resources.matcha-jp.com/resize/720x2000/2020/04/23-101958.jpeg',fit: BoxFit.fitWidth,),
        ),
      ),
      SizedBox(height: size.width*.03),

      ///Subcategory Section
      Container(
        height: size.width*.35,
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index)=>InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SubcategoryProductList()));
              },
              child: RoundSubcategoryTile(index: index)),
        ),
      ),

      Container(
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
          itemCount: 8,
          itemBuilder: (context, index){
              return InkWell(
                onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails()));
                },
                  child: ProductCartTile(index: index,));
          },
        ),
      )
    ],
  );
}


