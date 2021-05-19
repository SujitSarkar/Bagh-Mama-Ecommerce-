import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: themeProvider.toggleBgColor(),
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.wifi_exclamationmark,
              color: themeProvider.orangeWhiteToggleColor(),
              size: size.width*.4,
            ),
            Text(
              'No internet connection !',
              textAlign: TextAlign.center,
              style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.06),
            ),
            Text(
              'Connect your device to wifi or cellular data',
              textAlign: TextAlign.center,
              style:  TextStyle(color: Colors.grey[400],fontSize: size.width*.04),
            ),
            SizedBox(height: size.width*.05),

            TextButton(
                onPressed: ()=>themeProvider.checkConnectivity(),
                child: Text(
                  'Refresh',
                  style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.04),
                )
            )
          ],
        ),
      );
    }
    );
  }
}
