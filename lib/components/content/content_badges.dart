import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/enums.dart';

class ContentBadges extends StatelessWidget {
  ContentBadges({@required this.popularity, @required this.isDark});
  final CurrentPostPopularity popularity;
  final bool isDark;

  final TextStyle badgeTitleTextStyle = GoogleFonts.lato(
    fontWeight: FontWeight.w600,
    fontSize: 13,
  );

  @override
  Widget build(BuildContext context) {
    final textStyle = isDark
        ? badgeTitleTextStyle.copyWith(color: Colors.white)
        : badgeTitleTextStyle;

    if (popularity == CurrentPostPopularity.featured) {
      return Padding(
        padding: EdgeInsets.fromLTRB(4, 2, 6, 2),
        child: Container(
          height: 25,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 2),
                child: Icon(
                  EvaIcons.star,
                  color: hebenStarColor,
                  size: 21,
                ),
              ),
              Text(
                'Featured',
                style: textStyle,
              ),
            ],
          ),
        ),
      );
    } else if (popularity == CurrentPostPopularity.trending) {
      return Padding(
        padding: EdgeInsets.fromLTRB(4, 2, 6, 2),
        child: Container(
          height: 25,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 2),
                child: Icon(
                  EvaIcons.trendingUp,
                  color: hebenTrendingColor,
                  size: 23,
                ),
              ),
              Text(
                'Trending',
                style: textStyle,
              ),
            ],
          ),
        ),
      );
    } else if (popularity == CurrentPostPopularity.pinned) {
      return Padding(
        padding: EdgeInsets.fromLTRB(4, 2, 6, 2),
        child: Container(
          height: 25,
          child: Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 5, left: 3),
                  child: isDark
                      ? Image.asset(
                          'images/heben_logo_white.png',
                          fit: BoxFit.fitHeight,
                          height: 17,
                        )
                      : Image.asset(
                          'images/heben_logo.png',
                          fit: BoxFit.fitHeight,
                          height: 17,
                        )),
              Text(
                'Pinned',
                style: textStyle,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
