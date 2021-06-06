import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProductReviewTile extends StatelessWidget {
  static const Color starColor = Color(0xffFFBA00);
  int index;
  ProductReviewTile(this.index);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double starSize= size.width*.035;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    final double star=double.parse(apiProvider.productReviewList[index].rating.toString());
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
      margin: EdgeInsets.only(bottom: 10),
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
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Colors.grey,
                  image: DecorationImage(
                    image: AssetImage('assets/user.PNG'),
                    fit: BoxFit.fill
                  )
                ),
                  //child: CachedNetworkImage(
                  //   imageUrl: 'https://i.picsum.photos/id/1027/2848/4272.jpg?hmac=EAR-f6uEqI1iZJjB6-NzoZTnmaX0oI0th3z8Y78UpKM',
                  //   placeholder: (context, url) => Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: CircularProgressIndicator(),
                  //   ),
                  //   errorWidget: (context, url, error) => Icon(Icons.error),
                  //   height: size.width * .18,
                  //   width: size.width * .18,
                  //   fit: BoxFit.fill,
                  // ),
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
                      apiProvider.productReviewList[index].username,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: size.width*.04,
                          color: themeProvider.toggleTextColor(),
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 3),
                    Text(
                      apiProvider.productReviewList[index].date,
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
                      apiProvider.productReviewList[index].rating,
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
                        :star < 5 && star>=4.5
                        ? Row(
                      children: [
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star_half, size: starSize, color: starColor),
                      ],
                    )
                        : star == 4
                        ? Row(
                      children: [
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                      ],
                    )
                        :star < 4 && star>=3.5
                        ? Row(
                      children: [
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star_half, size: starSize, color: starColor),
                      ],
                    )
                        : star == 3
                        ? Row(
                      children: [
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                      ],
                    )
                        :star < 3 && star>=2.5
                        ? Row(
                      children: [
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star_half, size: starSize, color: starColor),
                      ],
                    )
                        : star == 2
                        ? Row(
                      children: [
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star, size: starSize, color: starColor),
                      ],
                    ):star < 2 && star>=1.5
                        ? Row(
                      children: [
                        Icon(Icons.star, size: starSize, color: starColor),
                        Icon(Icons.star_half, size: starSize, color: starColor),
                      ],
                    )
                        : Row(
                      children: [
                        Icon(Icons.star, size: starSize, color: starColor),
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
              apiProvider.productReviewList[index].reviewText,
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
