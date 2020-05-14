import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/follow_button.dart';
import 'package:heben/screens/root/profile/followers.dart';
import 'package:heben/screens/root/profile/following.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/navigation.dart';
import 'package:heben/utils/social.dart';

class UserHeading extends StatefulWidget {
  UserHeading(
      {@required this.name,
      @required this.bio,
      @required this.userUid,
      @required this.profileImage,
      @required this.backgroundImage,
      @required this.followers,
      @required this.following,
      @required this.role,
      @required this.isLive,
      @required this.isFollowing,
      @required this.username,
      this.backgroundImageFile,
      this.profileImageFile,
      this.isRegistering});

  final String name;
  final String bio;
  final String profileImage;
  final String backgroundImage;
  final String username;
  final File backgroundImageFile;
  final File profileImageFile;
  final int followers;
  final int following;
  final bool isFollowing;
  final UserRole role;
  final bool isLive;
  final String userUid;
  final bool isRegistering;

  @override
  _UserHeadingState createState() => _UserHeadingState();
}

class _UserHeadingState extends State<UserHeading> {
  TextStyle profileStatsStyle = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  bool isRegistering;
  int following;
  int followers;

  @override
  void initState() {
    if (widget.isRegistering == null || !widget.isRegistering) {
      isRegistering = false;
    } else {
      isRegistering = true;
    }

    following = widget.following;
    followers = widget.followers;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double safeArea = width * 0.1;
    return Container(
      color: Colors.transparent,
      child: Column(children: [
        Stack(
          children: <Widget>[
            Container(
              height: height * 0.2,
              width: width,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  child: Container()),
            ),
            GFImageOverlay(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                height: height * 0.2,
                width: width,
                image: widget.backgroundImageFile != null
                    ? FileImage(widget.backgroundImageFile)
                    : widget.role != UserRole.user
                        ? NetworkImage(widget.backgroundImage)
                        : CachedNetworkImageProvider(widget.backgroundImage),
                boxFit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.only(top: height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.03),
                    child: GestureDetector(
                      onTap: isRegistering
                          ? () {}
                          : () {
                              Navigation().segue(
                                  page: Followers(
                                    uid: widget.userUid,
                                  ),
                                  context: context,
                                  fullScreen: false);
                            },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$followers',
                            style: profileStatsStyle,
                          ),
                          Text(
                            'Followers',
                            style: profileStatsStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.03),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: GFAvatar(
                          size: GFSize.LARGE,
                          child: widget.isLive
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: GFBadge(
                                    shape: GFBadgeShape.circle,
                                    color: GFColors.PRIMARY,
                                  ),
                                )
                              : Container(),
                          backgroundImage: widget.profileImageFile != null
                              ? FileImage(widget.profileImageFile)
                              : widget.role != UserRole.user
                                  ? NetworkImage(widget.profileImage)
                                  : CachedNetworkImageProvider(
                                      widget.profileImage),
                          backgroundColor: Colors.grey,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.03),
                    child: GestureDetector(
                      onTap: isRegistering
                          ? () {}
                          : () {
                              Navigation().segue(
                                  page: Following(
                                    uid: widget.userUid,
                                  ),
                                  context: context,
                                  fullScreen: false);
                            },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$following',
                            style: profileStatsStyle,
                          ),
                          Text(
                            'Following',
                            style: profileStatsStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              bottom: -11,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: height * 0.04,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Container(
              height: 55,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: safeArea, right: safeArea),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Text(
                          widget.name ?? '',
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    FollowButton(
                        role: widget.role,
                        isRegistering: isRegistering,
                        unfollow: unfollow,
                        follow: follow,
                        isFollowing: widget.isFollowing ?? false)
                  ],
                ),
              ),
            ),
          ),
        ),
        widget.bio.length != 0
            ? Container(
                color: Colors.white,
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(left: safeArea, right: safeArea),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.bio,
                        style: GoogleFonts.openSans(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ]),
    );
  }

  follow() {
    Social().followUser(userUid: widget.userUid, username: widget.username);
    setState(() {
      followers += 1;
    });
  }

  unfollow() {
    Social().unfollowUser(userUid: widget.userUid);
    setState(() {
      followers -= 1;
    });
  }
}

class PreviewUserHeading extends StatefulWidget {
  PreviewUserHeading({
    @required this.name,
    @required this.bio,
    @required this.profileImage,
    @required this.backgroundImage,
    @required this.followers,
    @required this.following,
    @required this.role,
    @required this.isLive,
  });

  final String name;
  final String bio;
  final File profileImage;
  final File backgroundImage;
  final int followers;
  final int following;
  final UserRole role;
  final bool isLive;

  @override
  _PreviewUserHeadingState createState() => _PreviewUserHeadingState();
}

class _PreviewUserHeadingState extends State<PreviewUserHeading> {
  TextStyle profileStatsStyle = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double safeArea = width * 0.1;
    return Container(
      color: Colors.transparent,
      child: Column(children: [
        Stack(
          children: <Widget>[
            Container(
              height: height * 0.2,
              width: width,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  child: Container()),
            ),
            GFImageOverlay(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                height: height * 0.2,
                width: width,
                image: widget.backgroundImage != null
                    ? FileImage(widget.backgroundImage)
                    : NetworkImage(''),
                boxFit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.only(top: height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.03),
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${widget.followers}',
                            style: profileStatsStyle,
                          ),
                          Text(
                            'Followers',
                            style: profileStatsStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.03),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: GFAvatar(
                          size: GFSize.LARGE,
                          child: widget.isLive
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: GFBadge(
                                    shape: GFBadgeShape.circle,
                                    color: GFColors.PRIMARY,
                                  ),
                                )
                              : Container(),
                          backgroundImage: widget.profileImage != null
                              ? FileImage(widget.profileImage)
                              : NetworkImage(''),
                          backgroundColor: Colors.grey[300],
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.03),
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${widget.following}',
                            style: profileStatsStyle,
                          ),
                          Text(
                            'Following',
                            style: profileStatsStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              bottom: -11,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: height * 0.04,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Container(
              height: 55,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: safeArea, right: safeArea),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Text(
                          widget.name,
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    FollowButton(
                      role: widget.role,
                      isRegistering: true,
                      unfollow: () {},
                      follow: () {},
                      isFollowing: false,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: safeArea, right: safeArea),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.bio,
                  style: GoogleFonts.openSans(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
