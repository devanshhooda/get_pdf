import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_pdf/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/mainScreen.dart';

void main() async {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      bool themeValue = prefs.getBool('isDark') ?? true;
      setState(() {
        isDark = themeValue;
      });
    });
    return MaterialApp(
      home: MainScreen(),
      theme: ColorUtil.lightTheme,
      darkTheme: ColorUtil.darkTheme,
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
