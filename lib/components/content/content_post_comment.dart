import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/screens/root/friend.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/navigation.dart';
import 'package:highlight_text/highlight_text.dart';

class ContentPostComment extends StatefulWidget {
  ContentPostComment({@required this.body});

  final String body;
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
    return Container(
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
                Navigation()
                    .segue(page: Friend(), context: context, fullScreen: false);
              },
              child: GFAvatar(
                size: 25,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                    'https://source.unsplash.com/1600x900/?portrait,woman'),
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
                          Faker().internet.userName(),
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '30 mins',
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
                fontWeight: FontWeight.w600, color: hebenTrendingColor));
      } else {}
    });
    setState(() {});
  }
}
