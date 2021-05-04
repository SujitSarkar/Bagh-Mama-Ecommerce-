import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProductReviewTile extends StatelessWidget {
  static const Color starColor = Color(0xffFFBA00);
  int index;
  int star;
  ProductReviewTile(this.index,this.star);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double starSize= size.width*.035;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
      margin: EdgeInsets.only(bottom: 10),
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.all(Radius.circular(10)),
      //     boxShadow: [
      //       BoxShadow(color: Colors.grey[300], offset: Offset(1, 2), blurRadius: 20)
      //     ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Image Container
              Container(
                height: size.width * .15,
                width: size.width * .15,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  //color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Colors.grey,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
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

              ///Name & time Container
              Container(
                alignment: Alignment.topLeft,
                padding:
                const EdgeInsets.only(top: 5, bottom: 5),
                width: size.width * .47,
                //height: 65,
                //color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Mr. Tanvir Ahmed',
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: size.width*.04,
                          color: themeProvider.toggleTextColor(),
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '12 Mar, 2021',
                      maxLines: 2,
                      style: TextStyle(
                          fontSize:  size.width*.034, color: Colors.grey[600]),
                    )
                  ],
                ),
              ),

              ///Star container
              Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                //color: Colors.green,
                width: size.width * .25,
                //height: 65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '3.0',
                      style: TextStyle(
                          fontSize: starSize,
                          color: themeProvider.toggleTextColor(),
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 5),
                    star == 5
                        ? Row(
                      children: [
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                      ],
                    )
                        : star == 4
                        ? Row(
                      children: [
                        Icon(Icons.star,
                            size: starSize, color: starColor),
                        Icon(Icons.star,
                            size: starSize, color: starColor),
                        Icon(Icons.star,
                            size: starSize, color: starColor),
                        Icon(Icons.star,
                            size: starSize, color: starColor),
                      ],
                    )
                        : star == 3
                        ? Row(
                      children: [
                        Icon(Icons.star,
                            size: starSize, color: starColor),
                        Icon(Icons.star,
                            size: starSize, color: starColor),
                        Icon(Icons.star,
                            size: starSize, color: starColor),
                      ],
                    )
                        : star == 2
                        ? Row(
                      children: [
                        Icon(Icons.star,
                            size: starSize, color: starColor),
                        Icon(Icons.star,
                            size: starSize, color: starColor),
                      ],
                    )
                        : Row(
                      children: [
                        Icon(Icons.star,
                            size: starSize, color: starColor),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///Review Text Container
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            width: size.width * .95,
            child:
            ExpandableText(
              'Star is one of the most popular symbols. From the ancient times '
                  'it was a symbol of celestial stars. In those days the '
                  'celestial stars were reputed as sentient beings influencing '
                  'on people. Our ancestors believed every person had his or '
                  'her own star and they both had the same day of birth and the '
                  'same day of death.',
              expandText: 'more',
              collapseText: 'less',
              maxLines: 3,
              linkColor: Colors.grey[600],
              textAlign: TextAlign.justify,
              style: TextStyle(color: themeProvider.toggleTextColor(), fontSize:  size.width*.035),
            ),)
        ],
      ),
    );
  }
}
