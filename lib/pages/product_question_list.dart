import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

// ignore: must_be_immutable
class ProductQuestionList extends StatefulWidget {
  int productId;
  ProductQuestionList({this.productId});

  @override
  _ProductQuestionListState createState() => _ProductQuestionListState();
}

class _ProductQuestionListState extends State<ProductQuestionList> {
  TextEditingController _replyText= TextEditingController(text: '');
  TextEditingController _quesText= TextEditingController(text: '');
  int replyIndex;

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
          'Product Questions',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(themeProvider,apiProvider, size),

    );
  }

  Widget _bodyUI(ThemeProvider themeProvider,APIProvider apiProvider, Size size)=>ListView(
    children: [
  Container(
  height: size.width*.12,
    width: size.width,
    margin: EdgeInsets.symmetric(horizontal: size.width*.03),
    decoration: BoxDecoration(
      color: themeProvider.whiteBlackToggleColor(),
      borderRadius: BorderRadius.all(Radius.circular(5)),
      border: Border.all(color: Colors.grey,width: 0.5)
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: size.width*.72,
          height: size.width*.15,
          padding: EdgeInsets.only(left: 10),
          child: TextField(
            controller: _quesText,
            style: TextStyle(
                color: themeProvider.toggleTextColor(),
                fontSize: size.width*.04
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: size.width*.038), //Change this value to custom as you like
              isDense: true,
              alignLabelWithHint: true,
              hintText: 'Ask a question',
              hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: size.width*.04
              ),
              enabled: true,
              border: UnderlineInputBorder(
                  borderSide: BorderSide.none
              ),
            ),
          ),
        ),
        Container(
          width: size.width*.2,
          decoration: BoxDecoration(
              color: themeProvider.fabToggleBgColor(),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5)
              )
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              minimumSize: Size(size.width*.14, size.width*.4),
            ),
            child: Text('Submit',style: TextStyle(fontSize: size.width*.04),),
            onPressed: ()async{
              SharedPreferences pref =await SharedPreferences.getInstance();
              if(pref.getString('username')!=null){
                 if(_quesText.text.isNotEmpty){
                   showLoadingDialog('Please Wait');
                   Map map = {
                     "qid":null,
                     "name":pref.getString('name'),
                     "email":pref.getString('username'),
                     "message":_quesText.text,
                     "prid":"${widget.productId}"};
                   await apiProvider.replyProductQuestion(map).then((value)async{
                     if(value){
                       await apiProvider.getProductInfo(widget.productId);
                       closeLoadingDialog();
                       showSuccessMgs('Success');
                       _quesText.clear();
                     }else{
                       closeLoadingDialog();
                       showErrorMgs('Failed !');
                     }
                   });
                 }else showInfo('Write Your Question');
              }else Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
            },
          ),
        )
      ],
    ),
  ),
      ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: apiProvider.productQuestionList.length,
        itemBuilder: (context, index)=>_questionCartTile(themeProvider, apiProvider, size, index),
      ),
    ],
  );

  Widget _questionCartTile(ThemeProvider themeProvider, APIProvider apiProvider, Size size, int index){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Image Container
              Container(
                height: size.width * .15,
                width: size.width * .15,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  //color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Colors.grey,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  child: Image.asset('assets/user.PNG',fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: size.width*.02),

              ///Name & time Container
              Container(
                alignment: Alignment.topLeft,
                padding:
                const EdgeInsets.only(top: 5, bottom: 5),
                width: size.width * .77,
                //height: 65,
                //color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      apiProvider.productQuestionList[index].name,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: size.width*.04,
                          color: themeProvider.toggleTextColor(),
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 3),
                    Text(
                      apiProvider.productQuestionList[index].date.toString(),
                      maxLines: 2,
                      style: TextStyle(
                          fontSize:  size.width*.034, color: Colors.grey[600]),
                    )
                  ],
                ),
              ),
            ],
          ),

          ///Review Text Container
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            width: size.width * .95,
            child:
            ExpandableText(
              apiProvider.productQuestionList[index].qusText,
              expandText: 'more',
              collapseText: 'less',
              maxLines: 3,
              linkColor: Colors.grey[600],
              textAlign: TextAlign.justify,
              style: TextStyle(color: themeProvider.toggleTextColor(), fontSize:  size.width*.035),
            ),),

          apiProvider.productQuestionList[index].replies.isNotEmpty
              ?Text('Replies (${apiProvider.productQuestionList[index].replies.length})',
              style: TextStyle(
                  fontSize: size.width*.04,
                  color: themeProvider.toggleTextColor(),
                  fontWeight: FontWeight.w500))
              :Container(),
          apiProvider.productQuestionList[index].replies.isNotEmpty
              ?ListView.builder(
            itemCount: apiProvider.productQuestionList[index].replies.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context,ind){
              return Padding(
                padding: EdgeInsets.only(left: size.width*.05),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                      const EdgeInsets.only(top: 5, bottom: 5),
                      width: size.width * .77,
                      //height: 65,
                      //color: Colors.blue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            apiProvider.productQuestionList[index].replies[ind].name,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: size.width*.04,
                                color: themeProvider.toggleTextColor(),
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 3),
                          Text(
                            apiProvider.productQuestionList[index].replies[ind].date.toString(),
                            maxLines: 2,
                            style: TextStyle(
                                fontSize:  size.width*.034, color: Colors.grey[600]),
                          ),
                          ExpandableText(
                            apiProvider.productQuestionList[index].replies[ind].qusText,
                            expandText: 'more',
                            collapseText: 'less',
                            maxLines: 3,
                            linkColor: Colors.grey[600],
                            textAlign: TextAlign.justify,
                            style: TextStyle(color: themeProvider.toggleTextColor(),
                                fontSize:  size.width*.035),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ):Container(),
          Padding(
            padding: EdgeInsets.only(left: size.width*.11,top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: size.width*.7,
                  child: TextFormField(
                    controller: index==replyIndex? _replyText:null,
                    onTap: (){
                      setState(() {
                        replyIndex=index;
                      });
                    },
                    style: TextStyle(
                        color: themeProvider.toggleTextColor(),
                        fontSize: size.width*.04
                    ),
                    decoration: boxFormDecoration(size).copyWith(
                      labelText: 'Write a Reply',
                      contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                      isDense: true,
                      enabled: true,
                      labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: size.width*.04
                      ),
                    ),
                  ),
                ),
                Container(
                  width: size.width*.1,
                  child: InkWell(
                    onTap: ()async{
                      SharedPreferences pref =await SharedPreferences.getInstance();
                      if(pref.getString('username')!=null){
                        if(_replyText.text.isNotEmpty){
                          showLoadingDialog('Please Wait');
                          Map map = {
                            "qid":"${apiProvider.productQuestionList[index].qusId}",
                            "name":pref.getString('name'),
                            "email":pref.getString('username'),
                            "message":_replyText.text,
                            "prid":"${widget.productId}"};
                          await apiProvider.replyProductQuestion(map).then((value)async{
                            if(value){
                              await apiProvider.getProductInfo(widget.productId);
                              closeLoadingDialog();
                              showSuccessMgs('Success');
                              _replyText.clear();
                            }else{
                              closeLoadingDialog();
                              showErrorMgs('Failed !');
                            }
                          });
                        }else showInfo('Write a reply');
                      }else Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                    },
                    child:Icon(Icons.send,
                        size: size.width*.09,
                        color: themeProvider.fabToggleBgColor()),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}
