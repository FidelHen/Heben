import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/build/build_content.dart';
import 'package:heben/build/build_firestore_post.dart';
import 'package:heben/components/empty_list_button.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/models/content_items.dart';
import 'package:heben/models/profile_item.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

RefreshController homeRefreshController = RefreshController();
int homeScrollListener = 0;

class Home extends StatefulWidget {
  void scrollToTop() {
    if (homeScrollListener == 1) {
      if (homeRefreshController != null) {
        homeRefreshController.position.animateTo(
          -1.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    }
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<ContentItems> feedList = [];
  List<ProfileItem> usersToFollow = [];
  String uid;
  bool isLoading;
  bool noContent;
  bool keepAlive = true;
  DocumentSnapshot lastDocument;
  bool get wantKeepAlive => keepAlive;

  @override
  void initState() {
    loadTestData();
    isLoading = true;
    noContent = true;
    // loadData();
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
    super.build(context);
    homeScrollListener = 1;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  floating: true,
                  snap: true,
                  automaticallyImplyLeading: false,
                  title: Text(
                    'Home',
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.grey[100],
                ),
              ];
            },
            body: SmartRefresher(
                controller: homeRefreshController,
                enablePullDown: !isLoading,
                enablePullUp: !isLoading,
                header: refreshHeader(),
                footer: refreshFooter(),
                onLoading: () {
                  loadMoreData();
                },
                onRefresh: () {
                  loadData();
                },
                child: buildList())),
      ),
    );
  }

  loadData() async {
    uid = await User().getUid();
    Firestore.instance
        .collection('timeline')
        .document(uid)
        .collection('timelinePosts')
        .orderBy('addedOn', descending: false)
        .limit(15)
        .getDocuments()
        .then((snapshot) {
      feedList.clear();
      if (snapshot.documents.length == 1 || snapshot.documents.length == 0) {
        lastDocument = null;
      } else {
        lastDocument = snapshot.documents.last;
      }

      snapshot.documents.forEach((doc) async {
        await Firestore.instance
            .collection('posts')
            .document(doc.documentID)
            .get()
            .then((doc) {
          feedList.add(buildFirestorePost(snapshot: doc, uid: uid));
          setState(() {});
        }).then((_) {
          setState(() {
            noContent = false;
            isLoading = false;
          });
        });
      });
    });

    homeRefreshController.refreshCompleted();
  }

  loadMoreData() async {
    if (lastDocument != null) {
      await Firestore.instance
          .collection('timeline')
          .document(uid)
          .collection('timelinePosts')
          .orderBy('addedOn', descending: false)
          .limit(10)
          .startAfterDocument(lastDocument)
          .getDocuments()
          .then((snapshot) {
        if (snapshot.documents.length == 1 || snapshot.documents.length == 0) {
          lastDocument = null;
        } else {
          lastDocument = snapshot.documents.last;
        }

        snapshot.documents.forEach((doc) async {
          print(doc);
          await Firestore.instance
              .collection('posts')
              .document(doc.documentID)
              .get()
              .then((docSnapshot) {
            feedList.add(buildFirestorePost(snapshot: docSnapshot, uid: uid));
            setState(() {});
          }).then((_) {
            setState(() {});
          });
        });
      });

      homeRefreshController.loadComplete();
    } else {
      homeRefreshController.loadNoData();
    }
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
                child: SpinKitThreeBounce(
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      if (feedList.isEmpty) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: EmptyListButton(
                    title: 'Follow users to populate feed', onTap: () {}),
              ),
            ],
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
            liked: false,
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
          liked: false,
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
          liked: false,
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
          liked: false,
          comments: 5,
          postUid: Faker().randomGenerator.string(10),
          bookmarked: false,
        ),
      ];
      setState(() {
        feedList.insertAll(0, list);
        isLoading = false;
      });
    });
  }
}
