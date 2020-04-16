import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:heben/build/build_content.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/models/content_items.dart';
import 'package:heben/utils/enums.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChallengesTab extends StatefulWidget {
  @override
  _ChallengesTabState createState() => _ChallengesTabState();
}

class _ChallengesTabState extends State<ChallengesTab> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  RefreshController challengesRefreshController = RefreshController();
  List<ContentItems> feedList = [];

  @override
  void initState() {
    loadTestData();
    super.initState();
  }

  @override
  void dispose() {
    challengesRefreshController.dispose();
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
    return SmartRefresher(
      physics: BouncingScrollPhysics(),
      enablePullDown: false,
      enablePullUp: true,
      footer: refreshFooter(),
      onLoading: () {
        challengesRefreshController.loadComplete();
      },
      controller: challengesRefreshController,
      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: AnimatedList(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          key: _listKey,
          initialItemCount: feedList.length,
          itemBuilder: (BuildContext context, int index, Animation animation) {
            return FadeTransition(
              opacity: animation,
              child: buildContent(context, feedList[index], index),
            );
          },
        ),
      ),
    );
  }

  loadTestData() async {
    await Future.delayed(const Duration(milliseconds: 250));

    setState(() {
      List<ContentItems> list = [
        ContentChallengeItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?mom',
            timestamp: '1 hr',
            challengeTitle: '25 Push Up Challenge',
            popularity: CurrentPostPopularity.pinned,
            likes: 50,
            liked: false,
            bookmarked: false,
            participants: 8,
            postUid: Faker().randomGenerator.string(10),
            image: 'https://source.unsplash.com/1600x900/?pushup',
            video: null,
            creatorUid: '',
            comments: 50,
            duration: '1'),
        ContentChallengeItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?dad',
            timestamp: '2 days',
            challengeTitle: 'Run Challenge',
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
        ContentChallengeItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?dad',
            timestamp: '2 days',
            challengeTitle: 'Yoga challenge',
            popularity: CurrentPostPopularity.pinned,
            likes: 3563,
            liked: false,
            bookmarked: true,
            participants: 8,
            postUid: Faker().randomGenerator.string(10),
            image: 'https://source.unsplash.com/1600x900/?yoga',
            video: null,
            creatorUid: '',
            comments: 3,
            duration: '1'),
        ContentChallengeItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?teen',
            timestamp: '2 mins',
            challengeTitle: '25 Pull Up Challenge',
            popularity: CurrentPostPopularity.pinned,
            likes: 5,
            liked: false,
            bookmarked: true,
            participants: 8,
            postUid: Faker().randomGenerator.string(10),
            image: 'https://source.unsplash.com/1600x900/?pullup',
            video: null,
            creatorUid: '',
            comments: 3,
            duration: '1'),
      ];

      feedList.insertAll(0, list);

      for (int offset = 0; offset < list.length; offset++) {
        _listKey.currentState.insertItem(0 + offset);
      }
    });
  }
}
