import 'package:bagh_mama/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key key}) : super(key: key);

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
          'About Us',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: size.width*.03),
          Text('About Us',style: TextStyle(color: themeProvider.toggleTextColor(),fontSize: size.width*.07,fontWeight: FontWeight.w500,),),
          SizedBox(height: size.width*.05),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              //text: 'Hello ',
              style: TextStyle(fontSize: size.width*.038,color: themeProvider.toggleTextColor()),
              children: <TextSpan>[
                TextSpan(text: 'Welcome to Shop, your number one source for all '
                    'things [product, ie: shoes, bags, dog treats]. We\'re '
                    'dedicated to giving you the very best of [product], with a '
                    'focus on [three characteristics, ie: dependability, '
                    'customer service, and uniqueness.]\n\n'),
                TextSpan(text: 'Founded in [year] by [founder\'s name], [store '
                    'name] has come a a long way from its beginnings in a [starting '
                    'location, ie: home office, toolshed, Houston, TX.]. When [store '
                    'founder] first started out, his/her passion for [passion of the '
                    'founder, ie: helping other parents be more eco-friendly, providing '
                    'the best equipment for his fellow musicians] drove him to [action, '
                    'ie: do intense research, quit her day job], and gave him the '
                    'impetus to turn hard work and inspiration into a booming online '
                    'store. We now serve customers all over [place, ie: the US, the '
                    'world, the Austin area], and are thrilled to be a part of the '
                    '[adjective, ie: quirky, eco-friendly, fair trade] wing of the '
                    '[industry type, ie: fashion, baked goods, watch] industry.\n\n'),
                TextSpan(text: 'We hope you enjoy our products as much as we enjoy'
                    ' offering them to you. If you have any questions or comments, '
                    'please don\'t hesitate to contact us.\n\n\n'),
                TextSpan(text: 'Sincerely,\n'),
                TextSpan(text: 'Md. Rifat Rana'),

              ],
            ),
          ),
        ],
      ),
    ),
  );
}

