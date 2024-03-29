import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/modals.dart';
import 'package:heben/components/toast.dart';
import 'package:heben/screens/root/friend.dart';
import 'package:heben/screens/root/tag.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/navigation.dart';
import 'package:heben/utils/user.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:overlay_support/overlay_support.dart';

class ContentPostComment extends StatefulWidget {
  ContentPostComment(
      {@required this.username,
      @required this.profileImage,
      @required this.timestamp,
      @required this.body,
      @required this.commentUid,
      @required this.postUid,
      @required this.userUid});

  final String username;
  final String profileImage;
  final String timestamp;
  final String body;
  final String commentUid;
  final String postUid;
  final String userUid;
  @override
  _ContentPostCommentState createState() => _ContentPostCommentState();
}

class _ContentPostCommentState extends State<ContentPostComment> {
  final Map<String, HighlightedWord> words = {};

  @override
  void initState() {
    highlightBodyText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        User().getUsername().then((userUsername) {
          Modal().postCommentOptions(
              context, userUsername == widget.username, deleteComment);
        });
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 50),
        padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 6.0),
              child: GestureDetector(
                onTap: () {
                  User().getUsername().then((userUsername) {
                    if (userUsername != widget.username) {
                      Navigation().segue(
                          page: Friend(
                            uid: widget.userUid,
                            username: widget.username,
                          ),
                          context: context,
                          fullScreen: false);
                    }
                  });
                },
                child: GFAvatar(
                  size: 25,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(widget.profileImage),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.username,
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          widget.timestamp,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.grey[500]),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: TextHighlight(
                        textAlign: TextAlign.start,
                        text: widget.body
                            .trim(), // You need to pass the string you want the highlights
                        words: words, // Your dictionary words
                        textStyle: GoogleFonts.openSans(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  deleteComment() {
    final batch = Firestore.instance.batch();
    batch.setData(
        Firestore.instance.collection('posts').document(widget.postUid),
        {'comments': FieldValue.increment(-1)},
        merge: true);

    batch.delete(Firestore.instance
        .collection('posts')
        .document(widget.postUid)
        .collection('comments')
        .document(widget.commentUid));

    batch.commit().then((_) {
      showOverlayNotification((context) {
        return SuccessToast(message: 'Comment hast been removed');
      });
    });
  }
}
