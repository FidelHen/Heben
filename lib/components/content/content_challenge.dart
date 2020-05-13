import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heben/components/content/content_header.dart';
import 'package:heben/screens/root/challenge_page.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/constants.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/navigation.dart';
import 'package:heben/utils/social.dart';
import 'package:like_button/like_button.dart';
import 'package:vibrate/vibrate.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContentChallenge extends StatefulWidget {
  ContentChallenge(
      {@required this.username,
      @required this.profileImage,
      @required this.timestamp,
      @required this.challengeTitle,
      @required this.video,
      @required this.popularity,
      @required this.likes,
      @required this.liked,
      @required this.image,
      @required this.bookmarked,
      @required this.participants,
      @required this.postUid,
      @required this.creatorUid,
      @required this.intTimestamp,
      @required this.comments,
      @required this.duration});

  final String username;
  final String profileImage;
  final String timestamp;
  final int intTimestamp;
  final String challengeTitle;
  final String video;
  final CurrentPostPopularity popularity;
  final int likes;
  final bool liked;
  final String image;
  final int participants;
  final String postUid;
  final String creatorUid;
  final bool bookmarked;
  final int comments;
  final String duration;

  @override
  _ContentChallengeState createState() => _ContentChallengeState();
}

class _ContentChallengeState extends State<ContentChallenge> {
  VideoPlayerController _controller;
  bool _isPlaying = false;
  bool currentlyLiked;
  bool currentlyBookmarked;
  int currentLikes;

  @override
  void initState() {
    currentLikes = widget.likes;
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
    double width = MediaQuery.of(context).size.width;

    return VisibilityDetector(
      key: Key(widget.postUid),
      onVisibilityChanged: (VisibilityInfo info) {
        if (widget.video != null) {
          if (info.visibleFraction == 0) {
            _controller.pause();
          } else {
            _controller.play();
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          Navigation().segue(
              page: ChallengePage(
                challengeUid: widget.postUid,
                duration: widget.duration,
                timestamp: widget.intTimestamp,
                challengeTitle: widget.challengeTitle,
              ),
              context: context,
              fullScreen: false);
        },
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                widget.video != null
                    ? Container(
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
                      )
                    : Center(
                        child: Container(
                          width: width,
                          height: width,
                          child: Image(
                            image: NetworkImage(widget.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                Container(
                  height: width,
                  width: width,
                  decoration: BoxDecoration(
                    color: hebenContentOverlay,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ContentHeaderDark(
                        width: width,
                        username: widget.username,
                        profileImage: widget.profileImage,
                        popularity: widget.popularity,
                        postUid: widget.postUid,
                        timestamp: widget.timestamp,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: AutoSizeText(
                          widget.challengeTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          minFontSize: 26,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                                      EvaIcons.peopleOutline,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${widget.participants}',
                                    style: kStatsTextStyle.copyWith(
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            LikeButton(
                              size: 25,
                              circleColor: CircleColor(
                                  start: Colors.white, end: Colors.redAccent),
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: Colors.white,
                                dotSecondaryColor: Colors.redAccent,
                              ),
                              isLiked: widget.liked,
                              onTap: onLikeButtonTapped,
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  EvaIcons.heart,
                                  color:
                                      isLiked ? Colors.redAccent : Colors.white,
                                  size: 25,
                                );
                              },
                              likeCount: currentLikes,
                              countBuilder:
                                  (int count, bool isLiked, String text) {
                                var color =
                                    isLiked ? Colors.redAccent : Colors.white;
                                Widget result;
                                if (count == 0) {
                                  result = Text(
                                    "like",
                                    style:
                                        kStatsTextStyle.copyWith(color: color),
                                  );
                                } else
                                  result = Text(
                                    text,
                                    style:
                                        kStatsTextStyle.copyWith(color: color),
                                  );
                                return result;
                              },
                            ),
                            LikeButton(
                              size: 25,
                              onTap: onBookmarkButtonTapped,
                              circleColor: CircleColor(
                                  start: Colors.white, end: hebenBookmarkColor),
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: Colors.white,
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
                                      : Colors.white,
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
                  ),
                ),
              ],
            ),
            Divider(
              height: 0.5,
              color: Colors.grey[200],
            )
          ],
        ),
      ),
    );
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
