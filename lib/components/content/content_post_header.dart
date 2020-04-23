import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/content/content_header.dart';
import 'package:heben/screens/root/friend.dart';
import 'package:heben/screens/root/media_view.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/constants.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/navigation.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';

class ContentPostHeader extends StatefulWidget {
  ContentPostHeader({
    @required this.username,
    @required this.profileImage,
    @required this.timestamp,
    @required this.body,
    @required this.image,
    @required this.video,
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
  _ContentPostHeaderState createState() => _ContentPostHeaderState();
}

class _ContentPostHeaderState extends State<ContentPostHeader> {
  VideoPlayerController _controller;
  int currentLikes;
  int currentComments;
  bool _isPlaying = false;
  bool currentlyLiked;
  bool currentlyBookmarked;
  Map<String, HighlightedWord> words = {};

  @override
  void initState() {
    highlightBodyText();
    currentLikes = widget.likes;
    currentComments = widget.comments;
    currentlyLiked = widget.liked;
    currentlyBookmarked = widget.bookmarked ?? false;

    if (widget.video != null) {
      _controller = VideoPlayerController.network(
        widget.video,
      )
        ..addListener(() {
          final bool isPlaying = _controller.value.isPlaying;
          if (isPlaying != _isPlaying) {
            setState(() {
              _isPlaying = isPlaying;
            });
          }
        })
        ..initialize().then((_) {
          playVideo();
        });
    }

    super.initState();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
      ),
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
            moreDisabled: true,
          ),
          widget.challengeTitle != null
              ? Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 0),
                  child: Text(
                    widget.challengeTitle,
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                )
              : Container(),
          Padding(
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
          ),
          mediaWidget(DeviceSize().getWidth(context)),
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
                        style: kStatsTextStyle.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                LikeButton(
                  size: 25,
                  circleColor:
                      CircleColor(start: Colors.black, end: Colors.redAccent),
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
                    var color = isLiked ? Colors.redAccent : Colors.grey;
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
                  circleColor:
                      CircleColor(start: Colors.black, end: hebenBookmarkColor),
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
            onTap: () {},
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

  Widget mediaWidget(width) {
    if (widget.image != null) {
      return GestureDetector(
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
                liked: widget.liked,
                likes: widget.likes,
              )));
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Image(
            image: NetworkImage(widget.image),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (widget.video != null) {
      return GestureDetector(
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
                liked: widget.liked,
                likes: widget.likes,
              )));
        },
        child: heroWidget(DeviceSize().getWidth(context)),
      );
    } else {
      return Container();
    }
  }

  Widget heroWidget(width) {
    setState(() {});
    if (_controller != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: _controller.value.initialized
            ? videoResizing(width)
            : AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black,
                  child:
                      Center(child: SpinKitDoubleBounce(color: Colors.white)),
                ),
              ),
      );
    } else {
      return Container();
    }
  }

  Widget videoResizing(width) {
    if (_controller.value.size.aspectRatio > 1) {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      );
    } else {
      return Container(
        width: width,
        height: width,
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size?.width ?? 0,
              height: _controller.value.size?.height ?? 0,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
      );
    }
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
                style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
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
              textStyle: GoogleFonts.openSans(
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
    } else {
      return TextHighlight(
        text: widget.body
            .trim(), // You need to pass the string you want the highlights
        words: words, // Your dictionary words
        textStyle: GoogleFonts.openSans(
          color: Colors.black,
        ),
      );
    }
  }

  playVideo() {
    if (_controller.value.initialized) {
      _controller
        ..setVolume(0)
        ..setLooping(true)
        ..play().then((_) {
          setState(() {});
        });
    }
  }
}
