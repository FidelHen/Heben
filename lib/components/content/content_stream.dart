import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/content/content_badges.dart';
import 'package:heben/screens/root/friend.dart';
import 'package:heben/screens/root/view_stream.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/navigation.dart';

class ContentStream extends StatelessWidget {
  ContentStream({
    @required this.username,
    @required this.profileImage,
    @required this.popularity,
    @required this.image,
    @required this.watchers,
    @required this.postUid,
    @required this.creatorUid,
  });

  final String username;
  final String profileImage;
  final CurrentPostPopularity popularity;
  final String image;
  final int watchers;
  final String postUid;
  final String creatorUid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigation()
            .segue(page: ViewStream(), context: context, fullScreen: true);
      },
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: 15.0,
              left: 15.0,
            ),
            child: Container(
              child: Row(children: [
                Container(
                  height: 150,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              ContentBadges(
                                  popularity: popularity, isDark: false)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigation().segue(
                                          page: Friend(
                                            uid: creatorUid,
                                            username: username,
                                          ),
                                          context: context,
                                          fullScreen: false);
                                    },
                                    child: GFAvatar(
                                      size: 20,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          NetworkImage(profileImage),
                                    ),
                                  ),
                                ),
                                Text(
                                  username,
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 2.0),
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                                    decoration: BoxDecoration(
                                      color: hebenActive,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    ),
                                    child: Text(Faker().lorem.word(),
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 2.0),
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                                    decoration: BoxDecoration(
                                      color: hebenActive,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    ),
                                    child: Text(Faker().lorem.word(),
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                                  decoration: BoxDecoration(
                                    color: hebenActive,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
                                  child: Text(Faker().lorem.word(),
                                      style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Row(children: [
                              Icon(
                                EvaIcons.eyeOutline,
                                color: Colors.grey[400],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 3.0),
                                child: Text(
                                    '${Faker().randomGenerator.integer(10000)}',
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: Colors.black)),
                              ),
                            ]),
                          ),
                        ]),
                  ),
                )
              ]),
            ),
          ),
          Divider(
            color: Colors.grey[200],
            height: 2,
          ),
        ],
      ),
    );
  }
}
