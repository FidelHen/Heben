import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/components/user_heading.dart';
import 'package:heben/components/user_lists/all_data_list.dart';
import 'package:heben/components/user_lists/bookmarked_data_list.dart';
import 'package:heben/components/user_lists/liked_data_list.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

RefreshController profileRefreshController = RefreshController();
int profileScrollListener = 0;

class Profile extends StatefulWidget {
  void scrollToTop() {
    if (profileScrollListener == 1) {
      if (profileRefreshController != null) {
        profileRefreshController.position.animateTo(
          -1.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    }
  }

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
    with AutomaticKeepAliveClientMixin<Profile> {
  bool loading;
  bool keepAlive = true;
  bool loadingList = true;

  Icon tabOneIcon = Icon(
    EvaIcons.list,
    color: Colors.black,
  );
  Icon tabTwoIcon = Icon(
    EvaIcons.heart,
    color: Colors.grey[400],
  );
  Icon tabThreeIcon = Icon(
    EvaIcons.bookmark,
    color: Colors.grey[400],
  );

  int listIndex;

  bool get wantKeepAlive => keepAlive;

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
    super.build(context);
    profileScrollListener = 1;
    return FutureBuilder(
        future: User().getUserProfileInfo(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: Container(
                  height: 50,
                  child: SpinKitThreeBounce(
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ),
            );
          } else {
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
                            snapshot.data['username'],
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
                      controller: profileRefreshController,
                      enablePullDown: true,
                      enablePullUp: true,
                      header: refreshHeader(),
                      footer: refreshFooter(),
                      onLoading: () {
                        profileRefreshController.loadComplete();
                      },
                      onRefresh: () {
                        profileRefreshController.refreshCompleted();
                      },
                      child: ListView(children: [
                        UserHeading(
                            name: snapshot.data['name'],
                            bio: snapshot.data['bio'],
                            profileImage: snapshot.data['profileImage'],
                            backgroundImage: snapshot.data['backgroundImage'],
                            followers: snapshot.data['followers'],
                            following: snapshot.data['following'],
                            isLive: snapshot.data['isLive'] ?? false,
                            role: UserRole.user),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: DefaultTabController(
                              initialIndex: 0,
                              length: 3,
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
                                                    tabThreeIcon = Icon(
                                                      EvaIcons.bookmark,
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
                                                    tabThreeIcon = Icon(
                                                      EvaIcons.bookmark,
                                                      color: Colors.grey[400],
                                                    );
                                                  } else {
                                                    listIndex = 2;
                                                    tabOneIcon = Icon(
                                                      EvaIcons.list,
                                                      color: Colors.grey[400],
                                                    );
                                                    tabTwoIcon = Icon(
                                                      EvaIcons.heart,
                                                      color: Colors.grey[400],
                                                    );
                                                    tabThreeIcon = Icon(
                                                      EvaIcons.bookmark,
                                                      color: hebenBookmarkColor,
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                            tabs: [
                                              Tab(icon: tabOneIcon),
                                              Tab(icon: tabTwoIcon),
                                              Tab(icon: tabThreeIcon),
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
                    )),
              ),
            );
          }
        });
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
      return AllDataList();
    } else if (listIndex == 1) {
      return LikedDataList();
    } else if (listIndex == 2) {
      return BookmarkedDataList();
    } else {
      return Container();
    }
  }
}
