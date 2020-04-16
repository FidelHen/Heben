import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/build/build_content.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/models/content_items.dart';
import 'package:heben/utils/enums.dart';
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
  List<ContentItems> currentFeedList = [];

  bool keepAlive = true;
  bool get wantKeepAlive => keepAlive;

  @override
  void initState() {
    loadTestData();
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
              enablePullDown: true,
              enablePullUp: true,
              header: refreshHeader(),
              footer: refreshFooter(),
              onLoading: () {
                homeRefreshController.loadComplete();
              },
              onRefresh: () {
                loadTestData();
                homeRefreshController.refreshCompleted();
              },
              child: AnimatedList(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                key: _listKey,
                initialItemCount: currentFeedList.length,
                itemBuilder:
                    (BuildContext context, int index, Animation animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: buildContent(context, currentFeedList[index], index),
                  );
                },
              ),
            )),
      ),
    );
  }

  loadTestData() async {
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() {
      List<ContentItems> list = [
        ContentHomeHeaderItem(streamerList: []),
        ContentChallengeItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?mom',
            timestamp: '2 days',
            challengeTitle: '25 Push Up Challenge',
            popularity: CurrentPostPopularity.pinned,
            likes: 5,
            liked: false,
            bookmarked: true,
            participants: 8,
            postUid: Faker().randomGenerator.string(10),
            image: 'https://source.unsplash.com/1600x900/?workout',
            video: null,
            creatorUid: '',
            comments: 3,
            duration: '1'),
        ContentChallengeItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?dad',
            timestamp: '2 days',
            challengeTitle: '25 Push Up Challenge',
            popularity: CurrentPostPopularity.pinned,
            likes: 5,
            liked: false,
            bookmarked: true,
            participants: 8,
            postUid: Faker().randomGenerator.string(10),
            image: null,
            video:
                'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
            creatorUid: '',
            comments: 3,
            duration: '1'),
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

      currentFeedList.insertAll(0, list);

      for (int offset = 0; offset < list.length; offset++) {
        _listKey.currentState.insertItem(0 + offset);
      }
    });
  }
}
