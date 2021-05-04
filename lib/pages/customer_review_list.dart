import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/product_review_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class CustomerReviewList extends StatefulWidget {
  @override
  _CustomerReviewListState createState() => _CustomerReviewListState();
}

class _CustomerReviewListState extends State<CustomerReviewList> {
  final Map<String, double> dataMap = {
    "\u2605": 60,
    "\u2605 \u2605": 340,
    "\u2605 \u2605 \u2605": 40,
    "\u2605 \u2605 \u2605 \u2605": 250,
    "\u2605 \u2605 \u2605 \u2605 \u2605": 30,
  };
  final List<Color> colorList = [
    Color(0xffFF5C6B),
    Color(0xffDBB049),
    Color(0xff7A5AB5),
    Color(0xff00D099),
    Color(0xff0094D4),
  ];
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
          'Customer Reviews',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(themeProvider, size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider, Size size)=> ListView(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        // color:  themeProvider.whiteBlackToggleColor(),
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 3000),
          chartLegendSpacing: 35,
          chartRadius: MediaQuery
              .of(context)
              .size
              .width * .4,
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: size.width*.06,
          centerText: "Ratings",
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendShape: BoxShape.circle,
            legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.toggleTextColor()
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            chartValueStyle: TextStyle(
              color: themeProvider.toggleTextColor()
            ),
            showChartValueBackground: false,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
            decimalPlaces: 0,
          ),
        ),
      ),
      SizedBox(height: size.width*.05),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Divider(color: Colors.grey,thickness: .5,),
      ),
      SizedBox(height: size.width*.05),

      ListView.builder(
        shrinkWrap: true,
        itemCount: 50,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context,index){
          return ProductReviewTile(index, 4);
        },
      )
    ],
  );
}
