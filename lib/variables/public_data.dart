import 'package:flutter/material.dart';

class PublicData {
  static final List<String> productCategoryList = [
    'Women’s Clothing',
    'Men’s Clothing',
    'Consumer Electronics',
    'Home Improvement & Tools',
    'Jewelry & Watches',
    'Phones & Accessories',
    'Computer & Laptops, Office',
    'Shoes & Bags',
    'Baby, Kids & Toys',
    'Home, Appliances & Pet',
    'Sports & Outdoor Fun',
    'Health & Beauty, Hair',
    'Automobiles & Motorcycles'
  ];

  static final List<String> imgList = [
    'assets/banner_image/bm1.jpg',
    'assets/banner_image/bm2.jpg',
    'assets/banner_image/bm3.jpg',
    'assets/banner_image/bm4.png',
  ];

  static final List<String> deliveryOptionList = [
    'RedX\nShipping Cost: Tk.100\nEstimate time: 4-5 Days\n',
    'Pathao\nShipping Cost: Tk.120\nEstimate time: 3-4 Days\n',
    'eCourier\nShipping Cost: Tk.120\nEstimate time: 3-4 Days\n',
    'Sundarban Courier\nShipping Cost: Tk.200\nEstimate time: 1-2 Days\n',
    'SA. Paribahan\nShipping Cost: Tk.200\nEstimate time: 1-2 Days\n'
  ];

  static final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Image.asset(item, fit: BoxFit.cover, width: 500.0),
                // child: Stack(
                //   children: <Widget>[
                //     Image.asset(item, fit: BoxFit.cover, width: 500.0),
                //     Positioned(
                //       bottom: 0.0,
                //       left: 0.0,
                //       right: 0.0,
                //       child: Container(
                //         decoration: BoxDecoration(
                //           gradient: LinearGradient(
                //             colors: [
                //               Color.fromARGB(200, 0, 0, 0),
                //               Color.fromARGB(0, 0, 0, 0)
                //             ],
                //             begin: Alignment.bottomCenter,
                //             end: Alignment.topCenter,
                //           ),
                //         ),
                //         padding: EdgeInsets.symmetric(
                //             vertical: 10.0, horizontal: 20.0),
                //         child: Text(
                //           'No. ${imgList.indexOf(item)} image',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 16.0,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // )
              ),
            ),
          ))
      .toList();
}
