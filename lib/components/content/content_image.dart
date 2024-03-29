import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/content/content_header.dart';
import 'package:heben/screens/root/challenge_page.dart';
import 'package:heben/screens/root/friend.dart';
import 'package:heben/screens/root/media_view.dart';
import 'package:heben/screens/root/post.dart';
import 'package:heben/screens/root/tag.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/constants.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/navigation.dart';
import 'package:heben/utils/social.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:like_button/like_button.dart';
import 'package:vibrate/vibrate.dart';

class ContentImage extends StatefulWidget {
  ContentImage({
    @required this.username,
    @required this.profileImage,
    @required this.timestamp,
    @required this.body,
    @required this.image,
    @required this.popularity,
    @required this.likes,
    @required this.liked,
    @required this.comments,
    @required this.postUid,
    @required this.bookmarked,
    @required this.challengeUid,
    @required this.challengeTitle,
  });

  final String username;
  final String profileImage;
  final String timestamp;
  final String body;
  final String image;
  final CurrentPostPopularity popularity;
  final int likes;
  final bool liked;
  final int comments;
  final String postUid;
  final bool bookmarked;
  final String challengeTitle;
  final String challengeUid;

  @override
  _ContentImageState createState() => _ContentImageState();
}

class _ContentImageState extends State<ContentImage> {
  int currentLikes;
  int currentComments;
  bool currentlyLiked;
  bool currentlyBookmarked;
  Map<String, HighlightedWord> words = {};

  @override
  void initState() {
    if (widget.body != null && widget.body.trim() != '') {
      highlightBodyText();
    }

    currentLikes = widget.likes;
    currentComments = widget.comments;
    currentlyLiked = widget.liked;
    currentlyBookmarked = widget.bookmarked ?? false;
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
    return GestureDetector(
      onTap: () {
        Navigation().segue(
            page: Post(
              username: widget.username,
              profileImage: widget.profileImage,
              timestamp: widget.timestamp,
              body: widget.body,
              isNotification: false,
              popularity: widget.popularity,
              postUid: widget.postUid,
              challengeUid: widget.challengeUid,
              challengeTitle: widget.challengeTitle,
              image: widget.image,
              video: null,
              bookmarked: widget.bookmarked,
              comments: widget.comments,
              liked: currentlyLiked,
              likes: widget.likes,
            ),
            context: context,
            fullScreen: false);
      },
      child: Column(
        children: <Widget>[
          Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ContentHeaderLight(
                    width: DeviceSize().getWidth(context),
                    username: widget.username,
                    profileImage: widget.profileImage,
                    timestamp: widget.timestamp,
                    popularity: widget.popularity,
                    postUid: widget.postUid,
                  ),
                  widget.challengeTitle != null
                      ? GestureDetector(
                          onTap: () {
                            Navigation().segue(
                                page: ChallengePage(
                                  challengeUid: widget.challengeUid,
                                  duration: null,
                                  timestamp: null,
                                  challengeTitle: widget.challengeTitle,
                                ),
                                context: context,
                                fullScreen: false);
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, bottom: 0),
                            child: Text(
                              widget.challengeTitle,
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          ),
                        )
                      : Container(),
                  widget.body != null && widget.body.trim() != ''
                      ? Padding(
                          padding: kWidgetPadding,
                          child: TextHighlight(
                            text: widget.body
                                .trim(), // You need to pass the string you want the highlights
                            words: words, // Your dictionary words
                            textStyle: GoogleFonts.openSans(
                              color: Colors.black,
                            ),
                            // textStyle: kBodyTextStyle,
                          ),
                        )
                      : Container(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          FadeRoute(
                              page: MediaView(
                            username: widget.username,
                            profileImage: widget.profileImage,
                            timestamp: widget.timestamp,
                            body: widget.body,
                            popularity: widget.popularity,
                            postUid: widget.postUid,
                            challengeUid: widget.challengeUid,
                            challengeTitle: widget.challengeTitle,
                            image: widget.image,
                            video: null,
                            bookmarked: widget.bookmarked,
                            comments: widget.comments,
                            liked: currentlyLiked,
                            likes: widget.likes,
                          )));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Image.network(
                        widget.image,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: Container(
                              width: DeviceSize().getWidth(context),
                              height: DeviceSize().getWidth(context),
                              color: Colors.black,
                              child: Center(
                                  child:
                                      SpinKitDoubleBounce(color: Colors.white)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: kWidgetPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Icon(
                                  EvaIcons.messageSquare,
                                  size: 24,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '$currentComments',
                                style: kStatsTextStyle.copyWith(
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        LikeButton(
                          size: 25,
                          onTap: onLikeButtonTapped,
                          circleColor: CircleColor(
                              start: Colors.black, end: Colors.redAccent),
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: Colors.black,
                            dotSecondaryColor: Colors.redAccent,
                          ),
                          isLiked: widget.liked,
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              EvaIcons.heart,
                              color: isLiked ? Colors.redAccent : Colors.grey,
                              size: 25,
                            );
                          },
                          likeCount: currentLikes,
                          countBuilder: (int count, bool isLiked, String text) {
                            var color =
                                isLiked ? Colors.redAccent : Colors.grey;
                            Widget result;
                            if (count == 0) {
                              result = Text(
                                "like",
                                style: kStatsTextStyle.copyWith(color: color),
                              );
                            } else
                              result = Text(
                                text,
                                style: kStatsTextStyle.copyWith(color: color),
                              );
                            return result;
                          },
                        ),
                        LikeButton(
                          size: 25,
                          onTap: onBookmarkButtonTapped,
                          circleColor: CircleColor(
                              start: Colors.black, end: hebenBookmarkColor),
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: Colors.black,
                            dotSecondaryColor: hebenBookmarkColor,
                          ),
                          isLiked: widget.bookmarked,
                          likeBuilder: (bool currentlyBookmarked) {
                            return Icon(
                              currentlyBookmarked
                                  ? EvaIcons.bookmark
                                  : EvaIcons.bookmarkOutline,
                              color: currentlyBookmarked
                                  ? hebenBookmarkColor
                                  : Colors.grey,
                              size: 25,
                            );
                          },
                          likeCount: currentLikes,
                          countBuilder: (int count, bool isLiked, String text) {
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Divider(
            color: Colors.grey[200],
            height: 0.5,
          ),
        ],
      ),
    );
  }

  void highlightBodyText() async {
    final textArray = widget.body.trim().split(' ');
    await Future.forEach(textArray, (str) async {
      if (str.contains('@', 0)) {
        words[str] = HighlightedWord(
            onTap: () {
              Navigation().segue(
                  page: Friend(
                    uid: null,
                    username: str.toString().substring(1),
                  ),
                  context: context,
                  fullScreen: false);
            },
            textStyle: GoogleFonts.openSans(
                fontWeight: FontWeight.w600, color: hebenActive));
      } else if (str.contains('#', 0)) {
        words[str] = HighlightedWord(
            onTap: () {
              Navigation().segue(
                  page: Tag(
                    tag: str,
                  ),
                  context: context,
                  fullScreen: false);
            },
            textStyle: GoogleFonts.openSans(
                fontWeight: FontWeight.w700, color: hebenActive));
      } else {
        words[str] = HighlightedWord(
            onTap: () {},
            textStyle: GoogleFonts.openSans(
                color: Colors.black, fontWeight: FontWeight.w500));
      }
    });
    setState(() {});
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    Vibrate.feedback(FeedbackType.medium);
    if (!isLiked) {
      Social()
          .likePost(postUid: widget.postUid, receiverUsername: widget.username);
    } else {
      Social().unlikePost(postUid: widget.postUid);
    }
    return !isLiked;
  }

  Future<bool> onBookmarkButtonTapped(bool isLiked) async {
    Vibrate.feedback(FeedbackType.medium);
    if (!isLiked) {
      Social().bookmarkPost(postUid: widget.postUid);
    } else {
      Social().unBookmarkPost(postUid: widget.postUid);
    }
    return !isLiked;
  }
}
