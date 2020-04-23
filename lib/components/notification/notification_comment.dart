import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/screens/root/friend.dart';
import 'package:heben/screens/root/post.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/navigation.dart';

class NotificationComment extends StatelessWidget {
  NotificationComment(
      {@required this.username,
      @required this.profileImage,
      @required this.timestamp,
      @required this.firstIndex,
      @required this.postUid,
      @required this.postType});

  final String username;
  final String profileImage;
  final String timestamp;
  final bool firstIndex;
  final String postUid;
  final String postType;

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
              image: 'https://source.unsplash.com/1600x900/?healthy',
              popularity: CurrentPostPopularity.trending,
              likes: 1,
              liked: false,
              comments: 10,
              postUid: Faker().randomGenerator.string(10),
              bookmarked: true,
              challengeUid: Faker().randomGenerator.string(10),
              challengeTitle: null,
              video: null,
            ),
            context: context,
            fullScreen: false);
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: '@' + username,
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black)),
                                TextSpan(
                                    text: ' commented on your post',
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700])),
                              ])),
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
