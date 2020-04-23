import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/content/content_badges.dart';
import 'package:heben/components/modals.dart';
import 'package:heben/screens/root/friend.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/navigation.dart';

/*
  light content header
*/

class ContentHeaderLight extends StatelessWidget {
  ContentHeaderLight(
      {@required this.width,
      @required this.username,
      @required this.profileImage,
      @required this.timestamp,
      @required this.popularity,
      @required this.postUid,
      this.moreDisabled});

  final double width;
  final String username;
  final String profileImage;
  final String timestamp;
  final String postUid;
  final CurrentPostPopularity popularity;
  final bool moreDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      padding: EdgeInsets.fromLTRB(15, 6, 15, 6),
      margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
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
                  page: Friend(
                    uid: null,
                    username: username,
                  ),
                  context: context,
                  fullScreen: false);
            },
            child: GFAvatar(
              size: 25,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(profileImage),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        username,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        timestamp,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: ContentBadges(
                      popularity: popularity,
                      isDark: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
          moreDisabled != null
              ? moreDisabled
                  ? Container()
                  : IconButton(
                      icon: Icon(EvaIcons.moreHorizotnal),
                      onPressed: () {
                        Modal().postOptions(context);
                      })
              : IconButton(
                  icon: Icon(EvaIcons.moreHorizotnal),
                  onPressed: () {
                    Modal().postOptions(context);
                  })
        ],
      ),
    );
  }
}

class ContentHeaderDark extends StatelessWidget {
  ContentHeaderDark(
      {@required this.width,
      @required this.username,
      @required this.profileImage,
      @required this.timestamp,
      @required this.popularity,
      @required this.postUid,
      this.moreDisabled});

  final double width;
  final String username;
  final String profileImage;
  final String timestamp;
  final String postUid;
  final CurrentPostPopularity popularity;
  final bool moreDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
      margin: EdgeInsets.fromLTRB(0, 8, 0, 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigation().segue(
                  page: Friend(
                    uid: null,
                    username: username,
                  ),
                  context: context,
                  fullScreen: false);
            },
            child: GFAvatar(
              size: 25,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(profileImage),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        username,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        timestamp,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.75)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: ContentBadges(
                      popularity: popularity,
                      isDark: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          moreDisabled != null
              ? moreDisabled
                  ? Container()
                  : IconButton(
                      icon: Icon(
                        EvaIcons.moreHorizotnal,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Modal().postOptions(context);
                      })
              : IconButton(
                  icon: Icon(
                    EvaIcons.moreHorizotnal,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Modal().postOptions(context);
                  })
        ],
      ),
    );
  }
}
