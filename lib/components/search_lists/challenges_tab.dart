import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/build/build_content.dart';
import 'package:heben/build/build_firestore_post.dart';
import 'package:heben/models/content_items.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/keys.dart';
import 'package:heben/utils/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChallengesTab extends StatefulWidget {
  ChallengesTab({@required this.query});
  final String query;
  @override
  _ChallengesTabState createState() => _ChallengesTabState();
}

class _ChallengesTabState extends State<ChallengesTab> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  RefreshController profileRefreshController = RefreshController();
  List<ContentItems> feedList = [];
  bool isLoading;
  Algolia algolia;

  Future algoliaFuture;

  @override
  void didChangeDependencies() {
    isLoading = true;
    algolia = Algolia.init(
      applicationId: AlgoliaKeys().getAppId(),
      apiKey: AlgoliaKeys().getApiKey(),
    );

    algoliaFuture = algoliaFuture = algolia.instance
        .index('challenges')
        .search(widget.query)
        .setHitsPerPage(10)
        .getObjects();

    loadData();
    buildList();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    profileRefreshController.dispose();
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
    return buildList();
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });

    String uid = await User().getUid();
    algoliaFuture.then((snapshot) {
      feedList.clear();
      final data = snapshot as AlgoliaQuerySnapshot;

      data.hits.asMap().forEach((index, value) {
        Firestore.instance
            .collection('posts')
            .document(value.objectID)
            .get()
            .then((result) {
          feedList.insert(
              index, buildFirestorePost(snapshot: result, uid: uid));
        }).then((_) {
          setState(() {
            isLoading = false;
          });
        });
      });

      if (data.hits.length == 0) {
        feedList.clear();
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Widget buildList() {
    if (isLoading) {
      return Container(
        width: DeviceSize().getWidth(context),
        child: Column(
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
            ),
          ],
        ),
      );
    } else if (feedList.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          width: DeviceSize().getWidth(context),
          child: Center(
            child: Text(
              'No challenges found',
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          key: _listKey,
          itemCount: feedList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildContent(context, feedList[index]);
          },
        ),
      );
    }
  }

  loadTestData() async {
    await Future.delayed(const Duration(milliseconds: 250));

    setState(() {
      List<ContentItems> list = [
        // ContentChallengeItem(
        //     username: Faker().internet.userName(),
        //     profileImage: 'https://source.unsplash.com/1600x900/?mom',
        //     timestamp: '1 hr',
        //     challengeTitle: '25 Push Up Challenge',
        //     popularity: CurrentPostPopularity.pinned,
        //     likes: 50,
        //     liked: false,
        //     bookmarked: false,
        //     participants: 8,
        //     postUid: Faker().randomGenerator.string(10),
        //     image: 'https://source.unsplash.com/1600x900/?pushup',
        //     video: null,
        //     creatorUid: '',
        //     comments: 50,
        //     duration: '1'),
        // ContentChallengeItem(
        //     username: Faker().internet.userName(),
        //     profileImage: 'https://source.unsplash.com/1600x900/?dad',
        //     timestamp: '2 days',
        //     challengeTitle: 'Run Challenge',
        //     popularity: CurrentPostPopularity.pinned,
        //     likes: 5,
        //     liked: false,
        //     bookmarked: true,
        //     participants: 8,
        //     postUid: Faker().randomGenerator.string(10),
        //     image: null,
        //     video:
        //         'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        //     creatorUid: '',
        //     comments: 3,
        //     duration: '1'),
        // ContentChallengeItem(
        //     username: Faker().internet.userName(),
        //     profileImage: 'https://source.unsplash.com/1600x900/?dad',
        //     timestamp: '2 days',
        //     challengeTitle: 'Yoga challenge',
        //     popularity: CurrentPostPopularity.pinned,
        //     likes: 3563,
        //     liked: false,
        //     bookmarked: true,
        //     participants: 8,
        //     postUid: Faker().randomGenerator.string(10),
        //     image: 'https://source.unsplash.com/1600x900/?yoga',
        //     video: null,
        //     creatorUid: '',
        //     comments: 3,
        //     duration: '1'),
        // ContentChallengeItem(
        //     username: Faker().internet.userName(),
        //     profileImage: 'https://source.unsplash.com/1600x900/?teen',
        //     timestamp: '2 mins',
        //     challengeTitle: '25 Pull Up Challenge',
        //     popularity: CurrentPostPopularity.pinned,
        //     likes: 5,
        //     liked: false,
        //     bookmarked: true,
        //     participants: 8,
        //     postUid: Faker().randomGenerator.string(10),
        //     image: 'https://source.unsplash.com/1600x900/?pullup',
        //     video: null,
        //     creatorUid: '',
        //     comments: 3,
        //     duration: '1'),
      ];

      feedList.insertAll(0, list);

      for (int offset = 0; offset < list.length; offset++) {
        _listKey.currentState.insertItem(0 + offset);
      }
    });
  }
}
