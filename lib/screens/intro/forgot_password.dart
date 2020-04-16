import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GFAppBar(
        elevation: 0,
        title: Text(
          'Forgot password',
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
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          width: DeviceSize().getWidth(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    right: DeviceSize().getWidth(context) / 8,
                    left: DeviceSize().getWidth(context) / 8),
                child: Column(
                  children: <Widget>[
                    TextField(
                        autofocus: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        keyboardAppearance: Brightness.light,
                        style: GoogleFonts.openSans(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: hebenActive, width: 2),
                          ),
                          hintText: 'Email',
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: DeviceSize().getWidth(context) / 15,
                    left: DeviceSize().getWidth(context) / 15,
                    bottom: 15),
                child: RaisedButton(
                  color: hebenRed,
                  onPressed: () {},
                  child: Container(
                      width: DeviceSize().getWidth(context) / 1.4,
                      height: 50,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Reset',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      )),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
