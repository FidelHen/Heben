import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/utils/colors.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: GFAppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Contact us',
          style: GoogleFonts.lato(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
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
        backgroundColor: Colors.grey[100],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                autofocus: true,
                maxLines: 1,
                maxLength: 50,
                style:
                    GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w500),
                keyboardAppearance: Brightness.light,
                decoration: InputDecoration.collapsed(
                  hintText: 'Subject',
                  hintStyle: GoogleFonts.lato(fontSize: 15),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  maxLines: 10,
                  style: GoogleFonts.lato(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  keyboardAppearance: Brightness.light,
                  maxLength: 500,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Body',
                    hintStyle: GoogleFonts.lato(fontSize: 15),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigation()
          //     .segueToRoot(page: Root(), context: context, fullScreen: true);
        },
        label: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Text(
                'Send',
                style:
                    GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
            Icon(
              EvaIcons.paperPlaneOutline,
              size: 20,
            )
          ],
        ),
        backgroundColor: hebenActive,
      ),
    );
  }
}
