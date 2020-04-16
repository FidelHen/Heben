import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/screens/intro/landing.dart';
import 'package:heben/screens/root/profile/settings/change_bio.dart';
import 'package:heben/screens/root/profile/settings/change_images.dart';
import 'package:heben/screens/root/profile/settings/change_username.dart';
import 'package:heben/screens/root/profile/settings/contact_us.dart';
import 'package:heben/screens/root/profile/settings/terms_and_conditions.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/navigation.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: GFAppBar(
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.lato(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            icon: Icon(
              EvaIcons.chevronDown,
              size: 40,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        brightness: Brightness.light,
        backgroundColor: Colors.grey[100],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      settingsItem(
                          title: 'Change images',
                          onPressed: () {
                            Navigation().segue(
                                page: ChangeImages(),
                                context: context,
                                fullScreen: false);
                          }),
                      settingsItem(
                          title: 'Change username',
                          onPressed: () {
                            Navigation().segue(
                                page: ChangeUsername(),
                                context: context,
                                fullScreen: false);
                          }),
                      settingsItem(
                          title: 'Change bio',
                          onPressed: () {
                            Navigation().segue(
                                page: ChangeBio(),
                                context: context,
                                fullScreen: false);
                          }),
                      settingsItem(
                          title: 'Contact us',
                          onPressed: () {
                            Navigation().segue(
                                page: ContactUs(),
                                context: context,
                                fullScreen: false);
                          }),
                      settingsItem(
                          title: 'Privacy policy & terms',
                          onPressed: () {
                            Navigation().segue(
                                page: TermsAndConditions(),
                                context: context,
                                fullScreen: false);
                          }),
                    ],
                  ),
                  Center(
                    child: FlatButton(
                      onPressed: () {
                        Navigation().segueToRoot(
                            page: Landing(),
                            context: context,
                            fullScreen: true);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                      ),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.openSans(
                            color: hebenRed,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget settingsItem({@required String title, @required Function onPressed}) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
          height: 60,
          color: Colors.white,
          child: FlatButton(
            onPressed: onPressed,
            child: ListTile(
                title: Text(
                  title,
                  style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                ),
                trailing: Icon(
                  EvaIcons.chevronRight,
                  color: Colors.black,
                  size: 30,
                )),
          )),
    );
  }
}
