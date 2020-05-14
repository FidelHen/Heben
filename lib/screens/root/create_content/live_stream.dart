import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/build/build_content.dart';
import 'package:heben/models/content_items.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LiveStream extends StatefulWidget {
  @override
  _LiveStreamState createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
  bool streamStarted;
  double _itemsOpacity;
  bool beginCountdown;
  bool isLoading;
  int timerCount;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<ContentItems> feedList = [];

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

  List<String> tagTitles = [];

  @override
  void initState() {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    streamStarted = false;
    beginCountdown = false;
    isLoading = false;
    timerCount = 5;
    _itemsOpacity = 1.0;
    super.initState();
  }

  @override
  void dispose() {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      opacity: 0.5,
      color: Colors.black,
      progressIndicator: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 50,
              child: Text('Starting in',
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                  )),
            ),
            Container(
              height: 80,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: SpinKitDualRing(
                      color: Colors.white,
                      lineWidth: 5,
                      size: 80,
                    ),
                  ),
                  Center(
                    child: Text('$timerCount',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: streamStarted
            ? () {
                setState(() {
                  _itemsOpacity = _itemsOpacity == 0.0 ? 1.0 : 0.0;
                });
              }
            : null,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: <Widget>[
              Container(
                height: DeviceSize().getHeight(context),
                color: Colors.blueGrey,
              ),
              !streamStarted
                  ? Container(
                      height: DeviceSize().getHeight(context),
                      child: Column(
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
                                  padding:
                                      EdgeInsets.only(right: 12.0, left: 12.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 15, 10, 20),
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
                                              onPressed: (tag) {
                                                if (tag.active) {
                                                  tagTitles.add(tag.title);
                                                } else {
                                                  tagTitles.remove(tag.title);
                                                }
                                              },
                                              textStyle: GoogleFonts.openSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              pressEnabled: true,
                                              activeColor: hebenActive,
                                              border: Border.all(
                                                  color: Colors.transparent),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ArgonButton(
                                        height: 50,
                                        roundLoadingShape: false,
                                        splashColor: Colors.transparent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.88,
                                        minWidth:
                                            MediaQuery.of(context).size.width *
                                                0.20,
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
                                          ),
                                        ),
                                        onTap: (startLoading, stopLoading,
                                            btnState) async {
                                          if (btnState == ButtonState.Idle) {
                                            startLoading();
                                            await Future.delayed(
                                                Duration(seconds: 3));
                                            startStream();
                                          }
                                        },
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: DeviceSize().getHeight(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GFAppBar(
                            elevation: 0,
                            leading: IconButton(
                                icon: Icon(
                                  EvaIcons.close,
                                  size: 34,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            brightness: Brightness.light,
                            backgroundColor: Colors.transparent,
                          ),
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 250),
                            opacity: _itemsOpacity,
                            child: Container(
                              width: DeviceSize().getWidth(context),
                              child: Container(
                                color: Colors.black12,
                                height: DeviceSize().getHeight(context) / 3,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    key: _listKey,
                                    itemCount: feedList.length,
                                    reverse: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return buildContent(
                                          context, feedList[index]);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  startStream() async {
    setState(() {
      isLoading = true;
    });
    for (int x = 5; x > 0; x--) {
      await Future.delayed(Duration(seconds: 1)).then((_) {
        setState(() {
          timerCount -= 1;
        });
      });
    }
    setState(() {
      isLoading = false;
      streamStarted = true;
      loadTestData();
    });
  }

  loadTestData() async {
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() {
      List<ContentItems> list = [
        ContentStreamCommentItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?portrait',
            postUid: Faker().lorem.word(),
            creatorUid: Faker().lorem.word(),
            body: 'So hypeddd!!!'),
        ContentStreamCommentItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?dad',
            postUid: Faker().lorem.word(),
            creatorUid: Faker().lorem.word(),
            body: 'Glad you\'re streaming again!'),
        ContentStreamCommentItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?mom',
            postUid: Faker().lorem.word(),
            creatorUid: Faker().lorem.word(),
            body: 'Really love what you\'re doing! Keep it up'),
        ContentStreamCommentItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?workout',
            postUid: Faker().lorem.word(),
            creatorUid: Faker().lorem.word(),
            body: 'Let\'s go another set!'),
        ContentStreamCommentItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?male',
            postUid: Faker().lorem.word(),
            creatorUid: Faker().lorem.word(),
            body: 'Loving this new workout!'),
        ContentStreamCommentItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?female',
            postUid: Faker().lorem.word(),
            creatorUid: Faker().lorem.word(),
            body: 'Let\'s get it!'),
      ];

      setState(() {
        feedList.insertAll(0, list);
      });
    });
  }
}
