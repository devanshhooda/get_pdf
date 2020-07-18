import 'package:flutter/material.dart';
import 'package:get_pdf/utils/sizeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_pdf/utils/constants.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _value = 0;
  SharedPreferences prefs;

  bool darkPdf = false, mobileView = false, spacing = true, fitImages = true;

  @override
  void initState() {
    initSP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'MedriendaOne',
          ),
        ),
      ),
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(SizeConfig.font_size * 3),
              child: Text(
                'Camera Quality : ${Constants.resolutions[_value.floor()]}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.font_size * 3),
              ),
            ),
            Container(
              height: SizeConfig.blockSizeVertical * 7.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      colors: [Colors.grey, Colors.blueGrey[400]],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight)),
              margin: EdgeInsets.all(SizeConfig.font_size * 2.5),
              child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.red[700],
                      inactiveTrackColor: Colors.red[100],
                      trackShape: RoundedRectSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      thumbColor: Colors.redAccent,
                      overlayColor: Colors.red.withAlpha(32),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: RoundSliderTickMarkShape(),
                      activeTickMarkColor: Colors.red[700],
                      inactiveTickMarkColor: Colors.red[100],
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.redAccent,
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                      )),
                  child: Slider(
                    value: _value,
                    onChanged: (val) {
                      onChangeResolution(val);
                    },
                    label: Constants.resolutions[_value.floor()],
                    divisions: 5,
                    min: 0,
                    max: 5,
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(SizeConfig.font_size * 3),
              child: Text(
                'PDF viewer settings :',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.font_size * 3),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockHorizontal * 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(SizeConfig.font_size * 2.5),
                      child: Text('Dark PDF'),
                    ),
                    Switch(
                      value: darkPdf,
                      onChanged: (value) async {
                        darkPdf = !darkPdf;
                        await prefs.setBool(Constants.darkPdf, darkPdf);
                        setState(() {});
                      },
                    ),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockHorizontal * 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(SizeConfig.font_size * 2.5),
                      child: Text('Mobile View'),
                    ),
                    Switch(
                      value: mobileView,
                      onChanged: (value) async {
                        mobileView = !mobileView;
                        await prefs.setBool(Constants.mobileView, mobileView);
                        setState(() {});
                      },
                    ),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockHorizontal * 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(SizeConfig.font_size * 2.5),
                      child: Text('Spacing'),
                    ),
                    Switch(
                      value: spacing,
                      onChanged: (value) async {
                        spacing = !spacing;
                        await prefs.setBool(Constants.autoSpacing, spacing);
                        setState(() {});
                      },
                    )
                  ]),
            ),
            Padding(
              padding: EdgeInsets.all(SizeConfig.font_size * 3),
              child: Text(
                'Image settings :',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.font_size * 3),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockHorizontal * 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(SizeConfig.font_size * 2.5),
                      child: Text('Fit images on pages'),
                    ),
                    Switch(
                      value: fitImages,
                      onChanged: (value) async {
                        fitImages = !fitImages;
                        await prefs.setBool(Constants.fitImages, fitImages);
                        setState(() {});
                      },
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  onChangeResolution(value) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    prefs.setInt(Constants.cameraResolution, value.floor());
    setState(() {
      _value = value;
    });
  }

  initSP() async {
    prefs = await SharedPreferences.getInstance();
    int resol = prefs.getInt(Constants.cameraResolution) ?? 2;
    darkPdf = prefs.getBool(Constants.darkPdf) ?? false;
    mobileView = prefs.getBool(Constants.mobileView) ?? false;
    spacing = prefs.getBool(Constants.autoSpacing) ?? true;
    fitImages = prefs.getBool(Constants.fitImages) ?? true;
    setState(() {
      _value = resol.toDouble();
    });
  }
}
