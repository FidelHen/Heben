import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/screens/root/friend.dart';
import 'package:heben/screens/root/view_stream.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/navigation.dart';

class NotificationGoingLive extends StatelessWidget {
  NotificationGoingLive({
    @required this.username,
    @required this.profileImage,
    @required this.timestamp,
    @required this.firstIndex,
    @required this.streamUid,
  });

  final String username;
  final String profileImage;
  final String timestamp;
  final bool firstIndex;
  final String streamUid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigation()
            .segue(page: ViewStream(), context: context, fullScreen: true);
      },
      child: Container(
        decoration: firstIndex
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
                      backgroundImage: NetworkImage(profileImage),
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
                                    text: '@' + username,
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black)),
                                TextSpan(
                                    text: ' is',
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700])),
                                TextSpan(
                                    text: ' LIVE',
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w700,
                                        color: hebenRed)),
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
