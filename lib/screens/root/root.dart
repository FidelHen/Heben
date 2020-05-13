import 'dart:async';
import 'dart:io' show Platform;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:heben/screens/root/create_content/create_content.dart';
import 'package:heben/screens/root/explore/explore.dart';
import 'package:heben/screens/root/home/home.dart';
import 'package:heben/screens/root/notifications/notifications.dart';
import 'package:heben/screens/root/profile/profile.dart';
import 'package:heben/utils/auth.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/navigation.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  PageController _pageController;

  int pageIndex = 0;

  Color homeColor = Colors.black;
  Color discoverColor = Colors.grey;
  Color notificationsColor = Colors.grey;
  Color profileColor = Colors.grey;

  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  @override
  void initState() {
    if (Platform.isIOS) {
      Auth().saveDeviceToken();
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        Auth().saveDeviceToken();
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      Auth().saveDeviceToken();
    }
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    iosSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Home(),
          Explore(),
          Notifications(),
          Profile(),
        ],
        onPageChanged: onPageChanged,
      ),
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
                        color: homeColor,
                      ),
                      onPressed: () {
                        onTabTapped(0);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 25.0),
                      child: IconButton(
                        icon: Icon(
                          EvaIcons.compass,
                          color: discoverColor,
                        ),
                        onPressed: () {
                          onTabTapped(1);
                        },
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
                          color: notificationsColor,
                        ),
                        onPressed: () {
                          onTabTapped(2);
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        EvaIcons.person,
                        color: profileColor,
                      ),
                      onPressed: () {
                        onTabTapped(3);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigation()
              .segue(page: CreateContent(), context: context, fullScreen: true);
        },
        child: Image.asset(
          'images/heben_logo_white.png',
          scale: 35,
        ),
        backgroundColor: hebenRed,
        foregroundColor: Colors.white,
        elevation: 6,
        highlightElevation: 2,
      ),
    );
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _pageController.jumpToPage(index);

      if (pageIndex == 0) {
        _pageController.jumpToPage(0);
        Home().scrollToTop();
        homeColor = Colors.black;
        discoverColor = Colors.grey;
        notificationsColor = Colors.grey;
        profileColor = Colors.grey;
      } else if (pageIndex == 1) {
        _pageController.jumpToPage(1);
        Explore().scrollToTop();
        homeColor = Colors.grey;
        discoverColor = Colors.black;
        notificationsColor = Colors.grey;
        profileColor = Colors.grey;
      } else if (pageIndex == 2) {
        _pageController.jumpToPage(2);
        Notifications().scrollToTop();
        homeColor = Colors.grey;
        discoverColor = Colors.grey;
        notificationsColor = Colors.black;
        profileColor = Colors.grey;
      } else if (pageIndex == 3) {
        _pageController.jumpToPage(3);
        Profile().scrollToTop();
        homeColor = Colors.grey;
        discoverColor = Colors.grey;
        notificationsColor = Colors.grey;
        profileColor = Colors.black;
      }
    });
  }
}
