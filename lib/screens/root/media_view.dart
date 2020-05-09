import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/content/content_header.dart';
import 'package:heben/components/modals.dart';
import 'package:heben/screens/root/friend.dart';
import 'package:heben/screens/root/tag.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/constants.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/navigation.dart';
import 'package:heben/utils/user.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class MediaView extends StatefulWidget {
  MediaView({
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
  _MediaViewState createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  double _itemsOpacity = 1.0;
  bool _isPlaying = false;
  VideoPlayerController _controller;
  Map<String, HighlightedWord> words = {};

  @override
  void initState() {
    _itemsOpacity = 1.0;
    if (widget.body != null && widget.body.trim() != '') {
      highlightBodyText();
    }
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

    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    super.initState();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _itemsOpacity = _itemsOpacity == 0.0 ? 1.0 : 0.0;
        });
      },
      onVerticalDragStart: (end) {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: GFAppBar(
          elevation: 0,
          leading: AnimatedOpacity(
            duration: Duration(milliseconds: 250),
            opacity: _itemsOpacity,
            child: IconButton(
                icon: Icon(
                  EvaIcons.close,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          actions: <Widget>[
            AnimatedOpacity(
              duration: Duration(milliseconds: 250),
              opacity: _itemsOpacity,
              child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: IconButton(
                    icon: Icon(
                      EvaIcons.moreHorizotnal,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      User().getUsername().then((userUsername) {
                        Modal().postOptions(context,
                            userUsername == widget.username, widget.postUid);
                      });
                    }),
              ),
            ),
          ],
          brightness: Brightness.dark,
          backgroundColor: Colors.black38,
        ),
        body: Stack(children: [
          Center(child: mediaWidget(DeviceSize().getWidth(context))),
          AnimatedOpacity(
            duration: Duration(milliseconds: 250),
            opacity: _itemsOpacity,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.black38,
                  child: ContentHeaderDark(
                    width: DeviceSize().getWidth(context),
                    username: widget.username,
                    profileImage: widget.profileImage,
                    timestamp: widget.timestamp,
                    popularity: widget.popularity,
                    postUid: widget.postUid,
                    moreDisabled: true,
                  ),
                ),
                widget.body != null && widget.body.trim() != ''
                    ? Container(
                        width: DeviceSize().getWidth(context),
                        color: Colors.black38,
                        child: Padding(
                          padding: kWidgetPadding,
                          child: textWidget(DeviceSize().getWidth(context)),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ]),
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
                  page:
                      Friend(uid: null, username: str.toString().substring(1)),
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
                color: Colors.white, fontWeight: FontWeight.w500));
      }
    });
    setState(() {});
  }

  Widget mediaWidget(width) {
    if (widget.image != null) {
      return PhotoView(
        imageProvider: NetworkImage(widget.image),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.contained,
        initialScale: PhotoViewComputedScale.contained,
        loadingBuilder: (BuildContext context, ImageChunkEvent chunk) {
          return Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Container(
                    color: Colors.black,
                    child:
                        Center(child: SpinKitDoubleBounce(color: Colors.white)),
                  ),
                ),
              )
            ],
          );
        },
      );
    } else if (widget.video != null) {
      return _controller.value.initialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: Center(child: SpinKitDoubleBounce(color: Colors.white)),
              ),
            );
    } else {
      return Container();
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
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: width,
            color: Colors.transparent,
            child: TextHighlight(
              textAlign: TextAlign.start,
              text: widget.body
                  .trim(), // You need to pass the string you want the highlights
              words: words, // Your dictionary words
              textStyle: GoogleFonts.openSans(
                  color: Colors.white, fontWeight: FontWeight.w500),
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
          color: Colors.white,
        ),
      );
    }
  }

  playVideo() {
    if (_controller.value.initialized) {
      _controller
        ..setVolume(100)
        ..setLooping(true)
        ..play().then((_) {
          setState(() {});
        });
    }
  }
}
