import 'package:flutter/material.dart';

class ColorUtil {
  ColorUtil._();

  static final ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.deepOrange,
      primaryColor: Colors.deepOrange,
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        color: Colors.deepOrange,
      ),
      textSelectionColor: Colors.purpleAccent,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
      iconTheme: IconThemeData(color: Colors.black),
      dialogTheme: DialogTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))));

  static final ThemeData darkTheme = ThemeData(
      primarySwatch: Colors.deepOrange,
      primaryColor: Colors.deepOrange,
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        color: Colors.deepOrange,
      ),
      textSelectionColor: Colors.purpleAccent,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepOrange, foregroundColor: Colors.black),
      iconTheme: IconThemeData(color: Colors.white),
      dialogTheme: DialogTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))));
}
