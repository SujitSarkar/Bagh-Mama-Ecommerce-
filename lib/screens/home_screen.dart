import 'package:bagh_mama/pages/all_product_list.dart';
import 'package:bagh_mama/pages/campaign_list_page.dart';
import 'package:bagh_mama/pages/campaign_product_list.dart';
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
import 'package:bagh_mama/widget/campaigns_date_tile.dart';
import 'package:bagh_mama/widget/category_product_cart_tile.dart';
import 'package:bagh_mama/widget/home_product_cart_tile.dart';
import 'package:bagh_mama/widget/navigation_drawer.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:bagh_mama/widget/round_subcategory_tile.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, TickerProviderStateMixin {
  TabController _controller;
  int _tabIndex = 0;
  int _counter = 0;
  bool _isLoading = false;
  Offset position = Offset(285, 356);
  final ScrollController _scrollController = ScrollController();

  AnimationController controller;
  Animation<double> animationSize;

  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    animationSize = Tween<double>(begin: 30.0, end: 40.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  Future<void> _customInit(ThemeProvider themeProvider, APIProvider apiProvider,
      DatabaseHelper databaseHelper) async {
    setState(() {
      _counter++;
      _isLoading = true;
    });
    //themeProvider.checkConnectivity();
    if (apiProvider.allCategoryList.isEmpty)
      await apiProvider.getProductCategories();
    _controller =
        TabController(length: apiProvider.mainCategoryList.length, vsync: this);
    if (apiProvider.mainCategoryWithId.isEmpty)
      await apiProvider.getMainCategoryWithId();
    if (apiProvider.networkImageList.isEmpty)
      await apiProvider.getBannerImageList();

    if (apiProvider.newArrivalProductModel == null)
      await apiProvider
          .getNewArrivalProducts({"product_limit": 51, "sort": "2"});
    if (apiProvider.popularProductModel == null)
      await apiProvider.getPopularProducts({"product_limit": 51, "sort": "1"});
    if (apiProvider.allProductModel == null)
      await apiProvider.getAllProducts({"product_limit": 51});

    setState(() => _isLoading = false);
    await databaseHelper.getCartList();
    if (apiProvider.campaignsDateModel == null)
      await apiProvider.getCampaignsDate();
    if (apiProvider.socialContactInfo == null)
      await apiProvider.getSocialContactInfo();
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
    if (themeProvider.internetConnected && _counter == 0)
      _customInit(themeProvider, apiProvider, databaseHelper);

    return themeProvider.internetConnected
        ? Stack(
            children: [
              Scaffold(
                backgroundColor: themeProvider.toggleBgColor(),
                drawer: NavigationDrawer(),
                appBar: AppBar(
                  backgroundColor: themeProvider.toggleBgColor(),
                  elevation: 0.0,
                  iconTheme: IconThemeData(color: Colors.grey),

                  ///Search Bar
                  title: Container(
                    width: size.width,
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            apiProvider.categoryProductModel = null;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage()));
                          },
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Container(
                            width: size.width * .66,
                            height: 40,
                            // color: Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                border: Border.all(
                                    width: 1, color: Colors.grey[400])),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey),
                                SizedBox(width: size.width * .02),
                                Text(
                                  'Search Product',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: size.width * .045),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          child: Stack(children: [
                            Icon(
                              FontAwesomeIcons.shoppingCart,
                              color: Colors.grey,
                            ),
                            Positioned(
                              top: 0.0,
                              right: 0.0,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(size.width * .007),
                                decoration: BoxDecoration(
                                    color: CColor.lightThemeColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Text(
                                  '${databaseHelper.cartList.length > 9 ? '9+' : databaseHelper.cartList.length}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: size.width * .02,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          ]),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartScreen())),
                        )
                      ],
                    ),
                  ),

                  ///Tab Bar
                  bottom: apiProvider.mainCategoryList.isNotEmpty
                      ? TabBar(
                          onTap: (covariant) async {
                            setState(() => _tabIndex = covariant);
                            if (_tabIndex != 0) {
                              apiProvider.updateSubCategoryList(
                                  apiProvider.mainCategoryList[_tabIndex]);

                              ///Get Category Product
                              String categoryId;
                              setState(() => _isLoading = true);
                              for (int i = 0;
                                  i < apiProvider.mainCategoryWithId.length;
                                  i++) {
                                if (apiProvider.mainCategoryWithId[i].main ==
                                    apiProvider.mainCategoryList[_tabIndex]) {
                                  categoryId = apiProvider
                                      .mainCategoryWithId[i].id
                                      .toString();
                                }
                              }
                              Map map = {
                                "category_id": "$categoryId",
                                "fetch_scope": "main"
                              };
                              // print(categoryId);
                              await apiProvider
                                  .getCategoryProducts(map)
                                  .then((value) {
                                setState(() => _isLoading = false);
                              });
                            }
                          },
                          isScrollable: true,
                          controller: _controller,
                          indicator: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            width: 3.5,
                            color: themeProvider.orangeWhiteToggleColor(),
                          ))),
                          //indicatorColor: Colors.green,
                          indicatorSize: TabBarIndicatorSize.label,
                          physics: BouncingScrollPhysics(),
                          tabs: PublicData.categoryWidgetList(
                              apiProvider, themeProvider),
                        )
                      : PreferredSize(
                          child: Container(),
                          preferredSize: Size.fromHeight(50.0)),
                ),
                body: _tabIndex == 0
                    ? _bodyUI_1(
                        size, themeProvider, apiProvider, databaseHelper)
                    : _bodyUI_2(size, themeProvider, apiProvider),
              ),
              apiProvider.campaignsDateModel != null
                  ? Positioned(
                      left: position.dx,
                      top: position.dy,
                      child: Draggable(
                          feedback: Container(
                            height: animationSize.value,
                            width: animationSize.value,
                            decoration: BoxDecoration(
                                //borderRadius: BorderRadius.all(Radius.circular(40)),
                                image: DecorationImage(
                              image: AssetImage('assets/logo_512.png'),
                              fit: BoxFit.fitWidth,
                            )),
                          ),
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CampaignsListPage())),
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      //borderRadius: BorderRadius.all(Radius.circular(40)),
                                      image: DecorationImage(
                                          image:
                                              AssetImage('assets/logo_512.png'),
                                          fit: BoxFit.fitWidth)),
                                ),
                                Text(
                                  'Campaigns',
                                  style: TextStyle(
                                      color: themeProvider
                                          .orangeWhiteToggleColor(),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          childWhenDragging: Container(),
                          onDragEnd: (details) {
                            setState(() {
                              position = details.offset;
                            });
                            // print(position);
                            // print(position.dx);
                            // print(position.dy);
                          }))
                  : Container(),
            ],
          )
        : Scaffold(body: NoInternet());
  }

  Widget _bodyUI_1(Size size, ThemeProvider themeProvider,
          APIProvider apiProvider, DatabaseHelper databaseHelper) =>
      _isLoading
          ? Center(child: threeBounce(themeProvider))
          : Container(
              color: themeProvider.togglePageBgColor(),
              child: NotificationListener(
                onNotification: (scrollNotification) {
                  if (_scrollController.position.userScrollDirection ==
                      ScrollDirection.reverse) {
                    setState(() {
                      position = Offset(320, 356);
                    });
                  } else if (_scrollController.position.userScrollDirection ==
                      ScrollDirection.forward) {
                    setState(() {
                      position = Offset(285, 356);
                    });
                  }
                  return true;
                },
                child: RefreshIndicator(
                  color: themeProvider.fabToggleBgColor(),
                  backgroundColor: themeProvider.togglePageBgColor(),
                  onRefresh: () async {
                    await apiProvider.getNewArrivalProducts(
                        {"product_limit": 51, "sort": "2"});
                    await apiProvider
                        .getPopularProducts({"product_limit": 51, "sort": "1"});
                    await apiProvider.getAllProducts({"product_limit": 51});
                  },
                  child: ListView(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: size.width * .04),

                      ///Image Slider
                      apiProvider.networkImageList.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: size.width * .03),
                              height: size.height * .18,
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: AssetImage('assets/logo_512.png'),
                                      fit: BoxFit.contain)),
                              child: Carousel(
                                boxFit: BoxFit.cover,
                                dotSize: 3.0,
                                autoplayDuration: Duration(seconds: 7),
                                dotIncreaseSize: 3.0,
                                dotBgColor: Colors.transparent,
                                dotColor: Colors.white,
                                dotIncreasedColor: Colors.deepOrange,
                                dotPosition: DotPosition.bottomCenter,
                                images: apiProvider.networkImageList,
                              ),
                            )
                          : Center(
                              child: Text('No Banner !',
                                  style: TextStyle(
                                      color: themeProvider.toggleTextColor(),
                                      fontSize: size.width * .04))),
                      SizedBox(height: size.width * .08),

                      ///New Arrivals
                      //header
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('New Arrivals',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: size.width * .05)),
                            InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NewArrivalProductList())),
                              child: Text('View All',
                                  style: TextStyle(
                                      color: themeProvider.fabToggleBgColor(),
                                      fontSize: size.width * .04)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.width * .03),
                      apiProvider.newArrivalProductModel != null
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: .65,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: apiProvider.newArrivalProductModel
                                            .content.length >
                                        6
                                    ? 6
                                    : apiProvider
                                        .newArrivalProductModel.content.length,
                                itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      print(apiProvider.newArrivalProductModel
                                          .content[index].id);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetails(
                                                      productId: apiProvider
                                                          .newArrivalProductModel
                                                          .content[index]
                                                          .id,
                                                      categoryId: apiProvider
                                                          .newArrivalProductModel
                                                          .content[index]
                                                          .categoryId,
                                                      isCampaign: false)));
                                      print(apiProvider.newArrivalProductModel
                                          .content[index].id);
                                    },
                                    child: ProductTile(
                                        index: index,
                                        productsModel: apiProvider
                                            .newArrivalProductModel)),
                              ),
                            )
                          : Center(
                              child: Text('No Product !',
                                  style: TextStyle(
                                      color: themeProvider.toggleTextColor(),
                                      fontSize: size.width * .04))),
                      SizedBox(height: size.width * .08),

                      ///Popular Products
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Popular Products',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: size.width * .05)),
                            InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PopularProductList())),
                              child: Text('View All',
                                  style: TextStyle(
                                      color: themeProvider.fabToggleBgColor(),
                                      fontSize: size.width * .04)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.width * .03),
                      apiProvider.popularProductModel != null
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: .65,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: apiProvider.popularProductModel
                                            .content.length >
                                        6
                                    ? 6
                                    : apiProvider
                                        .popularProductModel.content.length,
                                itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetails(
                                                      productId: apiProvider
                                                          .popularProductModel
                                                          .content[index]
                                                          .id,
                                                      categoryId: apiProvider
                                                          .popularProductModel
                                                          .content[index]
                                                          .categoryId,
                                                      isCampaign: false)));
                                    },
                                    child: ProductTile(
                                        index: index,
                                        productsModel:
                                            apiProvider.popularProductModel)),
                              ),
                            )
                          : Center(
                              child: Text('No Product !',
                                  style: TextStyle(
                                      color: themeProvider.toggleTextColor(),
                                      fontSize: size.width * .04))),
                      SizedBox(height: size.width * .08),

                      ///Just For You
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Just For You',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: size.width * .05)),
                      ),
                      apiProvider.allProductModel != null
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: .65,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount:
                                    apiProvider.allProductModel.content.length >
                                            102
                                        ? 102
                                        : apiProvider
                                            .allProductModel.content.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails(
                                                        productId: apiProvider
                                                            .allProductModel
                                                            .content[index]
                                                            .id,
                                                        categoryId: apiProvider
                                                            .allProductModel
                                                            .content[index]
                                                            .categoryId,
                                                        isCampaign: false)));
                                      },
                                      child: ProductCartTile(
                                          index: index,
                                          productsModel:
                                              apiProvider.allProductModel));
                                },
                              ),
                            )
                          : Center(
                              child: Container(
                                  child: Text('No Product !',
                                      style: TextStyle(
                                          color:
                                              themeProvider.toggleTextColor(),
                                          fontSize: size.width * .04)))),
                      SizedBox(height: size.width * .01),
                      apiProvider.allProductModel != null
                          ? Center(
                              child: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllProductList())),
                                child: Text('View All',
                                    style: TextStyle(
                                        color: themeProvider.fabToggleBgColor(),
                                        fontSize: size.width * .04)),
                              ),
                            )
                          : Container(),
                      SizedBox(height: size.width * .08),
                    ],
                  ),
                ),
              ),
            );

  Widget _bodyUI_2(
          Size size, ThemeProvider themeProvider, APIProvider apiProvider) =>
      NotificationListener(
        onNotification: (scrollNotification) {
          if (_scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
            setState(() {
              position = Offset(320, 356);
            });
          } else if (_scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
            setState(() {
              position = Offset(285, 356);
            });
          }
          return true;
        },
        child: ListView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: size.width * .05),

            ///Subcategory Section
            Container(
              height: size.width * .16,
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: apiProvider.subCategoryList.length,
                itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      setState(() {
                        _isLoading = true;
                      });
                      Map map = {
                        "category_id":
                            "${apiProvider.subCategoryList[index].id}"
                      };
                      apiProvider.getCategoryProducts(map).then((value) {
                        setState(() {
                          _isLoading = false;
                        });
                      });
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>SubcategoryProductList()));
                    },
                    child: RoundSubcategoryTile(index: index)),
              ),
            ),
            SizedBox(height: size.width * .02),

            _isLoading
                ? Center(
                    child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: threeBounce(themeProvider),
                  ))
                : apiProvider.categoryProductModel == null
                    ? Center(
                        child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Text('Select SubCategory',
                            style: TextStyle(
                                color: themeProvider.toggleTextColor())),
                      ))
                    : apiProvider.categoryProductModel.content.isEmpty
                        ? Center(
                            child: Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Text('No Product',
                                style: TextStyle(
                                    color: themeProvider.toggleTextColor())),
                          ))
                        : Container(
                            color: themeProvider.togglePageBgColor(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: .65,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: apiProvider
                                  .categoryProductModel.content.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetails(
                                                      productId: apiProvider
                                                          .categoryProductModel
                                                          .content[index]
                                                          .id,
                                                      categoryId: apiProvider
                                                          .categoryProductModel
                                                          .content[index]
                                                          .categoryId,
                                                      isCampaign: false)));
                                    },
                                    child: ProductCartTile(
                                        index: index,
                                        productsModel:
                                            apiProvider.categoryProductModel));
                              },
                            ),
                          )
          ],
        ),
      );
}
