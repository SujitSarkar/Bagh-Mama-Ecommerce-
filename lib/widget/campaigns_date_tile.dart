import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
        int remainingSec = campaignList[index].endIn.difference(DateTime.now()).inSeconds;
        int day = remainingSec~/(24*3600);
        remainingSec = remainingSec%(24*3600);
        int hours= remainingSec~/3600;
        remainingSec%=3600;
        int minute=remainingSec~/60;
        remainingSec%=60;
        int second = remainingSec;
        return Container(
          margin: EdgeInsets.only(bottom: 15,left: size.width*.03,right: size.width*.03),
          child: Stack(
            children: [
              ///Thumbnail Image
              CachedNetworkImage(
                  imageUrl:campaignList[index].banner,
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
                  width: size.width*.4,
                  height: size.width*.09,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: size.width*.01),
                 decoration: BoxDecoration(
                   color: Colors.black.withOpacity(0.7),
                   borderRadius: BorderRadius.all(Radius.circular(size.width*.3))
                 ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                  child: Text('${campaignList[index].campaignTitle}',
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
