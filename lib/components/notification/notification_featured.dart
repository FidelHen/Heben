import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/screens/root/post.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/navigation.dart';

class NotificationFeatured extends StatelessWidget {
  NotificationFeatured({
    @required this.timestamp,
  });

  final String timestamp;

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
                  Padding(
                    padding: EdgeInsets.only(right: 4.0),
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        'images/heben_logo.png',
                        fit: BoxFit.fitHeight,
                      ),
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
                                    text: 'Check it out you\'re ',
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700])),
                                TextSpan(
                                    text: 'Featured',
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w800,
                                        color: hebenActive)),
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
