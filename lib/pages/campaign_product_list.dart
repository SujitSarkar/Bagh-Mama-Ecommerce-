import 'package:bagh_mama/pages/product_details_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/category_product_cart_tile.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CampaignProductList extends StatefulWidget {
  String dealId;
  CampaignProductList({this.dealId});

  @override
  _CampaignProductListState createState() => _CampaignProductListState();
}

class _CampaignProductListState extends State<CampaignProductList> {
  bool _isLoading=false;
  int _counter=0;

  void _customInit(APIProvider apiProvider)async{
    setState((){
      _counter++;
      _isLoading=true;
    });
      Map map = {"campaign_id": widget.dealId};
      await apiProvider.getCampaignProductList(map).then((value){
        setState(()=>_isLoading=false);
      });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    if(_counter==0) _customInit(apiProvider);

    return Scaffold(
      backgroundColor: themeProvider.whiteBlackToggleColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Campaign Products',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(size,themeProvider,apiProvider),
    );
  }

  Widget  _bodyUI(Size size, ThemeProvider themeProvider, APIProvider apiProvider)=> _isLoading
      ?Center(child: threeBounce(themeProvider))
      :apiProvider.campaignProductModel.content.isEmpty
      ?Center(child: Text('No Product Found!',
      style: TextStyle(color: themeProvider.toggleTextColor())))
      : Container(
    // height: size.height,
    color: themeProvider.togglePageBgColor(),
    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
    child: RefreshIndicator(
      color: themeProvider.fabToggleBgColor(),
      backgroundColor: themeProvider.togglePageBgColor(),
      onRefresh: ()async{
        Map map = {"campaign_id": widget.dealId};
        await apiProvider.getCampaignProductList(map);
      },
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: .65,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10
        ),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: apiProvider.campaignProductModel.content.length,
        itemBuilder: (context, index){
          return InkWell(
              onTap: (){
                print(apiProvider.campaignProductModel.content[index].id);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                  productId: apiProvider.campaignProductModel.content[index].id,
                  categoryId: apiProvider.campaignProductModel.content[index].categoryId,
                  isCampaign: true
                )));
              },
              child: ProductCartTile(index: index,productsModel: apiProvider.campaignProductModel));
        },
      ),
    ),
  );
}
