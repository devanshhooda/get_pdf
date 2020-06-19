import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'views/mainScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}
