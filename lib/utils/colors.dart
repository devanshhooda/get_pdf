import 'package:flutter/material.dart';

class ColorUtil {
  ColorUtil._();

  static final ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.deepOrange,
      primaryColor: Colors.deepOrange,
      brightness: Brightness.light,
      // backgroundColor: Colors.white,
      accentColor: Colors.black,
      textSelectionColor: Colors.purpleAccent,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepOrange, foregroundColor: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
      dividerColor: Colors.white54,
      popupMenuTheme: PopupMenuThemeData(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      dialogTheme: DialogTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))));

  static final ThemeData darkTheme = ThemeData(
      primarySwatch: Colors.deepOrange,
      primaryColor: Colors.deepOrange,
      brightness: Brightness.dark,
      // backgroundColor: Colors.black,
      accentColor: Colors.white,
      textSelectionColor: Colors.purpleAccent,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
      dividerColor: Colors.black12,
      popupMenuTheme: PopupMenuThemeData(
          color: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      dialogTheme: DialogTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))));
}
