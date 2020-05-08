import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/screens/root/friend.dart';
import 'package:heben/utils/navigation.dart';

class NotificationFollow extends StatelessWidget {
  NotificationFollow({
    @required this.username,
    @required this.profileImage,
    @required this.timestamp,
  });

  final String username;
  final String profileImage;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigation().segue(
            page: Friend(
              uid: null,
              username: username,
            ),
            context: context,
            fullScreen: false);
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            Container(
              constraints: const BoxConstraints(minHeight: 50),
              padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
              margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GFAvatar(
                    size: 25,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(profileImage),
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
                                    text: '@' + username,
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black)),
                                TextSpan(
                                    text: ' follows you',
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700])),
                              ]))
                        ],
                      ),
                    ),
                  ),
                  Text(
                    timestamp,
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
}
