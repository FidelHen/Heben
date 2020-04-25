import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/build/build_post.dart';
import 'package:heben/components/modals.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/models/post_items.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Post extends StatefulWidget {
  Post(
      {@required this.username,
      @required this.profileImage,
      @required this.timestamp,
      @required this.body,
      @required this.video,
      @required this.popularity,
      @required this.likes,
      @required this.liked,
      @required this.bookmarked,
      @required this.comments,
      @required this.postUid,
      @required this.challengeUid,
      @required this.challengeTitle,
      @required this.image});

  final String username;
  final String profileImage;
  final String timestamp;
  final String body;
  final String video;
  final CurrentPostPopularity popularity;
  final int likes;
  final bool liked;
  final int comments;
  final String image;
  final String postUid;
  final bool bookmarked;
  final String challengeTitle;
  final String challengeUid;

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  RefreshController postRefreshController = RefreshController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<PostItems> currentPostList = [];

  @override
  void initState() {
    configureUi();
    super.initState();
  }

  @override
  void dispose() {
    if (postRefreshController != null) {
      postRefreshController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  floating: true,
                  snap: true,
                  pinned: true,
                  leading: IconButton(
                      icon: Icon(
                        EvaIcons.chevronLeft,
                        size: 40,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  actions: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: IconButton(
                          icon: Icon(
                            EvaIcons.moreHorizotnal,
                            size: 30,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            User().getUsername().then((userUsername) {
                              Modal().postOptions(
                                  context,
                                  userUsername == widget.username,
                                  widget.postUid);
                            });
                          }),
                    ),
                  ],
                  elevation: 0,
                  backgroundColor: Colors.grey[100],
                ),
              ];
            },
            body: Column(
              children: <Widget>[
                Expanded(
                  child: SmartRefresher(
                    controller: postRefreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    header: refreshHeader(),
                    footer: refreshFooter(),
                    onLoading: () {
                      // loadTestData();
                      postRefreshController.loadComplete();
                    },
                    onRefresh: () {
                      // loadTestData();
                      postRefreshController.refreshCompleted();
                    },
                    child: AnimatedList(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      key: _listKey,
                      initialItemCount: currentPostList.length,
                      itemBuilder: (BuildContext context, int index,
                          Animation animation) {
                        return FadeTransition(
                          opacity: animation,
                          child:
                              buildPost(context, currentPostList[index], index),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: SafeArea(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: DeviceSize().getWidth(context),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey[200],
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsets.only(right: 10.0, left: 10.0),
                                child: TextField(
                                  autofocus: false,
                                  keyboardAppearance: Brightness.light,
                                  style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    hintText: 'Add a comment...',
                                    hintStyle: GoogleFonts.openSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                EvaIcons.paperPlaneOutline,
                                color: hebenActive,
                              ),
                              onPressed: () {})
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  configureUi() async {
    await Future.delayed(const Duration(milliseconds: 250));

    setState(() {
      List<PostItems> list = [
        PostHeaderItem(
          username: widget.username,
          profileImage: widget.profileImage,
          timestamp: widget.timestamp,
          body: widget.body,
          popularity: widget.popularity,
          postUid: widget.postUid,
          challengeUid: widget.challengeUid,
          challengeTitle: widget.challengeTitle,
          image: widget.image,
          video: widget.video,
          bookmarked: widget.bookmarked,
          comments: widget.comments,
          liked: widget.liked,
          likes: widget.likes,
        ),
        PostCommentItem(),
        PostCommentItem(),
        PostCommentItem(),
        PostCommentItem(),
        PostCommentItem(),
      ];
      currentPostList.insertAll(0, list);

      for (int offset = 0; offset < list.length; offset++) {
        _listKey.currentState.insertItem(0 + offset);
      }
    });
  }
}
