import 'package:bagh_mama/pages/product_details_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/category_product_cart_tile.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewArrivalProductList extends StatefulWidget {

  @override
  _NewArrivalProductListState createState() => _NewArrivalProductListState();
}

class _NewArrivalProductListState extends State<NewArrivalProductList> {
  int _counter=0;
  int itemExtend=0;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future<void> _onRefresh(APIProvider apiProvider)async{
    await apiProvider.getAllProducts({"product_limit":102,"sort":"2"}).then((value){
      setState(()=> itemExtend = apiProvider.newArrivalProductModel.content.length+102);
    });
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading(APIProvider apiProvider) async{
    await apiProvider.getAllProducts({"product_limit":itemExtend,"sort":"2"}).then((value){
      _refreshController.refreshCompleted();
      setState(()=> itemExtend = apiProvider.newArrivalProductModel.content.length+102);
    });
    if(mounted)
      setState(() {});
    _refreshController.loadComplete();
  }

  Future<void> _customInit(APIProvider apiProvider)async{
    setState(()=>_counter++);
    if(apiProvider.newArrivalProductModel==null){
      await apiProvider.getAllProducts({"product_limit":102,"sort":"2"}).then((value){
        setState(()=> itemExtend = apiProvider.newArrivalProductModel.content.length+102);
      });
    }else{
      setState(()=> itemExtend = apiProvider.newArrivalProductModel.content.length+102);
    }
    print('Total Product: ${apiProvider.newArrivalProductModel.content.length}');
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    if(_counter==0) _customInit(apiProvider);

    return Scaffold(
      backgroundColor: themeProvider.togglePageBgColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'New Arrivals',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            physics: ClampingScrollPhysics(),
            header: WaterDropHeader(waterDropColor: themeProvider.fabToggleBgColor()),
            footer: CustomFooter(
              builder: (context, mode){
                Widget bdy;
                if(mode== LoadStatus.idle){
                  bdy = Text("pull up load");
                }
                else if(mode==LoadStatus.loading){
                  bdy =  Padding(
                    padding: EdgeInsets.all(10),
                    child: CupertinoActivityIndicator(),
                  );
                }
                else if(mode == LoadStatus.failed){
                  bdy = Text("Load Failed!");
                }
                else if(mode == LoadStatus.canLoading){
                  bdy = Text("release to load more");
                }
                else{
                  bdy = Text("No more Data");
                }
                return Container(
                  child: Center(
                    child: bdy,
                  ),
                );
              },
            ),
            controller: _refreshController,
            onRefresh:()=>_onRefresh(apiProvider),
            onLoading: ()=> _onLoading(apiProvider),
            child: apiProvider.newArrivalProductModel==null
                ?Center(child: threeBounce(themeProvider))
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: .65,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10
              ),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: apiProvider.newArrivalProductModel.content.length,
              itemBuilder: (context, index){
                return InkWell(
                    onTap: (){
                      print(apiProvider.newArrivalProductModel.content[index].id);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                        productId: apiProvider.newArrivalProductModel.content[index].id,
                        categoryId: apiProvider.newArrivalProductModel.content[index].categoryId,
                          isCampaign: false
                      )));
                    },
                    child: ProductCartTile(index: index,productsModel: apiProvider.newArrivalProductModel));
              },
            )),
      ),
    );
  }
}
