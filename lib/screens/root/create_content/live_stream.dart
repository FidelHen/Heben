import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';

class LiveStream extends StatefulWidget {
  @override
  _LiveStreamState createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
  List<String> _tags = [
    '#Bodybuilding',
    '#Yoga',
    '#Vegan',
    '#Cardio',
    '#FitnessMotivation',
    '#FitGoals',
    '#Marathon',
    '#WeightLoss',
    '#FitFam',
    '#TransformationTuesday',
    '#HomeWorkout'
  ];

  @override
  void initState() {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    super.initState();
  }

  @override
  void dispose() {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        // switchCamera();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GFAppBar(
                  elevation: 0,
                  leading: IconButton(
                      icon: Icon(
                        EvaIcons.chevronLeft,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  brightness: Brightness.light,
                  backgroundColor: Colors.transparent,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 12.0, left: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 15, 10, 20),
                                child: Text(
                                  'Choose tags that describe your stream',
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Tags(
                                columns: 5,
                                horizontalScroll: false,
                                itemCount: _tags.length,
                                itemBuilder: (index) {
                                  return ItemTags(
                                    key: Key(index.toString()),
                                    active: false,
                                    index: index,
                                    title: _tags[index],
                                    textStyle: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    pressEnabled: true,
                                    activeColor: hebenActive,
                                    border:
                                        Border.all(color: Colors.transparent),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: DeviceSize().getWidth(context) / 15,
                        left: DeviceSize().getWidth(context) / 15,
                        bottom: 15),
                    child: Container(
                      width: DeviceSize().getWidth(context),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ArgonButton(
                              height: 50,
                              splashColor: Colors.transparent,
                              width: MediaQuery.of(context).size.width * 0.88,
                              color: hebenRed,
                              borderRadius: 11.0,
                              child: Text(
                                'Go live',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              loader: Container(
                                padding: EdgeInsets.all(10),
                                child: SpinKitDoubleBounce(
                                  color: Colors.white,
                                  // size: loaderWidth ,
                                ),
                              ),
                              onTap:
                                  (startLoading, stopLoading, btnState) async {
                                if (btnState == ButtonState.Idle) {
                                  if (btnState == ButtonState.Idle) {
                                    startLoading();
                                    await Future.delayed(Duration(seconds: 3));
                                    stopLoading();
                                  }
                                }
                              },
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   _manager.living(
        //       url:
        //           'rtmp://global-live.mux.com:5222/app/8321c32e-09c5-7e4d-c186-52bcc456d2eb');
        // }),
      ),
    );
  }
}
