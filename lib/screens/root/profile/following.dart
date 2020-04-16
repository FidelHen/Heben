import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/content/content_profile_tile.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/models/profile_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Following extends StatefulWidget {
  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  RefreshController followingRefreshController = RefreshController();
  List<ProfileItem> feedList = [];

  @override
  void initState() {
    loadTestData();
    super.initState();
  }

  @override
  void dispose() {
    followingRefreshController.dispose();
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: GFAppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Following',
          style: GoogleFonts.lato(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
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
        enablePullDown: false,
        enablePullUp: true,
        footer: refreshFooter(),
        onLoading: () {
          followingRefreshController.loadComplete();
        },
        controller: followingRefreshController,
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
                    profileImage: feedList[index].profileImage),
              );
            },
          ),
        ),
      ),
    );
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
