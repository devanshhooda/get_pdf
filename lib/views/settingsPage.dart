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
          style: GoogleFonts.cantoraOne(),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  'Camera resolution : ${Constants.resolutions[_value.floor()]}'),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: LinearGradient(
                      colors: [Colors.white, Colors.deepOrangeAccent],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight)),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
    int resol = prefs.getInt(Constants.cameraResolution) ?? 0;
    setState(() {
      _value = resol.toDouble();
    });
  }
}
