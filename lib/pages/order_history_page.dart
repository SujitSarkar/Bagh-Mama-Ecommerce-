import 'package:bagh_mama/pages/order_details.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/order_history_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.togglePageBgColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Order History',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: apiProvider.userInfoModel.content.customerOrders.isEmpty
          ? Center(child: Text('No order placed by you !',style: TextStyle(
          color: themeProvider.toggleTextColor(),
          fontSize: size.width*.045
      ))): _bodyUI(themeProvider,apiProvider, size),
    );
  }

  _bodyUI(ThemeProvider themeProvider,APIProvider apiProvider, Size size)=>RefreshIndicator(
    onRefresh: ()async{
      SharedPreferences pref = await SharedPreferences.getInstance();
      await apiProvider.getUserInfo(pref.getString('username'));
    },
    color: themeProvider.fabToggleBgColor(),
    backgroundColor: themeProvider.togglePageBgColor(),
    child: ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: apiProvider.userInfoModel.content.customerOrders.length,
      itemBuilder: (context, index)=>InkWell(
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderDetails(
          orderId: apiProvider.userInfoModel.content.customerOrders[index].orderNo,
        ))),
          child: OrderHistoryTile(orderModel: apiProvider.userInfoModel.content.customerOrders[index])),
    ),
  );
}