import 'package:bagh_mama/pages/campaign_product_list.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/campaigns_date_tile.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CampaignsListPage extends StatefulWidget {

  @override
  _CampaignsListPageState createState() => _CampaignsListPageState();
}

class _CampaignsListPageState extends State<CampaignsListPage> {
  int _counter=0;
  bool _isLoading=false;

  void _customInit(APIProvider apiProvider)async{
    setState((){
      _counter++;
      _isLoading=true;
    });
    if(apiProvider.campaignsDateModel==null)
    await apiProvider.getCampaignsDate();
    setState(()=> _isLoading=false);

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
          'Campaigns',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _isLoading
          ?Center(child: threeBounce(themeProvider))
          :Container(
          child: apiProvider.campaignsDateModel!=null? RefreshIndicator(
            color: themeProvider.fabToggleBgColor(),
            backgroundColor: themeProvider.togglePageBgColor(),
            onRefresh: ()async{
              await apiProvider.getCampaignsDate();
            },
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: apiProvider.campaignsDateModel.content.length,
              itemBuilder: (context, index)=>InkWell(
                  onTap: (){
                    if(DateTime.now().millisecondsSinceEpoch>apiProvider.campaignsDateModel.content[index].endIn.millisecondsSinceEpoch){
                      showToast('Campaign Expired');
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CampaignProductList(
                        dealId: apiProvider.campaignsDateModel.content[index].dealId,
                        startFrom: apiProvider.campaignsDateModel.content[index].startFrom,
                        endIn: apiProvider.campaignsDateModel.content[index].endIn,
                      )));
                    }
                  },
                  child: CampaignDateTile(index: index,campaignList: apiProvider.campaignsDateModel.content[index])),
            ),
          ):Center(child: Text('No Campaigns !',
              style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.04)))
      ),
    );
  }
}
