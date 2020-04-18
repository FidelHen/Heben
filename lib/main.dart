import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:heben/screens/intro/landing.dart';
import 'package:heben/utils/auth.dart';
import 'package:overlay_support/overlay_support.dart';

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
    return OverlaySupport(
      child: MaterialApp(
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
        home: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Scaffold(
                body: Center(
                  child: Container(
                    height: 50,
                    child: SpinKitThreeBounce(
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ),
              );
            } else {
              if (snapshot.data != null) {
                FirebaseUser user = snapshot.data;
                Auth().redirectUser(uid: user.uid, context: context);
                return Scaffold(
                  body: Center(
                    child: Container(
                      height: 50,
                      child: SpinKitThreeBounce(
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                );
              } else {
                return Landing();
              }
            }
          },
        ),
      ),
    );
  }
}
