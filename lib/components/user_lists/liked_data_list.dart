import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/build/build_content.dart';
import 'package:heben/build/build_firestore_post.dart';
import 'package:heben/models/content_items.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/enums.dart';

class LikedDataList extends StatefulWidget {
  LikedDataList({@required this.uid, @required this.isFriend});
  final String uid;
  final bool isFriend;
  @override
  _LikedDataListState createState() => _LikedDataListState();
}

class _LikedDataListState extends State<LikedDataList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<ContentItems> feedList = [];
  Future getSnapshots;
  bool isLoading;

  @override
  void initState() {
    // loadTestData();
    isLoading = true;
    getSnapshots = Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('likes')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    loadData();
    buildList();
    super.initState();
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
    QuerySnapshot docSnap;
    await getSnapshots.then((snapshot) {
      docSnap = snapshot as QuerySnapshot;
    });

    docSnap.documents.forEach((doc) async {
      await Firestore.instance
          .collection('posts')
          .document(doc.documentID)
          .get()
          .then((doc) {
        feedList.add(buildFirestorePost(snapshot: doc, uid: widget.uid));
        setState(() {});
      }).then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });

    if (docSnap.documents.length == 0) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildList() {
    if (isLoading) {
      return Container(
        height: 50,
        child: SpinKitCircle(
          color: Colors.grey,
          size: 40,
        ),
      );
    } else if (feedList.isEmpty) {
      return !widget.isFriend
          ? Container(
              height: DeviceSize().getHeight(context) * 0.2,
              child: Center(
                child: Text('Your likes will show up here',
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            )
          : Container(
              height: DeviceSize().getHeight(context) * 0.2,
              child: Center(
                child: Text(
                  'User\'s likes will show up here',
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            );
    } else {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        key: _listKey,
        itemCount: feedList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildContent(context, feedList[index], index);
        },
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
        //     timestamp: '2 days',
        //     challengeTitle: '25 Push Up Challenge',
        //     popularity: CurrentPostPopularity.pinned,
        //     likes: 5,
        //     liked: true,
        //     bookmarked: true,
        //     participants: 8,
        //     postUid: Faker().randomGenerator.string(10),
        //     image: 'https://source.unsplash.com/1600x900/?workout',
        //     video: null,
        //     creatorUid: '',
        //     comments: 3,
        //     duration: '1'),
        // ContentChallengeItem(
        //     username: Faker().internet.userName(),
        //     profileImage: 'https://source.unsplash.com/1600x900/?dad',
        //     timestamp: '2 days',
        //     challengeTitle: '25 Push Up Challenge',
        //     popularity: CurrentPostPopularity.pinned,
        //     likes: 5,
        //     liked: true,
        //     bookmarked: true,
        //     participants: 8,
        //     postUid: Faker().randomGenerator.string(10),
        //     image: null,
        //     video:
        //         'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        //     creatorUid: '',
        //     comments: 3,
        //     duration: '1'),
        ContentVideoItem(
          username: Faker().internet.userName(),
          profileImage: 'https://source.unsplash.com/1600x900/?couple',
          timestamp: '1 hr',
          body: Faker().lorem.sentence() + ' @Hello @world',
          video:
              'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
          popularity: CurrentPostPopularity.pinned,
          likes: 2,
          liked: true,
          postUid: Faker().randomGenerator.string(10),
          bookmarked: false,
          comments: 3,
          challengeTitle: null,
          challengeUid: null,
        ),
        ContentImageItem(
            username: Faker().internet.userName(),
            profileImage: 'https://i.pravatar.cc/300',
            timestamp: '1 hr',
            body: Faker().lorem.sentence() + ' @Hello @world',
            image: 'https://source.unsplash.com/1600x900/?healthy',
            popularity: CurrentPostPopularity.trending,
            likes: 1,
            liked: true,
            comments: 10,
            postUid: Faker().randomGenerator.string(10),
            bookmarked: true,
            challengeUid: Faker().randomGenerator.string(10),
            challengeTitle: '25 Push Up Challenge'),
        ContentTextItem(
          username: Faker().internet.userName(),
          profileImage: 'https://source.unsplash.com/1600x900/?portrait',
          timestamp: '1 min',
          body: Faker().lorem.sentence() + ' @Hello @world',
          popularity: CurrentPostPopularity.trending,
          likes: 1,
          liked: true,
          comments: 5,
          postUid: Faker().randomGenerator.string(10),
          bookmarked: false,
        ),
        ContentTextItem(
          username: Faker().internet.userName(),
          profileImage: 'https://source.unsplash.com/1600x900/?woman',
          timestamp: '1 min',
          body: Faker().lorem.sentence() + ' @Hello @world',
          popularity: CurrentPostPopularity.trending,
          likes: 1,
          liked: true,
          comments: 5,
          postUid: Faker().randomGenerator.string(10),
          bookmarked: false,
        ),
        ContentTextItem(
          username: Faker().internet.userName(),
          profileImage: 'https://source.unsplash.com/1600x900/?man',
          timestamp: '1 min',
          body: Faker().lorem.sentence() + ' @Hello @world #hello #swole',
          popularity: CurrentPostPopularity.featured,
          likes: 1,
          liked: true,
          comments: 5,
          postUid: Faker().randomGenerator.string(10),
          bookmarked: false,
        ),
      ];

      feedList.insertAll(0, list);

      for (int offset = 0; offset < list.length; offset++) {
        _listKey.currentState.insertItem(0 + offset);
      }
    });
  }
}
