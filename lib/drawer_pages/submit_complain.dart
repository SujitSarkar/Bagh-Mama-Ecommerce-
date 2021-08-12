import 'package:bagh_mama/pages/no_internet_page.dart';
import 'package:bagh_mama/provider/api_provider.dart';
import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubmitComplain extends StatefulWidget {
  final String question;
  const SubmitComplain({Key key,this.question}) : super(key: key);

  @override
  _SubmitComplainState createState() => _SubmitComplainState();
}

class _SubmitComplainState extends State<SubmitComplain> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _subject = TextEditingController();
  TextEditingController _addiMgs = TextEditingController();
  bool _isLoading=false;
  int _counter=0;

  @override
  void initState() {
    super.initState();
    _subject.text = widget.question;
  }
  _customInit(ThemeProvider themeProvider,APIProvider apiProvider)async{
    setState(()=>_counter++);
    SharedPreferences pref = await SharedPreferences.getInstance();
    _name.text =pref.getString('name')??'';
    _email.text =pref.getString('username')??'';
    _mobile.text =pref.getString('mobile')??'';
    //themeProvider.checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final APIProvider apiProvider = Provider.of<APIProvider>(context);
    if(themeProvider.internetConnected && _counter==0) _customInit(themeProvider,apiProvider);

    return Scaffold(
      backgroundColor: themeProvider.whiteBlackToggleColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'New Support Ticket',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: themeProvider.internetConnected? _bodyUI(themeProvider,apiProvider, size):NoInternet(),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider,APIProvider apiProvider, Size size)=>SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width*.03),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.width * .04),
              _textFieldBuilder(themeProvider, size, 'Your full name'),
              SizedBox(height: size.width * .04),
              _textFieldBuilder(themeProvider, size, 'Your email address'),
              SizedBox(height: size.width * .04),
              _textFieldBuilder(themeProvider, size, 'Your mobile number'),
              SizedBox(height: size.width * .04),
              _textFieldBuilder(themeProvider, size, 'Subject'),
              SizedBox(height: size.width * .04),
              _textFieldBuilder(themeProvider, size, 'Additional message'),
              SizedBox(height: size.width * .07),

              _isLoading?threeBounce(themeProvider): ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
                  ),
                  onPressed: ()async{
                    _formValidation(apiProvider,themeProvider,size);
                    // await themeProvider.checkConnectivity().then((value){
                    //   if(themeProvider.internetConnected==true) _formValidation(apiProvider,themeProvider,size);
                    //   else showErrorMgs('No internet connection!');
                    // },onError: (error)=>showErrorMgs(error.toString()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Submit',style: TextStyle(fontSize: size.width*.04),),
                    ],
                  )
              )
            ],
          )
      )
  );

  void _formValidation(APIProvider apiProvider,ThemeProvider themeProvider,Size size){
    if(_name.text.isNotEmpty && _email.text.isNotEmpty&& _mobile.text.isNotEmpty
    && _addiMgs.text.isNotEmpty && widget.question.isNotEmpty){
      setState(()=>_isLoading=true);
      Map map = {
        "fullname":_name.text,
        "email":_email.text,
        "mobile_number":_mobile.text,
        "subject":widget.question,
        "message":_addiMgs.text};
      apiProvider.createSupportTicket(map).then((mgs){
          setState(()=>_isLoading=false);
          _showResultDialog(size, themeProvider, mgs);
      });
    }else showInfo('Complete all required field');
  }

  Widget _textFieldBuilder(
      ThemeProvider themeProvider, Size size, String hint) =>
      TextFormField(
        controller: hint=='Your full name'?_name
            :hint=='Your email address'?_email
            :hint=='Your mobile number'?_mobile
            :hint=='Subject'?_subject:_addiMgs,
        readOnly: hint=='Subject'?true:false,
        style: TextStyle(
            color: themeProvider.toggleTextColor(), fontSize: size.width * .04),
        decoration: boxFormDecoration(size).copyWith(
          labelText: hint,
          contentPadding: EdgeInsets.symmetric(vertical: size.width*.038,horizontal: size.width*.038), //Change this value to custom as you like
          isDense: true,
        ),
      );

  void _showResultDialog(Size size, ThemeProvider themeProvider, String message){
    showAnimatedDialog(
        context: context,
        animationType: DialogTransitionType.slideFromBottomFade,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 500),
        builder: (context){
          return AlertDialog(
            backgroundColor: themeProvider.toggleBgColor(),
            contentPadding: EdgeInsets.symmetric(horizontal: size.width*.04),
            scrollable: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Status',style: TextStyle(fontSize: size.width*.05,fontWeight: FontWeight.w500,color: themeProvider.toggleTextColor()),),
                    IconButton(
                      icon: Icon(Icons.cancel_outlined,color: Colors.grey,size: size.width*.06,),
                      onPressed: (){Navigator.pop(context);},
                      splashRadius: size.width*.05,
                    )
                  ],
                ),
                SizedBox(height: size.width*.05),

                Html(
                    data: """$message""",
                  style:{
                    'strong':Style(
                        color: themeProvider.toggleTextColor()
                    ),
                    'body':Style(
                        color: themeProvider.toggleTextColor()
                    ),
                  },
                ),
                SizedBox(height: size.width*.05),
              ],
            ),
          );
        });
  }
}
