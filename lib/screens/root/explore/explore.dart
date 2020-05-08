import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/build/build_content.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/models/content_items.dart';
import 'package:heben/screens/root/explore/search.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/navigation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

RefreshController exploreRefreshController = RefreshController();
int exploreScrollListener = 0;

class Explore extends StatefulWidget {
  void scrollToTop() {
    if (exploreScrollListener == 1) {
      exploreRefreshController.position.animateTo(
        -1.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore>
    with AutomaticKeepAliveClientMixin<Explore> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<ContentItems> currentExploreList = [];

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
    exploreScrollListener = 1;
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
                    'Explore',
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(EvaIcons.search),
                      onPressed: () {
                        Navigation().segue(
                            page: Search(),
                            context: context,
                            fullScreen: false);
                      },
                      color: Colors.black,
                    )
                  ],
                  elevation: 0,
                  backgroundColor: Colors.grey[100],
                ),
              ];
            },
            body: SmartRefresher(
              controller: exploreRefreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: refreshHeader(),
              footer: refreshFooter(),
              onLoading: () {
                exploreRefreshController.loadComplete();
              },
              onRefresh: () {
                exploreRefreshController.refreshCompleted();
              },
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                key: _listKey,
                itemCount: currentExploreList.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildContent(
                      context, currentExploreList[index], index);
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
        ContentVideoItem(
          username: Faker().internet.userName(),
          profileImage: 'https://source.unsplash.com/1600x900/?man',
          timestamp: '8 hr',
          body: 'Social distancing & kettlebells, Let\'s GO!',
          video:
              'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
          popularity: CurrentPostPopularity.trending,
          likes: 376,
          liked: true,
          postUid: Faker().randomGenerator.string(10),
          bookmarked: false,
          comments: 90,
          challengeTitle: '50 Swing Kettlebell Challenge',
          challengeUid: Faker().randomGenerator.string(10),
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
          challengeTitle: null,
          challengeUid: null,
        ),
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
        currentExploreList.insertAll(0, list);
      });
    });
  }
}
