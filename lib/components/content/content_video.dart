import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/content/content_header.dart';
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
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContentVideo extends StatefulWidget {
  ContentVideo({
    @required this.username,
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
  });

  final String username;
  final String profileImage;
  final String timestamp;
  final String body;
  final String video;
  final CurrentPostPopularity popularity;
  final int likes;
  final bool liked;
  final int comments;
  final String postUid;
  final bool bookmarked;
  final String challengeTitle;
  final String challengeUid;

  @override
  _ContentVideoState createState() => _ContentVideoState();
}

class _ContentVideoState extends State<ContentVideo> {
  bool _isPlaying;
  int currentLikes;
  int currentComments;
  bool currentlyLiked;
  bool currentlyBookmarked;
  Map<String, HighlightedWord> words = {};

  VideoPlayerController videoControllerGlobal;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    highlightBodyText();
    currentLikes = widget.likes;
    currentlyLiked = widget.liked;
    currentComments = widget.comments;
    currentlyBookmarked = widget.bookmarked ?? false;

    videoControllerGlobal = VideoPlayerController.network(
      widget.video,
    )
      ..addListener(() {
        final bool isPlaying = videoControllerGlobal.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        playVideo();
      });
    super.initState();
  }

  @override
  void dispose() {
    if (videoControllerGlobal != null) {
      videoControllerGlobal.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.postUid),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction == 0) {
          videoControllerGlobal.pause();
        } else {
          videoControllerGlobal.play();
        }
      },
      child: GestureDetector(
        onTap: () {
          Navigation().segue(
              page: Post(
                username: widget.username,
                profileImage: widget.profileImage,
                timestamp: widget.timestamp,
                body: widget.body,
                popularity: widget.popularity,
                postUid: widget.postUid,
                challengeUid: widget.challengeUid,
                challengeTitle: widget.challengeTitle,
                image: null,
                video: widget.video,
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
                        ? Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, bottom: 0),
                            child: Text(
                              widget.challengeTitle,
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w700, fontSize: 16),
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
                              textStyle: kBodyTextStyle,
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
                              image: null,
                              video: widget.video,
                              bookmarked: widget.bookmarked,
                              comments: widget.comments,
                              liked: currentlyLiked,
                              likes: widget.likes,
                            )));
                      },
                      child: heroWidget(DeviceSize().getWidth(context)),
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
                            countBuilder:
                                (int count, bool isLiked, String text) {
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
                            countBuilder:
                                (int count, bool isLiked, String text) {
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
      ),
    );
  }

  Widget videoResizing(width) {
    if (videoControllerGlobal.value.size.aspectRatio > 1) {
      return AspectRatio(
        aspectRatio: videoControllerGlobal.value.aspectRatio,
        child: VideoPlayer(videoControllerGlobal),
      );
    } else {
      return Container(
        width: width,
        height: width,
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: videoControllerGlobal.value.size?.width ?? 0,
              height: videoControllerGlobal.value.size?.height ?? 0,
              child: VideoPlayer(videoControllerGlobal),
            ),
          ),
        ),
      );
    }
  }

  Widget heroWidget(width) {
    setState(() {});
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: videoControllerGlobal.value.initialized
          ? videoResizing(DeviceSize().getWidth(context))
          : AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: Center(child: SpinKitDoubleBounce(color: Colors.white)),
              ),
            ),
    );
  }

  playVideo() {
    if (videoControllerGlobal.value.initialized) {
      videoControllerGlobal
        ..setVolume(0)
        ..setLooping(false)
        ..play().then((_) {
          setState(() {});
        });
    }
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

  Widget textWidget(width) {
    if (widget.challengeTitle != null && widget.challengeUid != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                '${widget.challengeTitle}',
                // style: kBodyTextStyle.copyWith(
                //     fontSize: 16, fontWeight: FontWeight.w600, color: hebenRed),
              ),
            ),
          ),
          Container(
            width: width,
            color: Colors.white,
            child: TextHighlight(
              textAlign: TextAlign.start,
              text: widget.body
                  .trim(), // You need to pass the string you want the highlights
              words: words, // Your dictionary words
              // textStyle: kBodyTextStyle,
            ),
          ),
        ],
      );
    } else {
      return TextHighlight(
        text: widget.body
            .trim(), // You need to pass the string you want the highlights
        words: words, // Your dictionary words
        textStyle: kBodyTextStyle,
      );
    }
  }

  String durationOfVideo(Duration duration, Duration position) {
    final secondsLeft = duration.inSeconds - position.inSeconds;
    if (secondsLeft < 10) {
      return '0$secondsLeft';
    } else {
      return '$secondsLeft';
    }
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
