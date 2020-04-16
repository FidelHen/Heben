import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class ContentSteamComment extends StatelessWidget {
  ContentSteamComment({
    @required this.username,
    @required this.profileImage,
    @required this.postUid,
    @required this.creatorUid,
    @required this.body,
  });

  final String username;
  final String profileImage;
  final String body;
  final String postUid;
  final String creatorUid;

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
            child: GFAvatar(
              size: 25,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(profileImage),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
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
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Text(
                        body,
                        style: GoogleFonts.openSans(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
