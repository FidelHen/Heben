import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/build/build_post.dart';
import 'package:heben/components/modals.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/utils/social.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:heben/components/toast.dart';
import 'package:heben/models/post_items.dart';
import 'package:heben/utils/annotator/social_keyboard.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/user.dart';
import 'package:overlay_support/overlay_support.dart';
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
      @required this.isNotification,
      @required this.image});

  final String username;
  final String profileImage;
  final String timestamp;
  final String body;
  final String video;
  final CurrentPostPopularity popularity;
  final int likes;
  final bool liked;
  final bool isNotification;
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
  List<PostItems> currentPostList;
  TextEditingController commentController;
  FocusNode mainNode;
  DocumentSnapshot lastDocument;
  String username;
  bool isPinned;
  bool isLoading;
  bool postExists;

  @override
  void initState() {
    commentController = TextEditingController();
    mainNode = FocusNode();
    if (!widget.isNotification) {
      isLoading = false;
      username = widget.username;
      postExists = true;
    } else {
      isLoading = true;
      postExists = false;
    }

    loadData();
    loadComments();

    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    if (postRefreshController != null) {
      postRefreshController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                      isLoading
                          ? Container()
                          : !postExists
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                      icon: Icon(
                                        EvaIcons.moreHorizotnal,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        User()
                                            .getUsername()
                                            .then((userUsername) {
                                          Modal().postOptions(
                                              context,
                                              userUsername == widget.username,
                                              widget.postUid,
                                              isPinned);
                                        });
                                      }),
                                ),
                    ],
                    elevation: 0,
                    backgroundColor: Colors.grey[100],
                  ),
                ];
              },
              body: buildList()),
        ),
      ),
    );
  }

  loadData() async {
    if (!widget.isNotification) {
      currentPostList = [
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
      ];
    } else {
      String uid = await User().getUid();

      await Firestore.instance
          .collection('posts')
          .document(widget.postUid)
          .get()
          .then((doc) {
        if (doc.exists) {
          final data = doc.data;
          CurrentPostPopularity popularity;

          isPinned =
              data['popularity'] == CurrentPostPopularity.pinned.toString();

          if (isPinned) {
            popularity = CurrentPostPopularity.pinned;
          } else {
            popularity = EnumToString.fromString(CurrentPostPopularity.values,
                data['type'].toString().split('.')[1]);
          }
          username = data['username'];

          final timeAgo = DateTime.fromMillisecondsSinceEpoch(data['timestamp'])
              .subtract(Duration(seconds: DateTime.now().second));

          print(data['bookmarked'][uid]);
          print(data['liked'][uid]);

          currentPostList = [
            PostHeaderItem(
              username: data['username'],
              profileImage: data['profileImage'],
              timestamp: timeago.format(timeAgo, locale: 'en_short'),
              body: data['body'],
              popularity: popularity,
              postUid: widget.postUid,
              challengeUid: data['challengeUid'],
              challengeTitle: data['challengeTitle'],
              image: data['image'],
              video: data['video'],
              bookmarked: data['bookmarked'][uid] ?? false,
              comments: data['comments'],
              liked: data['liked'][uid] ?? false,
              likes: data['likes'],
            ),
          ];

          setState(() {
            isLoading = false;
            postExists = true;
          });
        } else {
          setState(() {
            isLoading = false;
            postExists = false;
          });
        }
      });
    }
  }

  Widget buildList() {
    if (isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              height: 50,
              child: SpinKitRing(
                color: Colors.black,
                lineWidth: 5,
                size: 40,
              ),
            ),
          )
        ],
      );
    } else {
      if (postExists) {
        return Column(
          children: <Widget>[
            Expanded(
              child: SmartRefresher(
                controller: postRefreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: refreshHeader(),
                footer: refreshFooter(),
                onLoading: () {
                  loadMoreComments();
                },
                onRefresh: () {
                  postRefreshController.refreshCompleted();
                },
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  key: _listKey,
                  itemCount: currentPostList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildPost(context, currentPostList[index], index);
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
                            padding: EdgeInsets.only(
                                right: 10.0, left: 10.0, top: 12, bottom: 12),
                            child: Stack(
                              children: <Widget>[
                                commentController.text.length == 0
                                    ? Text(
                                        'Add comment',
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Container(),
                                SocialKeyboard(
                                  controller: commentController,
                                  cursorColor: Theme.of(context).cursorColor,
                                  maxLines: 1,
                                  basicStyle: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  onChanged: (text) {
                                    setState(() {});
                                  },
                                  focusNode: mainNode,
                                  decoratedStyle: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: hebenRed,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            EvaIcons.paperPlaneOutline,
                            color: hebenActive,
                          ),
                          onPressed: () async {
                            if (commentController.text.trim().length != 0) {
                              FocusScope.of(context).requestFocus(FocusNode());

                              DocumentReference docRef = Firestore.instance
                                  .collection('posts')
                                  .document(widget.postUid)
                                  .collection('comments')
                                  .document();

                              DocumentSnapshot userSnapshot =
                                  await User().getUserProfileInfo();

                              setState(() {
                                currentPostList.insert(
                                  1,
                                  PostCommentItem(
                                      username: userSnapshot.data['username'],
                                      profileImage:
                                          userSnapshot.data['profileImage'],
                                      timestamp: 'now',
                                      postUid: widget.postUid,
                                      body: commentController.text,
                                      commentUid: docRef.documentID,
                                      userUid: userSnapshot.data['uid']),
                                );
                              });

                              List<String> atList = [];
                              List<String> tagList = [];

                              commentController.text
                                  .trim()
                                  .split(' ')
                                  .forEach((str) {
                                if (str.contains('@', 0)) {
                                  atList.add(str.substring(1));
                                } else if (str.contains('#', 0)) {
                                  tagList.add(str);
                                }
                              });

                              PostContentType type;

                              if (widget.video != null) {
                                type = PostContentType.video;
                              } else if (widget.image != null) {
                                type = PostContentType.image;
                              } else {
                                type = PostContentType.text;
                              }

                              Social().tagUsers(
                                  atUsers: atList.toSet().toList(),
                                  postUid: widget.postUid,
                                  body: commentController.text.trim(),
                                  type: type.toString());

                              Social().hashtags(
                                  tagList: tagList.toSet().toList(),
                                  postUid: docRef.documentID);

                              final batch = Firestore.instance.batch();

                              batch.updateData(
                                  Firestore.instance
                                      .collection('posts')
                                      .document(widget.postUid),
                                  {
                                    'score': FieldValue.increment(50),
                                    'comments': FieldValue.increment(1)
                                  });

                              batch.setData(docRef, {
                                'username': userSnapshot.data['username'],
                                'profileImage':
                                    userSnapshot.data['profileImage'],
                                'timestamp':
                                    DateTime.now().millisecondsSinceEpoch,
                                'body': commentController.text.trim(),
                                'commentUid': docRef.documentID,
                                'userUid': userSnapshot.data['uid']
                              });

                              if (userSnapshot.data['username'] !=
                                  widget.username) {
                                batch.setData(
                                    Firestore.instance
                                        .collection('notifications')
                                        .document(),
                                    {
                                      'receiverUsername': widget.username,
                                      'senderUid': userSnapshot.data['uid'],
                                      'profileImage':
                                          userSnapshot.data['profileImage'],
                                      'timestamp':
                                          DateTime.now().millisecondsSinceEpoch,
                                      'type': 'commented',
                                      'postType': type.toString(),
                                      'postUid': widget.postUid,
                                      'senderUsername':
                                          userSnapshot.data['username'],
                                      'body': commentController.text.trim(),
                                    });
                              }

                              batch.commit();

                              commentController.clear();
                            } else {
                              showOverlayNotification((context) {
                                return WarningToast(
                                    message:
                                        'Please make sure there is text in your comment');
                              });
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return Container(
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
                  'Sorry, post doesn\'t exist',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
              )
            ],
          ),
        );
      }
    }
  }

  loadComments() {
    Firestore.instance
        .collection('posts')
        .document(widget.postUid)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents.length == 1 || snapshot.documents.length == 0) {
        lastDocument = null;
      } else {
        lastDocument = snapshot.documents.last;
      }

      snapshot.documents.forEach((doc) {
        final timeAgo =
            DateTime.fromMillisecondsSinceEpoch(doc.data['timestamp'])
                .subtract(Duration(seconds: DateTime.now().second));

        setState(() {
          currentPostList.insert(
            1,
            PostCommentItem(
                username: doc.data['username'],
                profileImage: doc.data['profileImage'],
                timestamp: timeago.format(timeAgo, locale: 'en_short'),
                body: doc.data['body'],
                postUid: widget.postUid,
                commentUid: doc.documentID,
                userUid: doc.data['userUid']),
          );
        });
      });
    });
  }

  loadMoreComments() {
    if (lastDocument != null) {
      Firestore.instance
          .collection('posts')
          .document(widget.postUid)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(lastDocument)
          .limit(10)
          .getDocuments()
          .then((snapshot) {
        if (snapshot.documents.length == 1 || snapshot.documents.length == 0) {
          lastDocument = null;
        } else {
          lastDocument = snapshot.documents.last;
        }
        snapshot.documents.forEach((doc) {
          final timeAgo =
              DateTime.fromMillisecondsSinceEpoch(doc.data['timestamp'])
                  .subtract(Duration(seconds: DateTime.now().second));

          setState(() {
            currentPostList.insert(
              1,
              PostCommentItem(
                  username: doc.data['username'],
                  profileImage: doc.data['profileImage'],
                  timestamp: timeago.format(timeAgo, locale: 'en_short'),
                  body: doc.data['body'],
                  commentUid: doc.documentID,
                  postUid: widget.postUid,
                  userUid: doc.data['userUid']),
            );
          });
        });
      });
      postRefreshController.loadComplete();
    } else {
      postRefreshController.loadNoData();
    }
  }
}
