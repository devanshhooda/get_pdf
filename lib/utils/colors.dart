import 'package:flutter/material.dart';

class ColorUtil {

  ColorUtil._();

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.deepOrange,
    brightness: Brightness.light,
    backgroundColor: Color(0xfff2e0cb),
    accentColor: Colors.black,
    floatingActionButtonTheme: FloatingActionButtonThemeData(foregroundColor: Color(0xfff2e0cb)),
    dividerColor: Colors.white54,
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: Colors.black,
    accentColor: Color(0xfff2e0cb),
    floatingActionButtonTheme: FloatingActionButtonThemeData(foregroundColor: Colors.black),
    dividerColor: Colors.black12,
  );
}