import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PublicData {

  static final navBarIconList = <IconData>[
    FontAwesomeIcons.home,
    FontAwesomeIcons.box,
    FontAwesomeIcons.shoppingBasket,
    FontAwesomeIcons.userAlt,
  ];
  static final navBarNameList = <String>[
    'Home',
    'Category',
    'Cart',
    'Account'
  ];

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


  static final List<String> deliveryOptionList = [
    'RedX\nShipping Cost: Tk.100\nEstimate time: 4-5 Days\n',
    'Pathao\nShipping Cost: Tk.120\nEstimate time: 3-4 Days\n',
    'eCourier\nShipping Cost: Tk.120\nEstimate time: 3-4 Days\n',
    'Sundarban Courier\nShipping Cost: Tk.200\nEstimate time: 1-2 Days\n',
    'SA. Paribahan\nShipping Cost: Tk.200\nEstimate time: 1-2 Days\n'
  ];

  static List<Widget> bannerImageWidget(APIProvider apiProvider){
     final List<Widget> imageSliders = apiProvider.bannerImageList
        .map<Widget>((item) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Image.network(item, fit: BoxFit.cover, width: 500.0),
        ),
      ),
    ))
        .toList();
     return imageSliders;
  }

 static List<Widget> categoryWidgetList(APIProvider apiProvider,ThemeProvider themeProvider){
    List<Widget> categoryList= apiProvider.productCategoryList.map<Widget>((item)=>
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Text(item,style: TextStyle(color: themeProvider.toggleTextColor()),),
        )).toList();
    return categoryList;
 }
}
