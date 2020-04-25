import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/content/content_profile_tile.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/models/profile_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Followers extends StatefulWidget {
  Followers({@required this.uid});
  final String uid;
  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  RefreshController followingRefreshController = RefreshController();
  List<ProfileItem> feedList = [];

  bool isLoading;

  @override
  void initState() {
    // loadTestData();
    loadData();
    isLoading = true;
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
    return buildList();
  }

  loadData() async {
    String uid = widget.uid ?? '';

    await Firestore.instance
        .collection('followers')
        .document(uid)
        .collection('users')
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) async {
        if (doc.data['uid'] != uid) {
          await Firestore.instance
              .collection('users')
              .document(doc.data['uid'])
              .get()
              .then((result) {
            setState(() {
              feedList.add(ProfileItem(
                  profileImage: result.data['profileImage'],
                  uid: result.data['uid'],
                  username: result.data['username']));
            });
          });
        }
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  Widget buildList() {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: GFAppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Followers',
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
        body: Column(
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
            )
          ],
        ),
      );
    } else {
      if (feedList.length != 0) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: GFAppBar(
            centerTitle: true,
            elevation: 0,
            title: Text(
              'Followers',
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
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
            header: refreshHeader(),
            onLoading: () {
              followingRefreshController.loadComplete();
            },
            onRefresh: () {
              followingRefreshController.refreshCompleted();
            },
            controller: followingRefreshController,
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                key: _listKey,
                itemCount: feedList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ContentProfileTile(
                      uid: feedList[index].uid,
                      username: feedList[index].username,
                      stopGesture: false,
                      profileImage: feedList[index].profileImage);
                },
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: GFAppBar(
            centerTitle: true,
            elevation: 0,
            title: Text(
              'Followers',
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Text(
                'No followers',
                style: GoogleFonts.openSans(fontWeight: FontWeight.w600),
              )),
            ],
          ),
        );
      }
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
