import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/components/user_heading.dart';
import 'package:heben/components/user_lists/all_data_list.dart';
import 'package:heben/components/user_lists/liked_data_list.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/enums.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Friend extends StatefulWidget {
  Friend({@required this.uid, @required this.username});
  final String uid;
  final String username;
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

  Future getPostFuture;

  String userUid;

  @override
  void initState() {
    loading = false;
    listIndex = 0;
    if (widget.uid != null) {
      getPostFuture =
          Firestore.instance.collection('users').document(widget.uid).get();
      userUid = widget.uid;
    } else {
      getPostFuture = Firestore.instance
          .collection('users')
          .where('username', isEqualTo: widget.username)
          .getDocuments();
    }

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
    return FutureBuilder(
        future: getPostFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
              backgroundColor: Colors.grey[100],
              appBar: GFAppBar(
                centerTitle: true,
                elevation: 0,
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
            DocumentSnapshot data;

            if (widget.uid == null) {
              final snap = snapshot.data as QuerySnapshot;
              data = snap.documents.first;
              userUid = data['uid'];
            } else {
              data = snapshot.data as DocumentSnapshot;
            }

            if (data != null) {
              return Scaffold(
                backgroundColor: Colors.grey[100],
                appBar: GFAppBar(
                  title: Text(
                    data['username'] ?? '',
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
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
                      name: data['name'] ?? '',
                      bio: data['bio'] ?? '',
                      profileImage: data['profileImage'] ?? '',
                      backgroundImage: data['backgroundImage'] ?? '',
                      followers: data['followers'] ?? 0,
                      following: data['following'] ?? 0,
                      role: UserRole.friend,
                      isLive: data['isLive'] ?? false,
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
                      child: currentList(data['uid']),
                    ),
                  ]),
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: Colors.grey[100],
                appBar: GFAppBar(
                  centerTitle: true,
                  elevation: 0,
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
                body: Container(
                  width: DeviceSize().getWidth(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        EvaIcons.alertCircleOutline,
                        size: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Sorry, this user does not exists',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          }
        });
  }

  Widget currentList(String uid) {
    if (listIndex == 0) {
      return AllDataList(
        uid: userUid,
        isFriend: true,
      );
    } else if (listIndex == 1) {
      return LikedDataList(
        uid: userUid,
        isFriend: true,
      );
    } else {
      return Container();
    }
  }
}
