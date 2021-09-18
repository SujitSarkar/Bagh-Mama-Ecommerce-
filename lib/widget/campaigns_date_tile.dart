import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CampaignDateTile extends StatelessWidget {
  int index;
  var campaignList;
  CampaignDateTile({this.index,this.campaignList});


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 1), (i) => i),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot){
        int remainingSec, day,hours,minute,second;

        if(DateTime.now().millisecondsSinceEpoch>campaignList.startFrom.millisecondsSinceEpoch){

          remainingSec = campaignList.endIn.difference(DateTime.now()).inSeconds;
          day = remainingSec~/(24*3600);
          remainingSec = remainingSec%(24*3600);
          hours= remainingSec~/3600;
          remainingSec%=3600;
          minute=remainingSec~/60;
          remainingSec%=60;
          second = remainingSec;
        }else{
          remainingSec = campaignList.startFrom.difference(DateTime.now()).inSeconds;
          day = remainingSec~/(24*3600);
          remainingSec = remainingSec%(24*3600);
          hours= remainingSec~/3600;
          remainingSec%=3600;
          minute=remainingSec~/60;
          remainingSec%=60;
          second = remainingSec;
        }

        return Container(
          margin: EdgeInsets.only(bottom: 15,left: size.width*.03,right: size.width*.03),
          child: Stack(
            children: [
              ///Thumbnail Image
              CachedNetworkImage(
                  imageUrl:campaignList.banner,
                  placeholder: (context, url) => Image.asset('assets/placeholder.png',
                      height: size.width*.5,
                      width: size.width,
                      fit: BoxFit.cover),
                  errorWidget: (context, url, error) => Image.asset('assets/placeholder.png',
                      height: size.width*.5,
                      width: size.width,
                      fit: BoxFit.cover),
                  height: size.width*.5,
                  width: size.width,
                  fit: BoxFit.contain,
                ),

              ///Top Counter
              Positioned(
                top: size.width*.02,
                right:size.width*.02,
                child: Container(
                  width:DateTime.now().millisecondsSinceEpoch>campaignList.endIn.millisecondsSinceEpoch
                      ?size.width*.2: size.width*.45,
                  height: size.width*.09,
                  alignment: DateTime.now().millisecondsSinceEpoch>campaignList.endIn.millisecondsSinceEpoch
                      ?Alignment.center: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: size.width*.01),
                 decoration: BoxDecoration(
                   color: Colors.black.withOpacity(0.7),
                   borderRadius: BorderRadius.all(Radius.circular(size.width*.3))
                 ),
                  child: DateTime.now().millisecondsSinceEpoch>campaignList.endIn.millisecondsSinceEpoch
                      ? Text('Expired',textAlign:TextAlign.center,style: _counterTitleStyle(size))
                      : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DateTime.now().millisecondsSinceEpoch>campaignList.startFrom.millisecondsSinceEpoch
                          ?Container()
                          :Text('Starts in ',style: _counterTitleStyle(size)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Day',style: _counterTitleStyle(size)),
                          Text('$day',style: _counterContentStyle(size)),
                        ],
                      ),Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Hours',style: _counterTitleStyle(size)),
                          Text('$hours',style: _counterContentStyle(size)),
                        ],
                      ),Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Min',style: _counterTitleStyle(size)),
                          Text('$minute',style: _counterContentStyle(size)),
                        ],
                      ),Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Sec',style: _counterTitleStyle(size)),
                          Text('$second',style: _counterContentStyle(size)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ///Footer Title
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: size.width*.03),
                  height: size.width*.08,
                  color: Colors.black.withOpacity(0.7),
                  child: Text('${campaignList.campaignTitle}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width*.04
                  )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  TextStyle _counterTitleStyle(Size size)=> TextStyle(
        color: Colors.white,
        fontSize: size.width*.03
    );
  TextStyle _counterContentStyle(Size size)=> TextStyle(
      color: Colors.deepOrange,
      fontSize: size.width*.03,
    fontWeight: FontWeight.bold
  );
}
