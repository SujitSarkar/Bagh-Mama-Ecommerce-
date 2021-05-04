import 'package:bagh_mama/pages/customer_review_list.dart';
import 'package:bagh_mama/pages/product_question_list.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/screens/cart_screen.dart';
import 'package:bagh_mama/widget/home_product_cart_tile.dart';
import 'package:bagh_mama/widget/product_review_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool _isTapped=false;
  int _pQuantity=1;
  bool _isAdded=false;
  double _starRating;
  TextEditingController _ratingCommentController = TextEditingController();

  final List<VBarChartModel> barData = [
    VBarChartModel(
      index: 0,
      label: "Delivery Speed:",
      colors: [Colors.orange, Colors.deepOrange],
      jumlah: 20,
      tooltip: "20",
      // description: Text(
      //   "Most selling fruit last week",
      //   style: TextStyle(fontSize: 10),
      // ),
    ),
    VBarChartModel(
      index: 1,
      label: "Positive Rating:",
      colors: [Colors.orange, Colors.deepOrange],
      jumlah: 55,
      tooltip: "55",
    ),
    VBarChartModel(
      index: 2,
      label: "Response Rate:",
      colors: [Colors.teal, Colors.indigo],
      jumlah: 12,
      tooltip: "12",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.whiteBlackToggleColor(),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    iconTheme: IconThemeData(color: Colors.grey),
                    actions: [
                      IconButton(icon: Icon(Icons.ios_share,color: Colors.grey,),
                          onPressed: (){},
                        splashRadius: size.width*.06,
                      ),
                    ],
                    expandedHeight: size.width*.8,
                    floating: true,
                    pinned: true,
                    snap: true,
                    actionsIconTheme: IconThemeData(opacity: 1),
                    flexibleSpace: Stack(
                      children: <Widget>[
                        Positioned.fill(
                            child: Image.asset(
                              "assets/product_image/product.jpg",
                              fit: BoxFit.cover,
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
                            Text('In Stock',style: TextStyle(fontSize: size.width*.045,fontWeight: FontWeight.w500,color: Colors.green),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Add to wishlsist',style: TextStyle(fontSize: size.width*.045,color: themeProvider.toggleTextColor()),),
                                // SizedBox(width: size.width*.03),
                                IconButton(
                                  onPressed: (){
                                    setState(()=> _isTapped=!_isTapped);
                                  },
                                  icon: Icon(_isTapped? FontAwesomeIcons.solidHeart:FontAwesomeIcons.heart,color: Colors.pink),
                                  splashRadius: size.width*.06,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]
                      ),
                    ),
                  ),
                ];
              },
              body: _bodyUI(size, themeProvider),
            ),
          ),
        ),
      floatingActionButton: _floatingActionButton(size, themeProvider),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  
  Widget _bodyUI(Size size, ThemeProvider themeProvider)=> Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Here you can view all the images Lorem Picsum provides.'
              'Get a specific image by adding /id/{image} to the start of the url.'
              'Here you can view all the images Lorem Picsum provides.',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: size.width*.04,color: themeProvider.toggleTextColor(),fontWeight: FontWeight.w500),
          ),
          SizedBox(height: size.width*.03),

          Text('Tk.1000',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: size.width*.05,color: themeProvider.toggleTextColor(),fontWeight: FontWeight.bold),),
          SizedBox(height: size.width*.02),

          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              //text: 'Hello ',
              style: TextStyle(fontSize: size.width*.04,color: themeProvider.toggleTextColor()),
              children: <TextSpan>[
                TextSpan(text: 'Product Code: '),
                TextSpan(text: '3', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: size.width*.1),

          ///Related Product
          Text('Related Product',
              style: TextStyle(color: Colors.grey,fontSize: size.width*.05)),
          SizedBox(height: size.width*.04),
          Container(
            height: size.width*.5,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index)=>InkWell(
                  onTap: (){},
                  child: HomeProductCartTile(index: index)),
            ),
          ),
          SizedBox(height: size.width*.1),

          ///Customer Reviews
          TextButton(
            style: TextButton.styleFrom(
              primary: themeProvider.toggleTextColor()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Customer Reviews (50)',style: TextStyle(fontSize: size.width*.06),),
                Icon(Icons.keyboard_arrow_right_outlined,size: size.width*.08,)
              ],
            ),
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerReviewList())),
          ),
          SizedBox(height: size.width*.01),

          ///Average Review
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    //text: 'Hello ',
                    style: TextStyle(fontSize: size.width*.06,color: themeProvider.toggleTextColor(),fontWeight:FontWeight.w500),
                    children: <TextSpan>[
                      TextSpan(text: '4.50'),
                      TextSpan(text: '/5', style: TextStyle(fontWeight: FontWeight.w400,fontSize: size.width*.04,color: Colors.grey)),
                    ],
                  ),
                ),
                SizedBox(width: size.width*.025),
                Icon(Icons.star,size: size.width*.062,color: Colors.yellow[800],),
                Icon(Icons.star,size: size.width*.062,color: Colors.yellow[800],),
                Icon(Icons.star,size: size.width*.062,color: Colors.yellow[800],),
                Icon(Icons.star,size: size.width*.062,color: Colors.yellow[800],),
                Icon(Icons.star_half,size: size.width*.062,color: Colors.yellow[800],),
              ],
            ),
          ),
          SizedBox(height: size.width*.01),

          ///Write Your Review
          TextButton(
            style: TextButton.styleFrom(
                primary: themeProvider.toggleTextColor()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Write Your Review',style: TextStyle(fontSize: size.width*.044),),
                Icon(Icons.keyboard_arrow_right_outlined,size: size.width*.05,)
              ],
            ),
            onPressed: (){_showRatingDialog(size, themeProvider);},
          ),
          ///Seller Review
          TextButton(
            style: TextButton.styleFrom(
                primary: themeProvider.toggleTextColor()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Seller Review',style: TextStyle(fontSize: size.width*.044),),
                Icon(Icons.keyboard_arrow_right_outlined,size: size.width*.05,)
              ],
            ),
            onPressed: (){_showSellerReviewDialog(size, themeProvider);},
          ),

          ///Product Questions
          TextButton(
            style: TextButton.styleFrom(
                primary: themeProvider.toggleTextColor()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Product Questions',style: TextStyle(fontSize: size.width*.044),),
                Icon(Icons.keyboard_arrow_right_outlined,size: size.width*.05,)
              ],
            ),
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductQuestionList())),
          ),
          SizedBox(height: size.width*.01),
          Divider(color: Colors.grey,height:1),
          SizedBox(height: size.width*.1),

          ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context,index){
              return ProductReviewTile(index, 4);
            },
          )
        ],
      ),
    ),
  );

  Widget _floatingActionButton(Size size, ThemeProvider themeProvider)=>Container(
    height: size.width*.14,
    //color: Colors.grey,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration:BoxDecoration(
            color: themeProvider.fabToggleBgColor(),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10)
            )
          ),
          width: size.width*.18,
          height: size.width*.14,
          child: Stack(
            alignment: Alignment.center,
              children:[
            IconButton(
              icon: Icon(FontAwesomeIcons.shoppingCart),color: Colors.white,
              onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen())),
            ),
            Positioned(
              top: 8.0,
              right: 5.0,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(size.width*.007),
                decoration: BoxDecoration(
                    color: themeProvider.toggleBgColor(),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Text('9+',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: size.width*.024,fontWeight: FontWeight.w500,color: themeProvider.toggleTextColor()),),
              ),
            )
          ] ),
        ),
        Container(
          color: themeProvider.fabToggleBgColor(),
          width: size.width*.4,
          child: TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              //onSurface: Colors.red,
              minimumSize: Size(size.width*.14, size.width*.4),
            ),
            child: _isAdded? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: (){
                    if(_pQuantity==1)
                    setState(() {
                      _isAdded=false;
                    });
                    if(_pQuantity>1) setState((){
                      _pQuantity--;
                    });
                  },
                  icon: Icon(Icons.remove_circle_outline,size: size.width*.06,color: Colors.white,), splashRadius: size.width*.06,),
                Text('$_pQuantity',style: TextStyle(color: Colors.white,fontSize: size.width*.044,fontWeight: FontWeight.bold),),
                IconButton(
                  onPressed: (){
                    setState(()=>_pQuantity++);
                  },
                  icon: Icon(Icons.add_circle_outline_rounded,size: size.width*.06,color: Colors.white,),splashRadius: size.width*.06,),
              ],
            ): Text('Add Cart',style: TextStyle(fontSize: size.width*.044)),
            onPressed: (){
              setState(() {
                _isAdded=true;
              });
              },
          ),
        ),
        Container(
          decoration:BoxDecoration(
              color: themeProvider.fabToggleBgColor(),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10)
              )
          ),
          width: size.width*.4,
          child: TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              //onSurface: Colors.red,
              minimumSize: Size(size.width*.14, size.width*.4),
            ),
            child: Text('Quick Buy',style: TextStyle(fontSize: size.width*.044),),
            onPressed: (){

            },
          ),
        ),
      ],
    ),
  );

// show the dialog
  void _showRatingDialog(Size size, ThemeProvider themeProvider){
    showAnimatedDialog(
        context: context,
        animationType: DialogTransitionType.slideFromBottomFade,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 500),
    builder: (context){
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
                      padding:  EdgeInsets.only(left: 8.0),
                      child: Text('Rate this Product',style: TextStyle(fontSize: size.width*.05,fontWeight: FontWeight.w500,color: themeProvider.toggleTextColor()),),
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel_outlined,color: Colors.grey,size: size.width*.06,),
                      onPressed: (){Navigator.pop(context);_ratingCommentController.clear();},
                    )
                  ],
                ),
                SizedBox(height: size.width*.1),

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
                    size: size.width*.04,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _starRating = rating;
                    });
                  },
                ),
                SizedBox(height: size.width*.05),

                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: size.width*.065),
                  child: TextFormField(
                    controller: _ratingCommentController,
                    maxLines: 2,
                    style: TextStyle(
                        color: themeProvider.toggleTextColor(),
                        fontSize: size.width*.04
                    ),
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Write your comment',
                      labelStyle: TextStyle(
                        color: themeProvider.toggleTextColor(),
                        fontSize: size.width*.04
                      ),
                      enabled: true,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      )
                    ),
                  ),
                ),
                SizedBox(height: size.width*.05),

                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor()),
                  ),
                    onPressed: (){
                    Navigator.pop(context);
                    print('Comment: ${_ratingCommentController.text}\nRating: $_starRating');
                    _ratingCommentController.clear();
                    },
                    child: Text('Submit'))
              ],
            ),
          );
    });
  }

  void _showSellerReviewDialog(Size size, ThemeProvider themeProvider){
    showAnimatedDialog(
        context: context,
        animationType: DialogTransitionType.slideFromBottomFade,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 500),
        builder: (context){
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
                      padding:  EdgeInsets.only(left: 8.0),
                      child: Text('Seller Review',style: TextStyle(fontSize: size.width*.05,fontWeight: FontWeight.w500,color: themeProvider.toggleTextColor()),),
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel_outlined,color: Colors.grey,size: size.width*.06,),
                      onPressed: (){Navigator.pop(context);_ratingCommentController.clear();},
                    )
                  ],
                ),
                SizedBox(height: size.width*.05),
                VerticalBarchart(
                  maxX: 55,
                  data: barData,
                  //showLegend: true,
                  alwaysShowDescription: true,
                  showBackdrop: true,
                  background:  themeProvider.toggleBgColor(),
                  //labelColor: themeProvider.toggleTextColor(),
                  tooltipColor: Colors.grey,
                  // legend: [
                  //   Vlegend(
                  //     isSquare: false,
                  //     color: Colors.orange,
                  //     text: "Fruits",
                  //   ),
                  //   Vlegend(
                  //     isSquare: false,
                  //     color: Colors.teal,
                  //     text: "Vegetables",
                  //   )
                  // ],
                ),
                SizedBox(height: size.width*.05),
              ],
            ),
          );
        });
  }
}
