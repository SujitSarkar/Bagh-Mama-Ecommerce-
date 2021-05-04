import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeThemePage extends StatefulWidget{
  @override
  _ChangeThemePageState createState() => _ChangeThemePageState();
}

class _ChangeThemePageState extends State<ChangeThemePage> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  final List<String> values= ['Light', 'Dark'];

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    super.initState();
  }
  // function to toggle circle animation
  changeThemeMode(bool theme) {
    if (!theme) {
      _animationController.forward(from: 0.0);
    } else {
      _animationController.reverse(from: 1.0);
    }
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return  Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeProvider.whiteBlackToggleColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text('Settings',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: width*.045
          ),),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: height * 0.1),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: width * 0.35,
                  height: width * 0.35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: themeProvider.themeMode().gradient,
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
                  ),
                ),
                Transform.translate(
                  offset: Offset(40, 0),
                  child: ScaleTransition(
                    scale: _animationController.drive(
                      Tween<double>(begin: 0.0, end: 1.0).chain(
                        CurveTween(curve: Curves.decelerate),
                      ),
                    ),
                    alignment: Alignment.topRight,
                    child: Container(
                      width: width * .26,
                      height: width * .26,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: themeProvider.isLight
                              ? Colors.white
                              : Color(0xFF26242e)),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: height * 0.05),
            Text(
              'Choose a Theme',
              style: TextStyle(
                  fontSize: width * .06, fontWeight: FontWeight.bold,color: themeProvider.toggleTextColor()),
            ),
            SizedBox(height: height * 0.03),
            Container(
              width: width * .6,
              child: Text(
                'Pop or subtle. Day or night. Customize your interface',
                textAlign: TextAlign.center,
                style: TextStyle(color: themeProvider.toggleTextColor()),
              ),
            ),
            SizedBox(height: height * 0.05),
            ZAnimatedToggle(
              values: ['Light', 'Dark'],
              onToggleCallback: (v) async {
                await themeProvider.toggleThemeData();
                setState(() {});
                changeThemeMode(themeProvider.isLight);
              },
            ),
            SizedBox(
              height: height * .05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildDot(
                  width: width * 0.022,
                  height: width * 0.022,
                  color: const Color(0xFFd9d9d9),
                ),
                buildDot(
                  width: width * 0.055,
                  height: width * 0.022,
                  color: themeProvider.isLight
                      ? Color(0xFF26242e)
                      : Colors.white,
                ),
                buildDot(
                  width: width * 0.022,
                  height: width * 0.022,
                  color: const Color(0xFFd9d9d9),
                ),
              ],
            ),
            // skip & next
            // Expanded(
            //   child: Container(
            //     margin: EdgeInsets.symmetric(
            //         vertical: height * 0.02, horizontal: width * 0.04),
            //     alignment: Alignment.bottomCenter,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: <Widget>[
            //         Padding(
            //           padding:
            //           EdgeInsets.symmetric(horizontal: width * 0.025),
            //           child: Text(
            //             'Skip',
            //             style: TextStyle(
            //               fontSize: width * 0.045,
            //               color: const Color(0xFF7c7b7e),
            //               fontFamily: 'Rubik',
            //             ),
            //           ),
            //         ),
            //
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // for drawing the dots
  Container buildDot({double width, double height, Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: width,
      height: height,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: color,
      ),
    );
  }
}
