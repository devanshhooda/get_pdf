import 'package:flutter/material.dart';

class ColorUtil {
  ColorUtil._();

  static final ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.orange,
      primaryColor: Colors.deepOrange,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      accentColor: Colors.black,
      textSelectionColor: Colors.purpleAccent,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Colors.deepOrange),
      dividerColor: Colors.white54,
      dialogTheme: DialogTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))));

  static final ThemeData darkTheme = ThemeData(
      primarySwatch: Colors.orange,
      primaryColor: Colors.deepOrange,
      brightness: Brightness.dark,
      backgroundColor: Colors.black,
      accentColor: Colors.white,
      textSelectionColor: Colors.purpleAccent,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Colors.deepOrangeAccent),
      dividerColor: Colors.black12,
      dialogTheme: DialogTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))));
}
