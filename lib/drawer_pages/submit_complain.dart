import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:bagh_mama/widget/form_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubmitComplain extends StatefulWidget {
  final String question;
  const SubmitComplain({Key key,this.question}) : super(key: key);

  @override
  _SubmitComplainState createState() => _SubmitComplainState();
}

class _SubmitComplainState extends State<SubmitComplain> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _addiMgsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subjectController.text = widget.question;
  }

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
          'New Support Ticket',
          style: TextStyle(
              color: themeProvider.toggleTextColor(),
              fontSize: size.width * .045),
        ),
      ),
      body: _bodyUI(themeProvider, size),
    );
  }

  Widget _bodyUI(ThemeProvider themeProvider, Size size)=>SingleChildScrollView(
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

              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(themeProvider.fabToggleBgColor())
                  ),
                  onPressed: (){},
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

  Widget _textFieldBuilder(
      ThemeProvider themeProvider, Size size, String hint) =>
      TextFormField(
        controller: hint=='Your full name'?_nameController
            :hint=='Your email address'?_addressController
            :hint=='Your mobile number'?_mobileController
            :hint=='Subject'?_subjectController:_addiMgsController,
        readOnly: hint=='Subject'?true:false,
        style: TextStyle(
            color: themeProvider.toggleTextColor(), fontSize: size.width * .04),
        decoration: boxFormDecoration.copyWith(
          labelText: hint,
          labelStyle:
          TextStyle(color: Colors.grey, fontSize: size.width * .04),
          contentPadding: EdgeInsets.symmetric(vertical: size.width*.038,horizontal: size.width*.038), //Change this value to custom as you like
          isDense: true,
        ),
      );
}
