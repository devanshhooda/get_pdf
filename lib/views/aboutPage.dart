import 'package:flutter/material.dart';
import 'package:get_pdf/utils/sizeConfig.dart';

class AboutPage extends StatelessWidget {
  final TextStyle _appNameStyle = TextStyle(
      fontFamily: 'Anton',
      fontStyle: FontStyle.italic,
      fontSize: SizeConfig.font_size * 4,
      letterSpacing: 3,
      color: Colors.indigo);

  final TextStyle _normalTextStyle = TextStyle(
      fontFamily: 'MedriendaOne',
      fontSize: SizeConfig.font_size * 3,
      color: Colors.black);

  final TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'MedriendaOne',
      fontStyle: FontStyle.italic,
      fontSize: SizeConfig.font_size * 3.5,
      color: Colors.deepPurple);

  Widget _backButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: SizeConfig.safeBlockHorizontal * 75,
          top: SizeConfig.safeBlockVertical * 6),
      child: CircleAvatar(
        child: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.amber, Colors.deepOrangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 0,
              child: _backButton(context),
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.safeBlockHorizontal * 15),
                child: ListView(
                  children: <Widget>[
                    Text(
                      'Indocanner',
                      style: _appNameStyle,
                    ),
                    Text(
                      'is a document scanning app which is purely Made In India and can be used to keep your documents/notes safe in your device as a PDF.',
                      style: _normalTextStyle,
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'It offers the features like ',
                            style: _normalTextStyle,
                            children: [
                          TextSpan(
                            text: 'deleting',
                            style: TextStyle(color: Colors.pink),
                          ),
                          TextSpan(
                              text: ' multiple documents or ',
                              style: _normalTextStyle),
                          TextSpan(
                              text: 'sharing ',
                              style: TextStyle(color: Colors.green[700])),
                          TextSpan(
                              text: 'them to different platforms.',
                              style: _normalTextStyle)
                        ])),
                    Container(
                      height: 200,
                      margin: EdgeInsets.symmetric(
                          vertical: SizeConfig.safeBlockVertical * 2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                              image: AssetImage('assets/indocanner-logo.png'),
                              fit: BoxFit.cover)),
                    ),
                    Text(
                      'This app is',
                      style: _normalTextStyle,
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(
                            vertical: SizeConfig.safeBlockVertical * 2),
                        padding: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical * 2,
                            bottom: SizeConfig.safeBlockVertical * 2,
                            left: SizeConfig.safeBlockHorizontal * 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.deepOrange,
                                  Colors.white,
                                  Colors.green
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                        child: Text(
                          'Made with ❤ in India',
                          style: TextStyle(
                              letterSpacing: 2,
                              fontFamily: 'Anton',
                              fontSize: SizeConfig.font_size * 3,
                              color: Colors.black),
                        )),
                    Text(
                        'in context of      ATMANIRBHAR BHARAT       by two Computer Science undergraduates:',
                        style: _normalTextStyle),
                    Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical * 1),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Devansh',
                            style: _nameTextStyle,
                          ),
                          SelectableText(
                            'linkedin.com/in/devansh-hooda-670a76182',
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: SizeConfig.font_size * 2,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 2,
                          ),
                          Text(
                            'Vivek',
                            style: _nameTextStyle,
                          ),
                          SelectableText(
                            'linkedin.com/in/vivek-kumar-gupta-216b92114',
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: SizeConfig.font_size * 2,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 5,
                          ),
                          Text(
                            'Contact us here : ',
                            style: _normalTextStyle,
                          ),
                          SizedBox(height: SizeConfig.safeBlockVertical * 1),
                          SelectableText('thecrylocompany@gmail.com'),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 4,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
