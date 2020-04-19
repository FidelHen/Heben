import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/screens/root/friend.dart';
import 'package:heben/screens/root/post.dart';
import 'package:heben/screens/root/tag.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/navigation.dart';
import 'package:highlight_text/highlight_text.dart';

class NotificationTagged extends StatefulWidget {
  NotificationTagged({
    @required this.username,
    @required this.profileImage,
    @required this.timestamp,
    @required this.firstIndex,
    @required this.body,
    @required this.postUid,
    @required this.postType,
  });

  final String username;
  final String profileImage;
  final String timestamp;
  final bool firstIndex;
  final String body;
  final String postUid;
  final String postType;

  @override
  _NotificationTaggedState createState() => _NotificationTaggedState();
}

class _NotificationTaggedState extends State<NotificationTagged> {
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
        Navigation().segue(
            page: Post(
              username: Faker().internet.userName(),
              profileImage: 'https://i.pravatar.cc/300',
              timestamp: '1 hr',
              body: Faker().lorem.sentence() + ' @Hello @world',
              image: 'https://source.unsplash.com/1600x900/?challenge',
              popularity: CurrentPostPopularity.trending,
              likes: 1,
              liked: false,
              comments: 10,
              postUid: Faker().randomGenerator.string(10),
              bookmarked: true,
              challengeUid: Faker().randomGenerator.string(10),
              challengeTitle: '25 Push Up Challenge',
              video: null,
            ),
            context: context,
            fullScreen: false);
      },
      child: Container(
        decoration: widget.firstIndex
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
              )
            : BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            Container(
              constraints: const BoxConstraints(minHeight: 50),
              padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
              margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigation().segue(
                          page: Friend(), context: context, fullScreen: false);
                    },
                    child: GFAvatar(
                      size: 25,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(widget.profileImage),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: '@' + widget.username,
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black)),
                                TextSpan(
                                    text: ' tagged you',
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700])),
                              ])),
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
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
                            ),
                          )
                        ],
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
            ),
            Divider(
              color: Colors.grey[200],
              height: 0.5,
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
              Navigation()
                  .segue(page: Friend(), context: context, fullScreen: false);
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
}
