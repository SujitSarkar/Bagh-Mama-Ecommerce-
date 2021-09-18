import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

class NagadPaymentWebView extends StatefulWidget {
  String initUrl;
  NagadPaymentWebView({@required this.initUrl});

  @override
  _NagadPaymentWebViewState createState() => _NagadPaymentWebViewState();
}

class _NagadPaymentWebViewState extends State<NagadPaymentWebView> {
  double progress = 0;

  _backPressed()async{
    Navigator.pop(context,false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return WillPopScope(
      onWillPop: ()async=> _backPressed(),
      child: Scaffold(
        backgroundColor: themeProvider.whiteBlackToggleColor(),
        appBar: AppBar(
          backgroundColor: themeProvider.whiteBlackToggleColor(),
          elevation: 0.0,
          leading: IconButton(
            onPressed: ()=> Navigator.pop(context,false),
            icon: Icon(Icons.arrow_back,color: Colors.grey),
          ),
          iconTheme: IconThemeData(
            color: Colors.grey,
          ),
          title: Text(
            'Complete Payment',
            style: TextStyle(
                color: themeProvider.toggleTextColor(),
                fontSize: size.width * .045),
          ),
        ),
        body: Container(
            child: Column(
                children: <Widget>[
                  if (progress != 1.0)
                    LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue)), // Should be removed while showing
                  Expanded(
                    child: Container(
                      child: InAppWebView(
                        initialUrlRequest: URLRequest(
                            url: Uri.parse(widget.initUrl.toString())),
                        onPageCommitVisible:
                            (InAppWebViewController controller, Uri uri) {
                          print(uri);
                          if (uri == Uri.parse('https://baghmama.com.bd/nagadSuccess')){
                            print(uri);
                            Navigator.pop(context, true);
                          }else if(uri == Uri.parse('https://baghmama.com.bd/nagadFailed')){
                            Navigator.pop(context, false);
                          }
                        },
                        onProgressChanged:
                            (InAppWebViewController controller, int progress) {
                          setState(() {
                            this.progress = progress / 100;
                          });
                        },
                      ),
                    ),
                  )
                  // ignore: unnecessary_null_comparison
                ].where((Object o) => o != null).toList())),
      ),
    );
  }
}
