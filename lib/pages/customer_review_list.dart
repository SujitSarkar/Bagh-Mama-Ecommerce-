import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
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
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
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
      body: _bodyUI(themeProvider,apiProvider,size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider,APIProvider apiProvider, Size size)=> ListView(
    physics: BouncingScrollPhysics(),
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        // color:  themeProvider.whiteBlackToggleColor(),
        child: PieChart(
          dataMap: {
            "\u2605": double.parse(apiProvider.productInfoModel.content.rating.totalRating1.toString()),
            "\u2605 \u2605": double.parse(apiProvider.productInfoModel.content.rating.totalRating2.toString()),
            "\u2605 \u2605 \u2605": double.parse(apiProvider.productInfoModel.content.rating.totalRating3.toString()),
            "\u2605 \u2605 \u2605 \u2605": double.parse(apiProvider.productInfoModel.content.rating.totalRating4.toString()),
            "\u2605 \u2605 \u2605 \u2605 \u2605": double.parse(apiProvider.productInfoModel.content.rating.totalRating5.toString()),
          },
          animationDuration: Duration(milliseconds: 3000),
          chartLegendSpacing: 35,
          chartRadius: size.width * .4,
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

      apiProvider.productReviewList.isEmpty
          ?Center(child: Text('No Reviews Yet !',
          style: TextStyle(color: themeProvider.toggleTextColor())))
          :ListView.builder(
        shrinkWrap: true,
        itemCount: apiProvider.productReviewList.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context,index){
          return ProductReviewTile(index);
        },
      )
    ],
  );
}
