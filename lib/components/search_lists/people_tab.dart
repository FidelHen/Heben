import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:heben/components/content/content_profile_tile.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/models/profile_item.dart';
import 'package:heben/utils/keys.dart';
import 'package:heben/utils/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:algolia/algolia.dart';

class PeopleTab extends StatefulWidget {
  PeopleTab({@required this.query});
  final String query;
  @override
  _PeopleTabState createState() => _PeopleTabState();
}

class _PeopleTabState extends State<PeopleTab> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  RefreshController profileRefreshController = RefreshController();
  List<ProfileItem> feedList = [];

  Algolia algolia;

  Future algoliaFuture;

  @override
  void initState() {
    // loadTestData();
    algolia = Algolia.init(
      applicationId: AlgoliaKeys().getAppId(),
      apiKey: AlgoliaKeys().getApiKey(),
    );

    algoliaFuture = algoliaFuture = algolia.instance
        .index('users')
        .search(widget.query)
        .setHitsPerPage(15)
        .getObjects();

    super.initState();
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
    return FutureBuilder(
        future: algoliaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
              height: 50,
              child: SpinKitCircle(
                color: Colors.grey,
                size: 40,
              ),
            );
          } else {
            AlgoliaQuerySnapshot data = snapshot.data;

            for (var i = 0; i <= feedList.length - 1; i++) {
              _listKey.currentState.removeItem(0,
                  (BuildContext context, Animation<double> animation) {
                return Container();
              });
            }
            feedList.clear();

            User().getUid().then((uid) {
              data.hits.asMap().forEach((index, value) {
                if (uid != value.objectID) {
                  print(value.data['username']);
                  feedList.add(
                    ProfileItem(
                        uid: value.objectID,
                        username: value.data['username'],
                        profileImage: value.data['profileImage']),
                  );

                  _listKey.currentState.insertItem(0);
                }
              });
            });

            return SmartRefresher(
              physics: BouncingScrollPhysics(),
              enablePullDown: false,
              enablePullUp: true,
              footer: refreshFooter(),
              onLoading: () {
                profileRefreshController.loadComplete();
              },
              controller: profileRefreshController,
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: AnimatedList(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  key: _listKey,
                  initialItemCount: feedList.length,
                  itemBuilder:
                      (BuildContext context, int index, Animation animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ContentProfileTile(
                        uid: feedList[index].uid,
                        username: feedList[index].username,
                        profileImage: feedList[index].profileImage,
                        stopGesture: false,
                      ),
                    );
                  },
                ),
              ),
            );
          }
        });
  }

  loadTestData() async {
    await Future.delayed(const Duration(milliseconds: 250));

    setState(() {
      List<ProfileItem> list = [
        ProfileItem(
            uid: Faker().lorem.word(),
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?dad'),
        ProfileItem(
            uid: Faker().lorem.word(),
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?mom'),
        ProfileItem(
            uid: Faker().lorem.word(),
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?woman'),
        ProfileItem(
            uid: Faker().lorem.word(),
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?man'),
        ProfileItem(
            uid: Faker().lorem.word(),
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?female'),
        ProfileItem(
            uid: Faker().lorem.word(),
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?male'),
      ];

      feedList.insertAll(0, list);

      for (int offset = 0; offset < list.length; offset++) {
        _listKey.currentState.insertItem(0 + offset);
      }
    });
  }
}
