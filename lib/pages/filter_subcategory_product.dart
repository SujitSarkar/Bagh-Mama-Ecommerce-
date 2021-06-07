import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FilterSubcategoryProduct extends StatefulWidget {
  String categoryId;
  FilterSubcategoryProduct({this.categoryId});

  @override
  _FilterSubcategoryProductState createState() =>
      _FilterSubcategoryProductState();
}

class _FilterSubcategoryProductState extends State<FilterSubcategoryProduct> {
  bool _isChecked = false;
  int _radioValue = 0;
  TextEditingController _min = TextEditingController(text: '0');
  TextEditingController _max = TextEditingController(text: '0');
  TextEditingController _brand = TextEditingController(text: '');
  TextEditingController _color = TextEditingController(text: '');
  TextEditingController _size = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return null;
      },
      child: Scaffold(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        appBar: AppBar(
          backgroundColor: themeProvider.whiteBlackToggleColor(),
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.grey,
          ),
          title: Text(
            'Filter Product',
            style: TextStyle(
                color: themeProvider.toggleTextColor(),
                fontSize: size.width * .045),
          ),
        ),
        body: _bodyUI(themeProvider,apiProvider, size),
      ),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider,APIProvider apiProvider, Size size) => ListView(
        children: [
          ///Min Max Field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * .03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: size.width * .42,
                  child: TextField(
                    controller: _min,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: themeProvider.toggleTextColor(), fontSize: size.width * .04),
                    decoration: boxFormDecoration(size).copyWith(
                      labelText: 'min price',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: size.width * .02,
                          horizontal: size.width * .02),
                      //Change this value to custom as you like
                      isDense: true,
                    ),
                  ),
                ),
                Text('-',
                    style: TextStyle(
                        color: Colors.grey, fontSize: size.width * 0.05)),
                Container(
                  width: size.width * .42,
                  child: TextField(
                    controller: _max,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: themeProvider.toggleTextColor(), fontSize: size.width * .04),
                    decoration: boxFormDecoration(size).copyWith(
                      labelText: 'max price',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: size.width * .02,
                          horizontal: size.width * .02),
                      //Change this value to custom as you like
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.width * .05),

          ///Brand, Color, Size
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * .03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: size.width * .35,
                  child: TextField(
                    controller: _brand,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: themeProvider.toggleTextColor(), fontSize: size.width * .04),
                    decoration: boxFormDecoration(size).copyWith(
                      labelText: 'Brand',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: size.width * .02,
                          horizontal: size.width * .02),
                      //Change this value to custom as you like
                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  width: size.width * .28,
                  child: TextField(
                    controller: _color,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: themeProvider.toggleTextColor(), fontSize: size.width * .04),
                    decoration: boxFormDecoration(size).copyWith(
                      labelText: 'Color',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: size.width * .02,
                          horizontal: size.width * .02),
                      //Change this value to custom as you like
                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  width: size.width * .28,
                  child: TextField(
                    controller: _size,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: themeProvider.toggleTextColor(), fontSize: size.width * .04),
                    decoration: boxFormDecoration(size).copyWith(
                      labelText: 'Size',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: size.width * .02,
                          horizontal: size.width * .02),
                      //Change this value to custom as you like
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.width * .05),

          ///Divider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * .03),
            child: Divider(color: Colors.grey, thickness: 0.5, height: 0.0),
          ),
          SizedBox(height: size.width * .05),

          ///Availability
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * .03),
            child: Text(
              '\u058E Availability',
              style: TextStyle(color: Colors.grey, fontSize: size.width * .05),
            ),
          ),

          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            horizontalTitleGap: 0,
            leading: Checkbox(
                value: _isChecked,
                checkColor: themeProvider.whiteBlackToggleColor(),
                fillColor:
                    MaterialStateProperty.all(themeProvider.orangeWhiteToggleColor()),
                onChanged: (bool newValue) {
                  setState(() {
                    _isChecked = newValue;
                    print(_isChecked);
                  });
                }),
            title: Text(
              'In Stock Only',
              style: TextStyle(
                  color: themeProvider.toggleTextColor(),
                  fontSize: size.width * .04),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * .03),
            child: Divider(color: Colors.grey, thickness: 0.5, height: 0.0),
          ),
          SizedBox(height: size.width * .05),

          ///Availability
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * .03),
            child: Text('\u058E Discount',
                style:
                    TextStyle(color: Colors.grey, fontSize: size.width * .05)),
          ),
          Column(
            children: [
              _radioTileBuilder(1, 'More than 10%', themeProvider, size),
              _radioTileBuilder(2, 'More than 20%', themeProvider, size),
              _radioTileBuilder(3, 'More than 30%', themeProvider, size),
              _radioTileBuilder(4, 'More than 40%', themeProvider, size),
              _radioTileBuilder(5, 'More than 50%', themeProvider, size),
              _radioTileBuilder(6, 'More than 60%', themeProvider, size),
              _radioTileBuilder(7, 'More than 70%', themeProvider, size),
              _radioTileBuilder(8, 'More than 80%', themeProvider, size),
              _radioTileBuilder(9, 'More than 90%', themeProvider, size),
            ],
          ),
          SizedBox(height: size.width * .04),

          ///Apply Button
          Container(
            height: size.width * .095,
            margin: EdgeInsets.symmetric(horizontal: size.width*.04),
            decoration: BoxDecoration(
                color: themeProvider.fabToggleBgColor(),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              child: Text(
                'Apply Filter',
                style: TextStyle(fontSize: size.width * .04),
              ),
              onPressed: () async{
                showLoadingDialog('Filtering...');
                Map map = {
                  "category_id": widget.categoryId,
                  "fetch_scope": "sub",
                  "filters": {
                    "price": _min.text.isNotEmpty && _max.text.isNotEmpty
                        ?"${_min.text}-${_max.text}"
                        :"",
                    "discount": _radioValue==0
                        ?"0"
                        :"${_radioValue.toString()}0",
                    "brand": [
                      "${_brand.text}"
                    ],
                    "size": [
                      "${_size.text.toUpperCase()}"
                    ],
                    "colors": [
                      "${_color.text.toUpperCase()}"
                    ],
                    "availability": _isChecked
                  }
                };
                await apiProvider.getCategoryProducts(map).then((value){
                  closeLoadingDialog();
                  Navigator.pop(context);
                });
              },
            ),
          ),
          SizedBox(height: size.width * .08),
        ],
      );

  Widget _radioTileBuilder(int radioValue, String hint,
          ThemeProvider themeProvider, Size size) =>
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        minVerticalPadding: 0.0,
        horizontalTitleGap: 0,
        dense: true,
        leading: Radio(
          fillColor:
          MaterialStateProperty.all(themeProvider.orangeWhiteToggleColor()),
          value: radioValue,
          groupValue: _radioValue,
          onChanged: (int change){
            setState(() {
              _radioValue = change;
              print('$_radioValue');
            });
          },
        ),
        title: Text(
          hint,
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .04),
        ),
      );
}
