import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:heben/build/build_content.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/models/content_items.dart';
import 'package:heben/utils/enums.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StreamsTab extends StatefulWidget {
  @override
  _StreamsTabState createState() => _StreamsTabState();
}

class _StreamsTabState extends State<StreamsTab> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  RefreshController streamsRefreshController = RefreshController();
  List<ContentItems> feedList = [];

  @override
  void initState() {
    loadTestData();
    super.initState();
  }

  @override
  void dispose() {
    streamsRefreshController.dispose();
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
        streamsRefreshController.loadComplete();
      },
      controller: streamsRefreshController,
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
        ContentStreamItem(
          username: Faker().internet.userName(),
          profileImage: 'https://source.unsplash.com/1600x900/?man',
          popularity: CurrentPostPopularity.featured,
          image: 'https://source.unsplash.com/1600x900/?workout',
          watchers: Faker().randomGenerator.integer(10000),
          postUid: Faker().lorem.word(),
          creatorUid: Faker().lorem.word(),
        ),
        ContentStreamItem(
          username: Faker().internet.userName(),
          profileImage: 'https://source.unsplash.com/1600x900/?woman',
          popularity: CurrentPostPopularity.trending,
          image: 'https://source.unsplash.com/1600x900/?yoga',
          watchers: Faker().randomGenerator.integer(10000),
          postUid: Faker().lorem.word(),
          creatorUid: Faker().lorem.word(),
        ),
        ContentStreamItem(
          username: Faker().internet.userName(),
          profileImage: 'https://source.unsplash.com/1600x900/?dad',
          popularity: CurrentPostPopularity.normal,
          image: 'https://source.unsplash.com/1600x900/?pushup',
          watchers: Faker().randomGenerator.integer(10000),
          postUid: Faker().lorem.word(),
          creatorUid: Faker().lorem.word(),
        ),
        ContentStreamItem(
          username: Faker().internet.userName(),
          profileImage: 'https://source.unsplash.com/1600x900/?world',
          popularity: CurrentPostPopularity.trending,
          image: 'https://source.unsplash.com/1600x900/?squat',
          watchers: Faker().randomGenerator.integer(10000),
          postUid: Faker().lorem.word(),
          creatorUid: Faker().lorem.word(),
        ),
      ];

      feedList.insertAll(0, list);

      for (int offset = 0; offset < list.length; offset++) {
        _listKey.currentState.insertItem(0 + offset);
      }
    });
  }
}
