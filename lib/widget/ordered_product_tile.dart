import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OrderedProductTile extends StatefulWidget {
  int index;
  OrderedProductTile(this.index);

  @override
  _OrderedProductTileState createState() => _OrderedProductTileState();
}

class _OrderedProductTileState extends State<OrderedProductTile> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: size.width*.03),
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        //text: 'Hello ',
                        style: TextStyle(fontSize: size.width*.038,color: themeProvider.toggleTextColor()),
                        children: <TextSpan>[
                          TextSpan(text: 'Avon Trux Bicycles\n',style: TextStyle(fontWeight: FontWeight.w500,fontSize: size.width*.04)),
                          TextSpan(text: 'Size: '),
                          TextSpan(text: '45\n',style: TextStyle(fontWeight: FontWeight.w500)),
                          TextSpan(text: 'Color: '),
                          TextSpan(text: 'yellow\n',style: TextStyle(fontWeight: FontWeight.w500)),
                          TextSpan(text: 'Quantity: '),
                          TextSpan(text: '4\n',style: TextStyle(fontWeight: FontWeight.w500)),
                          TextSpan(text: 'Total: '),
                          TextSpan(text: 'TK.2000',style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
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