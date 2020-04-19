import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/components/user_heading.dart';
import 'package:heben/components/user_lists/all_data_list.dart';
import 'package:heben/components/user_lists/liked_data_list.dart';
import 'package:heben/utils/enums.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Friend extends StatefulWidget {
  @override
  _FriendState createState() => _FriendState();
}

class _FriendState extends State<Friend> {
  RefreshController friendRefreshController = RefreshController();
  bool loading;
  bool loadingList = true;

  Icon tabOneIcon = Icon(
    EvaIcons.list,
    color: Colors.black,
  );
  Icon tabTwoIcon = Icon(
    EvaIcons.heart,
    color: Colors.grey[400],
  );

  int listIndex;

  @override
  void initState() {
    loading = false;
    listIndex = 0;
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: GFAppBar(
        title: Text(
          'Username',
          style: GoogleFonts.lato(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
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
        elevation: 0,
        backgroundColor: Colors.grey[100],
      ),
      body: SmartRefresher(
        controller: friendRefreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: refreshHeader(),
        footer: refreshFooter(),
        onLoading: () {
          friendRefreshController.loadComplete();
        },
        onRefresh: () {
          friendRefreshController.refreshCompleted();
        },
        child: ListView(children: [
          UserHeading(
            name: Faker().person.name(),
            bio: Faker().lorem.sentence(),
            profileImage: 'https://source.unsplash.com/1600x900/?portrait',
            backgroundImage: 'https://source.unsplash.com/1600x900/?pattern',
            followers: 0,
            following: 0,
            role: UserRole.friend,
            isLive: false,
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.grey[200],
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          child: Container(
                            color: Colors.white,
                            child: TabBar(
                              indicatorColor: Colors.transparent,
                              onTap: (index) {
                                setState(
                                  () {
                                    if (index == 0) {
                                      listIndex = 0;
                                      tabOneIcon = Icon(
                                        EvaIcons.list,
                                        color: Colors.black,
                                      );
                                      tabTwoIcon = Icon(
                                        EvaIcons.heart,
                                        color: Colors.grey[400],
                                      );
                                    } else if (index == 1) {
                                      listIndex = 1;
                                      tabOneIcon = Icon(
                                        EvaIcons.list,
                                        color: Colors.grey[400],
                                      );
                                      tabTwoIcon = Icon(
                                        EvaIcons.heart,
                                        color: Colors.redAccent,
                                      );
                                    }
                                  },
                                );
                              },
                              tabs: [
                                Tab(icon: tabOneIcon),
                                Tab(icon: tabTwoIcon),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: currentList(),
          ),
        ]),
      ),
    );
  }

  Widget currentList() {
    if (loading) {
      return Container(
        height: 80,
        child: SpinKitThreeBounce(
          color: Colors.grey,
          size: 25,
        ),
      );
    } else if (listIndex == 0) {
      return AllDataList(
        uid: '',
      );
    } else if (listIndex == 1) {
      return LikedDataList();
    } else {
      return Container();
    }
  }
}
