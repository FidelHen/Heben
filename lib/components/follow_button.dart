import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/screens/root/profile/settings/settings.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/navigation.dart';

class FollowButton extends StatefulWidget {
  FollowButton(
      {@required this.role,
      @required this.isRegistering,
      @required this.unfollow,
      @required this.isFollowing,
      @required this.follow});

  final UserRole role;
  final bool isRegistering;
  final Function unfollow;
  final Function follow;
  final bool isFollowing;

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  String buttonText;
  bool isFollowing;

  @override
  void initState() {
    isFollowing = widget.isFollowing ?? false;
    if (widget.role == UserRole.user) {
      buttonText = 'Settings';
    } else {
      if (isFollowing) {
        buttonText = 'Following';
      } else {
        buttonText = 'Follow';
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: GFButton(
        onPressed: widget.isRegistering
            ? () {}
            : () {
                if (widget.role == UserRole.user) {
                  Navigation().segue(
                      page: Settings(), context: context, fullScreen: true);
                } else {
                  if (!isFollowing) {
                    setState(() {
                      widget.follow();
                      buttonText = 'Following';
                      isFollowing = !isFollowing;
                    });
                  } else {
                    setState(() {
                      widget.unfollow();
                      buttonText = 'Follow';
                      isFollowing = !isFollowing;
                    });
                  }
                }
              },
        color: widget.role == UserRole.user
            ? Colors.white
            : isFollowing ? Colors.white : hebenRed,
        child: Text(
          buttonText ?? 'Follow',
          style: GoogleFonts.lato(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: widget.role == UserRole.user
                ? hebenRed
                : isFollowing ? hebenRed : Colors.white,
          ),
        ),
        borderSide: BorderSide(color: hebenRed, width: 1.5),
        shape: GFButtonShape.pills,
        size: GFSize.SMALL,
      ),
    );
  }
}
