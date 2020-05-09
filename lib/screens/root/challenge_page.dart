import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/build/build_content.dart';
import 'package:heben/build/build_firestore_post.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/models/content_items.dart';
import 'package:heben/screens/root/create_content/accept_challenge.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/navigation.dart';
import 'package:heben/utils/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChallengePage extends StatefulWidget {
  ChallengePage(
      {@required this.challengeUid,
      @required this.duration,
      @required this.timestamp,
      @required this.challengeTitle});
  final String challengeUid;
  final String duration;
  final int timestamp;
  final String challengeTitle;

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  RefreshController challengeRefreshController;
  List<ContentItems> feedList = [];
  Future getPostFuture;
  bool buttonIsHidden;
  String uid;

  @override
  void initState() {
    // loadTestData();
    challengeRefreshController = RefreshController();
    getPostFuture = Firestore.instance
        .collection('posts')
        .document(widget.challengeUid)
        .collection('participants')
        .orderBy('timestamp', descending: true)
        .getDocuments();

    buttonIsHidden = false;

    loadUid();
    super.initState();
  }

  @override
  void dispose() {
    challengeRefreshController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPostFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
              backgroundColor: Colors.grey[100],
              appBar: GFAppBar(
                centerTitle: true,
                elevation: 0,
                title: Text(
                  'Challenge',
                  style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                leading: IconButton(
                    icon: Icon(
                      EvaIcons.chevronLeft,
                      size: 40,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                brightness: Brightness.light,
                backgroundColor: Colors.grey[100],
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 50,
                      child: SpinKitRing(
                        color: Colors.black,
                        lineWidth: 5,
                        size: 40,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            final data = snapshot.data as QuerySnapshot;
            if (data.documents.length != 0) {
              data.documents.forEach((snapshot) {
                ContentItems item =
                    buildFirestorePost(snapshot: snapshot, uid: uid);
                feedList.add(item);
              });
              return Scaffold(
                backgroundColor: Colors.grey[100],
                appBar: GFAppBar(
                  centerTitle: true,
                  elevation: 0,
                  title: Text(
                    '${getTimeLeft()}',
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  leading: IconButton(
                      icon: Icon(
                        EvaIcons.chevronLeft,
                        size: 40,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  brightness: Brightness.light,
                  backgroundColor: Colors.grey[100],
                ),
                body: SmartRefresher(
                  physics: BouncingScrollPhysics(),
                  enablePullDown: true,
                  enablePullUp: true,
                  header: refreshHeader(),
                  footer: refreshFooter(),
                  onRefresh: () {
                    challengeRefreshController.refreshCompleted();
                  },
                  onLoading: () {
                    challengeRefreshController.loadComplete();
                  },
                  controller: challengeRefreshController,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      key: _listKey,
                      itemCount: feedList.length,
                      itemBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        return buildContent(context, feedList[index], index);
                      },
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FloatingActionButton.extended(
                    backgroundColor: hebenSuccess,
                    onPressed: () {
                      Navigation().segue(
                          page: AcceptChallenge(
                            challengeTitle: widget.challengeTitle,
                            challengeUid: widget.challengeUid,
                          ),
                          context: context,
                          fullScreen: true);
                    },
                    label: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Text(
                            'Challenge',
                            style: GoogleFonts.lato(
                                fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Icon(
                          EvaIcons.flash,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: Colors.grey[100],
                appBar: GFAppBar(
                  centerTitle: true,
                  elevation: 0,
                  leading: IconButton(
                      icon: Icon(
                        EvaIcons.chevronLeft,
                        size: 40,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  brightness: Brightness.light,
                  backgroundColor: Colors.grey[100],
                ),
                body: Container(
                  width: DeviceSize().getWidth(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        EvaIcons.alertCircleOutline,
                        size: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Sorry, challenge doesn\'t exist',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          }
        });
  }

  loadUid() async {
    uid = await User().getUid();
  }

  loadTestData() async {
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() {
      List<ContentItems> list = [
        ContentVideoItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?couple',
            timestamp: '1 hr',
            body: Faker().lorem.sentence() + ' @Hello @world',
            video:
                'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
            popularity: CurrentPostPopularity.normal,
            likes: 2,
            liked: true,
            postUid: Faker().randomGenerator.string(10),
            bookmarked: false,
            comments: 3,
            challengeUid: Faker().randomGenerator.string(10),
            challengeTitle: '25 Push Up Challenge'),
        ContentImageItem(
            username: Faker().internet.userName(),
            profileImage: 'https://i.pravatar.cc/300',
            timestamp: '1 hr',
            body: Faker().lorem.sentence() + ' @Hello @world',
            image: 'https://source.unsplash.com/1600x900/?healthy',
            popularity: CurrentPostPopularity.normal,
            likes: 1,
            liked: false,
            comments: 10,
            postUid: Faker().randomGenerator.string(10),
            bookmarked: true,
            challengeUid: Faker().randomGenerator.string(10),
            challengeTitle: '25 Push Up Challenge'),
      ];
      setState(() {
        feedList.insertAll(0, list);
      });
    });
  }

  String getTimeLeft() {
    DurationChallenge duration = EnumToString.fromString(
        DurationChallenge.values, widget.duration.toString().split('.')[1]);
    DateTime difference;
    if (duration == DurationChallenge.oneDay) {
      difference = DateTime.fromMillisecondsSinceEpoch(widget.timestamp)
          .add(Duration(days: 1));
    } else if (duration == DurationChallenge.oneWeek) {
      difference = DateTime.fromMillisecondsSinceEpoch(widget.timestamp)
          .add(Duration(days: 7));
    } else if (duration == DurationChallenge.oneMonth) {
      difference = DateTime.fromMillisecondsSinceEpoch(widget.timestamp)
          .add(Duration(days: 31));
    }

    final timeLeft = difference.difference(DateTime.now());
    if (timeLeft.inDays > 0) {
      return '${timeLeft.inDays} days left';
    } else if (timeLeft.inHours > 0) {
      return '${timeLeft.inHours} hours left';
    } else if (timeLeft.inMinutes > 0) {
      return '${timeLeft.inMinutes} minutes left';
    } else if (timeLeft.inSeconds > 0) {
      return '${timeLeft.inSeconds} seconds left';
    } else {
      return 'Challenge has closed';
    }
  }
}
