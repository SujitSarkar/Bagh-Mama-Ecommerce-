import 'package:bagh_mama/pages/product_details_page.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class WishlistTile extends StatefulWidget {
  int index;
  WishlistTile(this.index);

  @override
  _WishlistTileState createState() => _WishlistTileState();
}
class _WishlistTileState extends State<WishlistTile> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: size.width*.03),
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Image Container
              Container(
                height: size.width * .3,
                width: size.width * .3,
                decoration: BoxDecoration(
                  //color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.grey,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: CachedNetworkImage(
                    imageUrl: 'https://i.picsum.photos/id/1027/2848/4272.jpg?hmac=EAR-f6uEqI1iZJjB6-NzoZTnmaX0oI0th3z8Y78UpKM',
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: size.width * .18,
                    width: size.width * .18,
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              ///Name & Price Container
              Container(
                alignment: Alignment.topLeft,
                padding:EdgeInsets.only(top: 5, bottom: 5),
                width: size.width * .62,
                //height: 65,
                //color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Avon Trux Bicycles',
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: size.width*.038,
                          color: themeProvider.toggleTextColor(),
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: size.width*.02),
                    Text(
                      'Tk.100',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize:  size.width*.04, color: themeProvider.toggleTextColor(),fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: size.width*.04),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails())),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey,width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            padding: EdgeInsets.symmetric(horizontal: size.width * .03,vertical: size.width * .015),
                            child: Text('Details',
                              style: TextStyle(
                                  color: themeProvider.orangeWhiteToggleColor(),
                                  fontSize: size.width*.033),
                            ),
                          ),
                          borderRadius:BorderRadius.all(Radius.circular(5)),
                        ),
                        InkWell(
                          child: Icon(Icons.delete_outline,size: size.width*.07,color: themeProvider.toggleTextColor(),),
                          onTap: (){},
                          //splashRadius: ,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}