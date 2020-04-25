import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/screens/root/friend.dart';
import 'package:heben/utils/navigation.dart';
import 'package:heben/utils/user.dart';

class ContentProfileTile extends StatefulWidget {
  ContentProfileTile({
    @required this.uid,
    @required this.username,
    @required this.profileImage,
    @required this.stopGesture,
    this.onTap,
  });
  final String uid;
  final String username;
  final String profileImage;
  final bool stopGesture;
  final Function onTap;
  @override
  _ContentProfileTileState createState() => _ContentProfileTileState();
}

class _ContentProfileTileState extends State<ContentProfileTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !widget.stopGesture ?? false
          ? () async {
              String myUid = await User().getUid();
              if (myUid != widget.uid) {
                Navigation().segue(
                    page: Friend(
                      uid: widget.uid,
                      username: widget.username,
                    ),
                    context: context,
                    fullScreen: false);
              }
            }
          : widget.onTap,
      child: Column(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(minHeight: 50),
            padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GFAvatar(
                  size: 25,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(widget.profileImage),
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
                              widget.username,
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey[200],
            height: 0.5,
          ),
        ],
      ),
    );
  }
}
