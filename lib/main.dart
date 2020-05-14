import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                bottomNavigationBar: BottomAppBar(
                  shape: CircularNotchedRectangle(),
                  notchMargin: 4.0,
                  child: Container(
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  EvaIcons.home,
                                  color: Colors.grey,
                                ),
                                onPressed: null,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 25.0),
                                child: IconButton(
                                  icon: Icon(
                                    EvaIcons.compass,
                                    color: Colors.grey,
                                  ),
                                  onPressed: null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: IconButton(
                                  icon: Icon(
                                    EvaIcons.bell,
                                    color: Colors.grey,
                                  ),
                                  onPressed: null,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  EvaIcons.person,
                                  color: Colors.grey,
                                ),
                                onPressed: null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: FloatingActionButton(
                  onPressed: null,
                  child: Image.asset(
                    'images/heben_logo_white.png',
                    scale: 35,
                  ),
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  highlightElevation: 2,
                ),
              );
            } else {
              if (snapshot.data != null) {
                FirebaseUser user = snapshot.data;
                Auth().redirectUser(uid: user.uid, context: context);
                return Scaffold(
                  bottomNavigationBar: BottomAppBar(
                    shape: CircularNotchedRectangle(),
                    notchMargin: 4.0,
                    child: Container(
                      height: 60,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    EvaIcons.home,
                                    color: Colors.grey,
                                  ),
                                  onPressed: null,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 25.0),
                                  child: IconButton(
                                    icon: Icon(
                                      EvaIcons.compass,
                                      color: Colors.grey,
                                    ),
                                    onPressed: null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 25.0),
                                  child: IconButton(
                                    icon: Icon(
                                      EvaIcons.bell,
                                      color: Colors.grey,
                                    ),
                                    onPressed: null,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    EvaIcons.person,
                                    color: Colors.grey,
                                  ),
                                  onPressed: null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: FloatingActionButton(
                    onPressed: null,
                    child: Image.asset(
                      'images/heben_logo_white.png',
                      scale: 35,
                    ),
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    elevation: 6,
                    highlightElevation: 2,
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
