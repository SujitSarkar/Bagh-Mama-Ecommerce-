import 'package:bagh_mama/checkout_pages/quick_buy_page.dart';
import 'package:bagh_mama/models/cart_model.dart';
import 'package:bagh_mama/pages/customer_review_list.dart';
import 'package:bagh_mama/pages/product_question_list.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/sqlite_database_helper.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/screens/cart_screen.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:bagh_mama/widget/home_product_cart_tile.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:bagh_mama/widget/product_review_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';

import 'login_page.dart';

// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {
  int productId;
  int categoryId;
  bool isCampaign;
  ProductDetails({this.productId, this.categoryId, this.isCampaign});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool _isTapped = false;
  int _pQuantity = 1;
  bool _isAdded = false;
  double _starRating;
  int _sizeIndex, _colorIndex, _counter = 0;
  String _selectedColor = '', _selectedSize = '';
  String _productImage;
  bool _isLoading = true;
  TextEditingController _ratingComment = TextEditingController();
  SharedPreferences _sharedPreferences;

  void _customInit(
      APIProvider apiProvider, DatabaseHelper databaseHelper) async {
    setState(() => _counter++);
    _sharedPreferences = await SharedPreferences.getInstance();
    if (databaseHelper.cartList.isEmpty) await databaseHelper.getCartList();

    await apiProvider.getProductInfo(widget.productId).then((value) async {
      await apiProvider.getRelatedProducts(widget.categoryId).then((value) {
        setState(() {
          _productImage = apiProvider.productInfoModel.content.thumnailImage;
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);
    if (_counter == 0) _customInit(apiProvider, databaseHelper);
    return Scaffold(
      backgroundColor: themeProvider.whiteBlackToggleColor(),
      resizeToAvoidBottomInset: false,
      body: _isLoading
          ? Center(child: threeBounce(themeProvider))
          : SafeArea(
              child: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        iconTheme: IconThemeData(color: Colors.grey),
                        actions: [
                          Stack(alignment: Alignment.center, children: [
                            IconButton(
                              icon: Icon(FontAwesomeIcons.shoppingCart,
                                  size: size.width * .06),
                              color: Colors.grey,
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CartScreen())),
                              splashRadius: size.width * .07,
                            ),
                            Positioned(
                              top: 8.0,
                              right: 5.0,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(size.width * .007),
                                decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Text(
                                  '${databaseHelper.cartList.length > 9 ? '9+' : databaseHelper.cartList.length}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: size.width * .024,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          ]),
                          IconButton(
                            icon: Icon(
                              Icons.ios_share,
                              color: Colors.grey,
                            ),
                            onPressed: () {},
                            splashRadius: size.width * .07,
                          ),
                        ],
                        expandedHeight: size.width * .8,
                        floating: true,
                        pinned: true,
                        snap: true,
                        actionsIconTheme: IconThemeData(opacity: 1),
                        flexibleSpace: Stack(
                          children: <Widget>[
                            Positioned.fill(
                                child: Container(
                              width: size.width,
                              height: size.width * .8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // image: DecorationImage(
                                //   image: NetworkImage(_productImage),
                                // )
                              ),
                              child: CachedNetworkImage(
                                imageUrl: _productImage,
                                placeholder: (context, url) =>
                                    threeBounce(themeProvider),
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/logo_512.png',
                                        height: 70,
                                        width: 70,
                                        fit: BoxFit.cover),
                                height: size.width * .8,
                                width: size.width,
                                fit: BoxFit.contain,
                              ),
                            ))
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: new EdgeInsets.all(10.0),
                        sliver: new SliverList(
                          delegate: new SliverChildListDelegate([
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                apiProvider.productInfoModel.content.priceStock
                                        .stock
                                        .toString()
                                        .isNotEmpty
                                    ? Text(
                                        'In Stock',
                                        style: TextStyle(
                                            fontSize: size.width * .045,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.green),
                                      )
                                    : Text(
                                        'Out Of Stock',
                                        style: TextStyle(
                                            fontSize: size.width * .045,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xffF0A732)),
                                      ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Add to wishlsist',
                                      style: TextStyle(
                                          fontSize: size.width * .04,
                                          color:
                                              themeProvider.toggleTextColor()),
                                    ),
                                    // SizedBox(width: size.width*.03),
                                    IconButton(
                                      onPressed: () async {
                                        if (_sharedPreferences
                                                .getString('username') !=
                                            null) {
                                          if (!apiProvider.wishListIdList
                                              .contains(widget.productId
                                                  .toString())) {
                                            showLoadingDialog('Adding...');
                                            Map map = {
                                              "user_id": int.parse(
                                                  _sharedPreferences
                                                      .getString('userId')),
                                              "product_id": widget.productId
                                            };
                                            await apiProvider
                                                .addProductToWishlist(map)
                                                .then((value) async {
                                              if (value) {
                                                await apiProvider
                                                    .getUserInfo(
                                                        _sharedPreferences
                                                            .getString(
                                                                'username'))
                                                    .then((value) async {
                                                  await apiProvider
                                                      .getWishListProduct()
                                                      .then((value) {
                                                    closeLoadingDialog();
                                                    setState(() =>
                                                        _isTapped = !_isTapped);
                                                    showSuccessMgs(
                                                        'Product Added to Wishlist');
                                                  });
                                                });
                                              } else {
                                                closeLoadingDialog();
                                                showErrorMgs('Failed !');
                                              }
                                            });
                                          } else
                                            showInfo('Already Added');
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage()));
                                        }
                                      },
                                      icon: Icon(
                                          _isTapped
                                              ? FontAwesomeIcons.solidHeart
                                              : FontAwesomeIcons.heart,
                                          color: Colors.pink),
                                      splashRadius: size.width * .06,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    ];
                  },
                  body: _bodyUI(size, themeProvider, apiProvider),
                ),
              ),
            ),
      floatingActionButton: _floatingActionButton(
          size, themeProvider, databaseHelper, apiProvider),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _bodyUI(
          Size size, ThemeProvider themeProvider, APIProvider apiProvider) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///Product Name
              Text(
                '${apiProvider.productInfoModel.content.name}',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: size.width * .04,
                    color: themeProvider.toggleTextColor(),
                    fontWeight: FontWeight.w500),
              ),
              apiProvider.productInfoModel.content.brand != ''
                  ? SizedBox(height: size.width * .01)
                  : Container(),
              apiProvider.productInfoModel.content.brand != ''
                  ? Text('Brand: ${apiProvider.productInfoModel.content.brand}',
                      style: TextStyle(
                          fontSize: size.width * .04,
                          color: themeProvider.toggleTextColor(),
                          fontWeight: FontWeight.w400))
                  : Container(),
              SizedBox(height: size.width * .03),

              ///Price Row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // apiProvider.productInfoModel.content.discount != 0
                  //     ? Text(
                  //         '${themeProvider.currency}${themeProvider.toggleCurrency((apiProvider.productInfoModel.content.priceStock.price + (apiProvider.productInfoModel.content.priceStock.price) * (apiProvider.productInfoModel.content.discount / 100)).toString())}',
                  //         textAlign: TextAlign.justify,
                  //         style: TextStyle(
                  //             fontSize: size.width * .05,
                  //             color: themeProvider.orangeWhiteToggleColor(),
                  //             fontWeight: FontWeight.bold),
                  //       )
                  //     :
                  Text('${themeProvider.currency}${themeProvider.toggleCurrency(apiProvider.productInfoModel.content.priceStock.price.toString())}',
                          style: TextStyle(
                              fontSize: size.width * .05,
                              color: themeProvider.orangeWhiteToggleColor(),
                              fontWeight: FontWeight.bold)),
                  SizedBox(width: size.width * .02),
                  apiProvider.productInfoModel.content.discount != 0
                      ? Text(
                          '${themeProvider.currency}${themeProvider.toggleCurrency(apiProvider.productInfoModel.content.priceStock.priceChart[0].sP)}',
                          maxLines: 1,
                          style: TextStyle(
                              color: themeProvider.toggleTextColor(),
                              fontSize: size.width * .03,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.lineThrough))
                      : Container()
                ],
              ),
              Divider(height: 5.0, color: Colors.grey, thickness: 0.5),
              SizedBox(height: size.width * .04),

              ///Available Size
              apiProvider.productInfoModel.content.availableSizes.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Available Size:',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: size.width * .04)),
                        Container(
                          // color: Colors.red,
                          height: size.width * .1,
                          width: size.width,
                          padding: EdgeInsets.all(size.width * .01),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: apiProvider.productInfoModel.content
                                  .availableSizes.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _sizeIndex = index;
                                      _selectedSize = apiProvider
                                          .productInfoModel
                                          .content
                                          .availableSizes[_sizeIndex];
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * .02),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: _sizeIndex == index
                                              ? themeProvider
                                                  .orangeWhiteToggleColor()
                                              : Colors.grey,
                                          width: _sizeIndex == index ? 1.5 : 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Text(
                                        apiProvider.productInfoModel.content
                                            .availableSizes[index]
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: size.width * .04,
                                            color: _sizeIndex == index
                                                ? themeProvider
                                                    .orangeWhiteToggleColor()
                                                : themeProvider
                                                    .toggleTextColor())),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                );
                              }),
                        ),
                      ],
                    )
                  : Container(),
              apiProvider.productInfoModel.content.availableSizes.isNotEmpty
                  ? SizedBox(height: size.width * .04)
                  : Container(),

              ///Available Color
              apiProvider.productInfoModel.content.availableColors.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Available Color:',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: size.width * .04)),
                        Container(
                          // color: Colors.red,
                          height: size.width * .1,
                          width: size.width,
                          padding: EdgeInsets.all(size.width * .01),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: apiProvider.productInfoModel.content
                                  .availableColors.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _colorIndex = index;
                                      _productImage = apiProvider
                                          .productInfoModel
                                          .content
                                          .allImages[index];
                                      _selectedColor = apiProvider
                                          .productInfoModel
                                          .content
                                          .availableColors[_colorIndex];
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * .02),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: _colorIndex == index
                                              ? themeProvider
                                                  .orangeWhiteToggleColor()
                                              : Colors.grey,
                                          width:
                                              _colorIndex == index ? 1.5 : 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Text(
                                        apiProvider.productInfoModel.content
                                            .availableColors[index]
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: size.width * .04,
                                            color: _colorIndex == index
                                                ? themeProvider
                                                    .orangeWhiteToggleColor()
                                                : themeProvider
                                                    .toggleTextColor())),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                );
                              }),
                        ),
                      ],
                    )
                  : Container(),
              apiProvider.productInfoModel.content.description != ''
                  ? SizedBox(height: size.width * .04)
                  : Container(),

              ///Product Description
              apiProvider.productInfoModel.content.description != ''
                  ? Text('Product Full Description',
                      style: TextStyle(
                          color: Colors.grey, fontSize: size.width * .04))
                  : Container(),
              apiProvider.productInfoModel.content.description != ''
                  ? Html(
                      data:
                          """${apiProvider.productInfoModel.content.description ?? ''}""",
                      style: {
                        'strong': Style(color: themeProvider.toggleTextColor()),
                        'body': Style(color: themeProvider.toggleTextColor()),
                        'span': Style(color: themeProvider.toggleTextColor()),
                        'p': Style(color: themeProvider.toggleTextColor()),
                        'li': Style(color: themeProvider.toggleTextColor()),
                        'ul': Style(color: themeProvider.toggleTextColor()),
                        'table': Style(color: themeProvider.toggleTextColor()),
                        'tbody': Style(color: themeProvider.toggleTextColor()),
                        'tr': Style(color: themeProvider.toggleTextColor()),
                        'td': Style(color: themeProvider.toggleTextColor()),
                        'th': Style(color: themeProvider.toggleTextColor()),
                      },
                    )
                  : Container(),
              SizedBox(height: size.width * .1),

              ///Related Product
              apiProvider.relatedProductModel.content.isNotEmpty
                  ? Text('Related Product',
                      style: TextStyle(
                          color: Colors.grey, fontSize: size.width * .05))
                  : Container(),
              apiProvider.relatedProductModel.content.isNotEmpty
                  ? SizedBox(height: size.width * .04)
                  : Container(),
              apiProvider.relatedProductModel.content.isNotEmpty
                  ? Container(
                      height: size.width * .55,
                      color: themeProvider.togglePageBgColor(),
                      //padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount:
                            apiProvider.relatedProductModel.content.length,
                        itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                          productId: apiProvider
                                              .relatedProductModel
                                              .content[index]
                                              .id,
                                          isCampaign: false)));
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    right: 10, top: 10, bottom: 10),
                                child: ProductTile(
                                    index: index,
                                    productsModel:
                                        apiProvider.relatedProductModel))),
                      ),
                    )
                  : Container(),
              apiProvider.relatedProductModel.content.isNotEmpty
                  ? SizedBox(height: size.width * .1)
                  : Container(),

              ///Total Customer Reviews
              TextButton(
                style: TextButton.styleFrom(
                    primary: themeProvider.toggleTextColor()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Customer Reviews (${apiProvider.productInfoModel.content.rating.totalReviewer.toString()})',
                      style: TextStyle(fontSize: size.width * .06),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_outlined,
                      size: size.width * .08,
                    )
                  ],
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerReviewList())),
              ),
              SizedBox(height: size.width * .01),

              ///Average Review
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        //text: 'Hello ',
                        style: TextStyle(
                            fontSize: size.width * .06,
                            color: themeProvider.toggleTextColor(),
                            fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  '${apiProvider.productInfoModel.content.rating.averageRating}'),
                          TextSpan(
                              text: '/5',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: size.width * .04,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                    SizedBox(width: size.width * .025),
                    _averageRatingBuilder(
                        size,
                        double.parse(apiProvider
                            .productInfoModel.content.rating.averageRating
                            .toString())),
                  ],
                ),
              ),
              SizedBox(height: size.width * .01),

              ///Write Your Review
              TextButton(
                style: TextButton.styleFrom(
                    primary: themeProvider.toggleTextColor()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Write Your Review',
                        style: TextStyle(fontSize: size.width * .044)),
                    Icon(Icons.keyboard_arrow_right_outlined,
                        size: size.width * .05)
                  ],
                ),
                onPressed: () {
                  if (_sharedPreferences.getString('username') != null) {
                    _showRatingDialog(size, themeProvider, apiProvider);
                  } else
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),

              ///Product Questions
              TextButton(
                style: TextButton.styleFrom(
                    primary: themeProvider.toggleTextColor()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Product Questions',
                      style: TextStyle(fontSize: size.width * .044),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_outlined,
                      size: size.width * .05,
                    )
                  ],
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductQuestionList(
                              productId: widget.productId,
                            ))),
              ),
              SizedBox(height: size.width * .01),
              Divider(color: Colors.grey, height: 1),
              SizedBox(height: size.width * .1),

              ///Customer Review list
              apiProvider.productReviewList.isEmpty
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: apiProvider.productReviewList.length > 5
                          ? 5
                          : apiProvider.productReviewList.length,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ProductReviewTile(index);
                      },
                    ),
              SizedBox(height: size.width * .1),
            ],
          ),
        ),
      );

  Widget _averageRatingBuilder(Size size, double star) {
    final Color starColor = Color(0xffFFBA00);
    final double starSize = size.width * .06;
    if (star == 5) {
      return Row(children: [
        Icon(Icons.star, size: starSize, color: starColor),
        Icon(Icons.star, size: starSize, color: starColor),
        Icon(Icons.star, size: starSize, color: starColor),
        Icon(Icons.star, size: starSize, color: starColor),
        Icon(Icons.star, size: starSize, color: starColor),
      ]);
    } else if (star < 5 && star >= 4.5) {
      return Row(children: [
        Icon(Icons.star, size: starSize, color: starColor),
        Icon(Icons.star, size: starSize, color: starColor),
        Icon(Icons.star, size: starSize, color: starColor),
        Icon(Icons.star, size: starSize, color: starColor),
        Icon(Icons.star_half, size: starSize, color: starColor),
      ]);
    } else if (star == 4) {
      return Row(children: [
        Icon(Icons.star, size: starSize, color: starColor),
        Icon(Icons.star, size: starSize, color: starColor),
        Icon(Icons.star, size: starSize, color: starColor),
        Icon(Icons.star, size: starSize, color: starColor),
      ]);
    } else if (star < 4 && star >= 3.5) {
      return Row(
        children: [
          Icon(Icons.star, size: starSize, color: starColor),
          Icon(Icons.star, size: starSize, color: starColor),
          Icon(Icons.star, size: starSize, color: starColor),
          Icon(Icons.star_half, size: starSize, color: starColor),
        ],
      );
    } else if (star == 3) {
      return Row(
        children: [
          Icon(Icons.star, size: starSize, color: starColor),
          Icon(Icons.star, size: starSize, color: starColor),
          Icon(Icons.star, size: starSize, color: starColor),
        ],
      );
    } else if (star < 3 && star >= 2.5) {
      return Row(
        children: [
          Icon(Icons.star, size: starSize, color: starColor),
          Icon(Icons.star, size: starSize, color: starColor),
          Icon(Icons.star_half, size: starSize, color: starColor),
        ],
      );
    } else if (star == 2) {
      return Row(
        children: [
          Icon(Icons.star, size: starSize, color: starColor),
          Icon(Icons.star, size: starSize, color: starColor),
        ],
      );
    } else if (star < 2 && star >= 1.5) {
      return Row(
        children: [
          Icon(Icons.star, size: starSize, color: starColor),
          Icon(Icons.star_half, size: starSize, color: starColor),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Icons.star, size: starSize, color: starColor),
        ],
      );
    }
  }

  Widget _floatingActionButton(Size size, ThemeProvider themeProvider,
          DatabaseHelper databaseHelper, APIProvider apiProvider) =>
      Container(
        height: size.width * .14,
        //color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Container(
            //   decoration:BoxDecoration(
            //     color: themeProvider.fabToggleBgColor(),
            //     borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(10)
            //     )
            //   ),
            //   width: size.width*.18,
            //   height: size.width*.14,
            //   child: Stack(
            //     alignment: Alignment.center,
            //       children:[
            //     IconButton(
            //       icon: Icon(FontAwesomeIcons.shoppingCart),color: Colors.white,
            //       onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen())),
            //     ),
            //     Positioned(
            //       top: 8.0,
            //       right: 5.0,
            //       child: Container(
            //         alignment: Alignment.center,
            //         padding: EdgeInsets.all(size.width*.007),
            //         decoration: BoxDecoration(
            //             color: themeProvider.toggleBgColor(),
            //             borderRadius: BorderRadius.all(Radius.circular(20))
            //         ),
            //         child: Text('${databaseHelper.cartList.length>9?'9+':databaseHelper.cartList.length}',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(fontSize: size.width*.024,fontWeight: FontWeight.w500,color: themeProvider.toggleTextColor()),),
            //       ),
            //     )
            //   ] ),
            // ),

            Container(
              decoration: BoxDecoration(
                  color: themeProvider.fabToggleBgColor(),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(10))),
              width: size.width * .497,
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  //onSurface: Colors.red,
                  minimumSize: Size(size.width * .14, size.width * .4),
                ),
                child: _isAdded
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ///Decrease button
                          IconButton(
                            onPressed: () async {
                              if (_pQuantity == 1) {
                                await databaseHelper
                                    .deleteCart(widget.productId.toString())
                                    .then((value) {
                                  setState(() {
                                    _isAdded = false;
                                  });
                                });
                              }
                              if (_pQuantity > 1) {
                                setState(() {
                                  _pQuantity--;
                                });
                                showLoadingDialog('Updating');
                                CartModel cartModel = CartModel(
                                    widget.productId.toString(),
                                    _selectedSize,
                                    apiProvider.productInfoModel.content.name,
                                    apiProvider
                                        .productInfoModel.content.discount
                                        .toString(),
                                    _selectedColor,
                                    _pQuantity.toString(),
                                    _productImage,
                                    apiProvider.productInfoModel.content
                                        .priceStock.price
                                        .toString());
                                await databaseHelper
                                    .updateCart(cartModel)
                                    .then((value) async {
                                  closeLoadingDialog();
                                });
                              }
                            },
                            icon: Icon(
                              Icons.remove_circle_outline,
                              size: size.width * .06,
                              color: Colors.white,
                            ),
                            splashRadius: size.width * .06,
                          ),
                          Text(
                            '$_pQuantity',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * .044,
                                fontWeight: FontWeight.bold),
                          ),

                          ///Increase button
                          IconButton(
                            onPressed: () async {
                              showLoadingDialog('Updating');
                              setState(() => _pQuantity++);
                              CartModel cartModel = CartModel(
                                  widget.productId.toString(),
                                  _selectedSize,
                                  apiProvider.productInfoModel.content.name,
                                  apiProvider.productInfoModel.content.discount
                                      .toString(),
                                  _selectedColor,
                                  _pQuantity.toString(),
                                  _productImage,
                                  apiProvider
                                      .productInfoModel.content.priceStock.price
                                      .toString());
                              await databaseHelper
                                  .updateCart(cartModel)
                                  .then((value) async {
                                closeLoadingDialog();
                              });
                            },
                            icon: Icon(
                              Icons.add_circle_outline_rounded,
                              size: size.width * .06,
                              color: Colors.white,
                            ),
                            splashRadius: size.width * .06,
                          ),
                        ],
                      )
                    : Text('Add Cart',
                        style: TextStyle(fontSize: size.width * .044)),
                onPressed: () => _addProductToCart(databaseHelper, apiProvider),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: themeProvider.fabToggleBgColor(),
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(10))),
              width: size.width * .497,
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  //onSurface: Colors.red,
                  minimumSize: Size(size.width * .14, size.width * .4),
                ),
                child: Text('Buy Now',
                    style: TextStyle(fontSize: size.width * .044)),
                onPressed: () {
                  if (_sharedPreferences.getString('username') != null) {
                    if (apiProvider
                            .productInfoModel.content.availableColors.isEmpty &&
                        apiProvider.productInfoModel.content.availableSizes
                            .isNotEmpty) {
                      if (_selectedSize.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuickBuyPage(
                                    productId: widget.productId.toString(),
                                    productSize: _selectedSize,
                                    productName: apiProvider
                                        .productInfoModel.content.name,
                                    productColor: _selectedColor,
                                    productPrice: apiProvider.productInfoModel
                                        .content.priceStock.price
                                        .toString(),
                                    isCampaign: widget.isCampaign)));
                      } else {
                        showInfo('Select Product Size');
                      }
                    } else if (apiProvider.productInfoModel.content
                            .availableColors.isNotEmpty &&
                        apiProvider
                            .productInfoModel.content.availableSizes.isEmpty) {
                      if (_selectedColor.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuickBuyPage(
                                    productId: widget.productId.toString(),
                                    productSize: _selectedSize,
                                    productName: apiProvider
                                        .productInfoModel.content.name,
                                    productColor: _selectedColor,
                                    productPrice: apiProvider.productInfoModel
                                        .content.priceStock.price
                                        .toString(),
                                    isCampaign: widget.isCampaign)));
                      } else {
                        showInfo('Select Product Color');
                      }
                    } else if (apiProvider.productInfoModel.content
                            .availableColors.isNotEmpty &&
                        apiProvider.productInfoModel.content.availableSizes
                            .isNotEmpty) {
                      if (_selectedSize.isNotEmpty &&
                          _selectedColor.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuickBuyPage(
                                    productId: widget.productId.toString(),
                                    productSize: _selectedSize,
                                    productName: apiProvider
                                        .productInfoModel.content.name,
                                    productColor: _selectedColor,
                                    productPrice: apiProvider.productInfoModel
                                        .content.priceStock.price
                                        .toString(),
                                    isCampaign: widget.isCampaign)));
                      } else {
                        showInfo('Select Product Size & Color');
                      }
                    } else if (apiProvider
                            .productInfoModel.content.availableColors.isEmpty &&
                        apiProvider
                            .productInfoModel.content.availableSizes.isEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuickBuyPage(
                                  productId: widget.productId.toString(),
                                  productSize: _selectedSize,
                                  productName:
                                      apiProvider.productInfoModel.content.name,
                                  productColor: _selectedColor,
                                  productPrice: apiProvider
                                      .productInfoModel.content.priceStock.price
                                      .toString(),
                                  isCampaign: widget.isCampaign)));
                    }
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                },
              ),
            ),
          ],
        ),
      );

  void _addProductToCart(
      DatabaseHelper databaseHelper, APIProvider apiProvider) async {
    if (apiProvider.productInfoModel.content.availableColors.isEmpty &&
        apiProvider.productInfoModel.content.availableSizes.isNotEmpty) {
      if (_selectedSize.isNotEmpty) {
        if (!databaseHelper.productIdListInCart
            .contains(widget.productId.toString())) {
          setState(() {
            _isAdded = true;
            _pQuantity = 1;
          });
          showLoadingDialog('Adding Product to Cart');
          CartModel cartModel = CartModel(
              widget.productId.toString(),
              _selectedSize,
              apiProvider.productInfoModel.content.name,
              apiProvider.productInfoModel.content.discount.toString(),
              _selectedColor,
              _pQuantity.toString(),
              _productImage,
              apiProvider.productInfoModel.content.priceStock.price.toString());
          await databaseHelper.insertCart(cartModel).then((value) async {
            closeLoadingDialog();
            showSuccessMgs('Product Added to Cart');
          });
        } else {
          showInfo('This Product Already Added to Cart');
        }
      } else {
        showInfo('Select Product Size');
      }
    } else if (apiProvider
            .productInfoModel.content.availableColors.isNotEmpty &&
        apiProvider.productInfoModel.content.availableSizes.isEmpty) {
      if (_selectedColor.isNotEmpty) {
        if (!databaseHelper.productIdListInCart
            .contains(widget.productId.toString())) {
          setState(() {
            _isAdded = true;
            _pQuantity = 1;
          });
          showLoadingDialog('Adding Product to Cart');
          CartModel cartModel = CartModel(
              widget.productId.toString(),
              _selectedSize,
              apiProvider.productInfoModel.content.name,
              apiProvider.productInfoModel.content.discount.toString(),
              _selectedColor,
              _pQuantity.toString(),
              _productImage,
              apiProvider.productInfoModel.content.priceStock.price.toString());
          await databaseHelper.insertCart(cartModel).then((value) async {
            closeLoadingDialog();
            showSuccessMgs('Product Added to Cart');
          });
        } else {
          showInfo('This Product Already Added to Cart');
        }
      } else {
        showInfo('Select Product Color');
      }
    } else if (apiProvider
            .productInfoModel.content.availableColors.isNotEmpty &&
        apiProvider.productInfoModel.content.availableSizes.isNotEmpty) {
      if (_selectedSize.isNotEmpty && _selectedColor.isNotEmpty) {
        if (!databaseHelper.productIdListInCart
            .contains(widget.productId.toString())) {
          setState(() {
            _isAdded = true;
            _pQuantity = 1;
          });
          showLoadingDialog('Adding Product to Cart');
          CartModel cartModel = CartModel(
              widget.productId.toString(),
              _selectedSize,
              apiProvider.productInfoModel.content.name,
              apiProvider.productInfoModel.content.discount.toString(),
              _selectedColor,
              _pQuantity.toString(),
              _productImage,
              apiProvider.productInfoModel.content.priceStock.price.toString());
          await databaseHelper.insertCart(cartModel).then((value) async {
            closeLoadingDialog();
            showSuccessMgs('Product Added to Cart');
          });
        } else {
          showInfo('This Product Already Added to Cart');
        }
      } else {
        showInfo('Select Product Size & Color');
      }
    } else if (apiProvider.productInfoModel.content.availableColors.isEmpty &&
        apiProvider.productInfoModel.content.availableSizes.isEmpty) {
      if (!databaseHelper.productIdListInCart
          .contains(widget.productId.toString())) {
        setState(() {
          _isAdded = true;
          _pQuantity = 1;
        });
        showLoadingDialog('Adding Product to Cart');
        CartModel cartModel = CartModel(
            widget.productId.toString(),
            _selectedSize,
            apiProvider.productInfoModel.content.name,
            apiProvider.productInfoModel.content.discount.toString(),
            _selectedColor,
            _pQuantity.toString(),
            _productImage,
            apiProvider.productInfoModel.content.priceStock.price.toString());
        await databaseHelper.insertCart(cartModel).then((value) async {
          closeLoadingDialog();
          showSuccessMgs('Product Added to Cart');
        });
      } else {
        showInfo('This Product Already Added to Cart');
      }
    }
  }

// show the dialog
  void _showRatingDialog(
      Size size, ThemeProvider themeProvider, APIProvider apiProvider) {
    showAnimatedDialog(
        context: context,
        animationType: DialogTransitionType.slideFromBottomFade,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 500),
        builder: (context) {
          return AlertDialog(
            backgroundColor: themeProvider.toggleBgColor(),
            contentPadding: EdgeInsets.symmetric(horizontal: 5),
            scrollable: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Rate this Product',
                        style: TextStyle(
                            fontSize: size.width * .05,
                            fontWeight: FontWeight.w500,
                            color: themeProvider.toggleTextColor()),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Colors.grey,
                        size: size.width * .06,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _ratingComment.clear();
                      },
                    )
                  ],
                ),
                SizedBox(height: size.width * .1),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  glowColor: Colors.yellow[900],
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  unratedColor: Colors.grey,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: size.width * .04,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() => _starRating = rating);
                  },
                ),
                SizedBox(height: size.width * .05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .065),
                  child: TextFormField(
                      controller: _ratingComment,
                      maxLines: 3,
                      style: TextStyle(
                          color: themeProvider.toggleTextColor(),
                          fontSize: size.width * .04),
                      decoration: boxFormDecoration(size).copyWith(
                          labelText: 'Write your comment',
                          alignLabelWithHint: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          isDense: true)),
                ),
                SizedBox(height: size.width * .05),
                ElevatedButton(
                    style: ButtonStyle(),
                    onPressed: () async {
                      showLoadingDialog('Submitting Review');
                      Map map = {
                        "name": "${_sharedPreferences.getString('name')}",
                        "email": "${_sharedPreferences.getString('username')}",
                        "message": "${_ratingComment.text}",
                        "rating": "$_starRating",
                        "prid": "${widget.productId}"
                      };
                      await apiProvider.writeProductReview(map).then((value) {
                        if (value) {
                          closeLoadingDialog();
                          showSuccessMgs('Review Submitted');
                          apiProvider.getProductInfo(widget.productId);
                          Navigator.pop(context);
                          _ratingComment.clear();
                        } else {
                          closeLoadingDialog();
                          showInfo('Failed !');
                          Navigator.pop(context);
                        }
                      });
                    },
                    child: Text('Submit'))
              ],
            ),
          );
        });
  }

  // void _showSellerReviewDialog(Size size, ThemeProvider themeProvider){
  //   showAnimatedDialog(
  //       context: context,
  //       animationType: DialogTransitionType.slideFromBottomFade,
  //       curve: Curves.fastOutSlowIn,
  //       duration: Duration(milliseconds: 500),
  //       builder: (context){
  //         return AlertDialog(
  //           backgroundColor: themeProvider.toggleBgColor(),
  //           contentPadding: EdgeInsets.symmetric(horizontal: 5),
  //           scrollable: true,
  //           content: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Padding(
  //                     padding:  EdgeInsets.only(left: 8.0),
  //                     child: Text('Seller Review',style: TextStyle(fontSize: size.width*.05,fontWeight: FontWeight.w500,color: themeProvider.toggleTextColor()),),
  //                   ),
  //                   IconButton(
  //                     icon: Icon(Icons.cancel_outlined,color: Colors.grey,size: size.width*.06,),
  //                     onPressed: (){Navigator.pop(context);_ratingComment.clear();},
  //                   )
  //                 ],
  //               ),
  //               SizedBox(height: size.width*.05),
  //               VerticalBarchart(
  //                 maxX: 55,
  //                 data: barData,
  //                 //showLegend: true,
  //                 alwaysShowDescription: true,
  //                 showBackdrop: true,
  //                 background:  themeProvider.toggleBgColor(),
  //                 //labelColor: themeProvider.toggleTextColor(),
  //                 tooltipColor: Colors.grey,
  //                 // legend: [
  //                 //   Vlegend(
  //                 //     isSquare: false,
  //                 //     color: Colors.orange,
  //                 //     text: "Fruits",
  //                 //   ),
  //                 //   Vlegend(
  //                 //     isSquare: false,
  //                 //     color: Colors.teal,
  //                 //     text: "Vegetables",
  //                 //   )
  //                 // ],
  //               ),
  //               SizedBox(height: size.width*.05),
  //             ],
  //           ),
  //         );
  //       });
  // }
}
