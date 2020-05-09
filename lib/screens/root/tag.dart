import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Tag extends StatefulWidget {
  Tag({@required this.tag});
  final String tag;
  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: GFAppBar(
        title: Text(
          '${widget.tag}',
          style: GoogleFonts.lato(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            icon: Icon(
              EvaIcons.chevronLeft,
              size: 40,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.grey[100],
      ),
    );
  }
}
