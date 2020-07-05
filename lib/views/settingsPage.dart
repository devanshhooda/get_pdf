import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_pdf/utils/constants.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _value = 0;
  SharedPreferences prefs;

  bool darkPdf = false, mobileView = false, spacing = false;

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
          style: GoogleFonts.amaranth(),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Camera Quality : ${Constants.resolutions[_value.floor()]}',
                textScaleFactor: 1.4,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      colors: [Colors.grey, Colors.blueGrey[400]],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight)),
              margin: EdgeInsets.all(20), // don't change this ever
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
              padding: EdgeInsets.all(20),
              child: Text('pdf Viewer Settings'),
            ),
            Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Text('DarkPDF:'),
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
            Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Text('MobileView:'),
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
            Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Text('Spacing:'),
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
    spacing = prefs.getBool(Constants.autoSpacing) ?? false;
    setState(() {
      _value = resol.toDouble();
    });
  }
}
