import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:heben/screens/root/root.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return MaterialApp(
      themeMode: ThemeMode.light, // Change it as you want
      theme: ThemeData(
          splashColor: Colors.transparent,
          appBarTheme: AppBarTheme(brightness: Brightness.light)),
      darkTheme: ThemeData(
          splashColor: Colors.transparent,
          appBarTheme: AppBarTheme(brightness: Brightness.light)),
      debugShowCheckedModeBanner: false,

      title: 'Heben',
      home: Root(),
    );
  }
}
