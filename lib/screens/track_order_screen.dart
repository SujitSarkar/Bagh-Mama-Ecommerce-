import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TrackOrderScreen extends StatefulWidget {
  @override
  _TrackOrderScreenState createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.togglePageBgColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Track Your Order',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(themeProvider, size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider, Size size)=>Center(
    child: Container(
      height: size.width*.8,
      margin: EdgeInsets.symmetric(horizontal: size.width*.06),
      padding: EdgeInsets.symmetric(horizontal: size.width*.03),
      decoration: BoxDecoration(
        color: themeProvider.toggleCartColor(),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Track Your Order Now!',style: TextStyle(
                color: themeProvider.orangeWhiteToggleColor(),
                fontSize: size.width*.06
              ),),
              SizedBox(width: size.width*.03),
              Icon(FontAwesomeIcons.truck,size: size.width*.1,color: themeProvider.orangeWhiteToggleColor(),),
            ],
          ),
          SizedBox(height: size.width*.1),

          Container(
            height: size.width*.12,
            width: size.width*.8,
            decoration: BoxDecoration(
                color: themeProvider.whiteBlackToggleColor(),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.grey,width: 0.5)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: size.width*.5,
                  height: size.width*.15,
                  padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    style: TextStyle(
                        color: themeProvider.toggleTextColor(),
                        fontSize: size.width*.04
                    ),
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintText: 'Type your order no/invoice id here',
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
                  width: size.width*.25,
                  decoration: BoxDecoration(
                      color: themeProvider.fabToggleBgColor(),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      )
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: Size(size.width*.14, size.width*.4),
                    ),
                    child: Text('Get Status',style: TextStyle(fontSize: size.width*.04),),
                    onPressed: (){},
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
