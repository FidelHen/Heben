import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:heben/screens/intro/onboarding/ask_info.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      themeMode: ThemeMode.light, // Change it as you want
      theme: ThemeData(
          splashColor: Colors.transparent,
          appBarTheme: AppBarTheme(brightness: Brightness.light)),
      darkTheme: ThemeData(
          splashColor: Colors.transparent,
          appBarTheme: AppBarTheme(brightness: Brightness.light)),
      debugShowCheckedModeBanner: false,

      title: 'Heben',
      home: AskInfo(),
    );
  }
}
