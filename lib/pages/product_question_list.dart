import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/product_question_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductQuestionList extends StatefulWidget {
  @override
  _ProductQuestionListState createState() => _ProductQuestionListState();
}

class _ProductQuestionListState extends State<ProductQuestionList> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.whiteBlackToggleColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Product Questions',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(themeProvider, size),

    );
  }

  Widget _bodyUI(ThemeProvider themeProvider, Size size)=>ListView(
    children: [
  Container(
  height: size.width*.12,
    width: size.width,
    margin: EdgeInsets.symmetric(horizontal: size.width*.03),
    decoration: BoxDecoration(
      color: themeProvider.whiteBlackToggleColor(),
      borderRadius: BorderRadius.all(Radius.circular(5)),
      border: Border.all(color: Colors.grey,width: 0.5)
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: size.width*.72,
          height: size.width*.15,
          padding: EdgeInsets.only(left: 10),
          child: TextField(
            style: TextStyle(
                color: themeProvider.toggleTextColor(),
                fontSize: size.width*.04
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: size.width*.038), //Change this value to custom as you like
              isDense: true,
              alignLabelWithHint: true,
              hintText: 'Ask a question',
              hintStyle: TextStyle(
                  color: themeProvider.toggleTextColor(),
                  fontSize: size.width*.04
              ),
              enabled: true,
              border: UnderlineInputBorder(
                  borderSide: BorderSide.none
              ),
            ),
          ),
        ),
        Container(
          width: size.width*.2,
          decoration: BoxDecoration(
              color: themeProvider.fabToggleBgColor(),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5)
              )
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              minimumSize: Size(size.width*.14, size.width*.4),
            ),
            child: Text('Submit',style: TextStyle(fontSize: size.width*.04),),
            onPressed: (){},
          ),
        )
      ],
    ),
  ),

      ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 20,
        itemBuilder: (context, index)=>ProductQuestionTile(index),
      ),
    ],
  );

}
