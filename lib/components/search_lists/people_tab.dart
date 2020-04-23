import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/content/content_profile_tile.dart';
import 'package:heben/models/profile_item.dart';
import 'package:heben/utils/device_size.dart';
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
        .index('users')
        .search(widget.query)
        .setHitsPerPage(15)
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
        if (uid != value.objectID) {
          feedList.insert(
              index,
              ProfileItem(
                  uid: value.objectID,
                  username: value.data['username'],
                  profileImage: value.data['profileImage']));

          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
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
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          width: DeviceSize().getWidth(context),
          child: Center(
            child: SpinKitCircle(
              color: Colors.grey,
              size: 40,
            ),
          ),
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
              'No users found',
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
            return ContentProfileTile(
              uid: feedList[index].uid,
              username: feedList[index].username,
              profileImage: feedList[index].profileImage,
              stopGesture: false,
            );
          },
        ),
      );
    }
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
