import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.toggleBgColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.toggleBgColor(),
        leadingWidth: 0.0,
        leading: Icon(Icons.arrow_back,color: Colors.transparent),
        elevation: 0.0,
        title: Container(
          width: size.width,
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){},
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: Container(
                  height: 40,
                  width: size.width*.74,
                  // color: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      border: Border.all(width: 1,color: Colors.grey[400])
                  ),
                  child: TextField(
                    style: TextStyle(
                      color: themeProvider.toggleTextColor(),
                        fontSize: size.width*.04
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      prefixIcon: Icon(Icons.search,color: Colors.grey),
                      hintText: 'Search Product',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: size.width*.045
                    ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none
                      ),
                    ),
                    autofocus: true,
                  ),
                ),
              ),

              InkWell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 2),
                  child: Text('Cancel',style: TextStyle(color: Colors.grey,fontSize: size.width*.04),),
                ),
                onTap: ()=>Navigator.pop(context),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              )
            ],
          ),
        ),
      ),
      body: Container(),
    );
  }
}
