import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/screens/intro/forgot_password.dart';
import 'package:heben/screens/root/root.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/navigation.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GFAppBar(
        elevation: 0,
        title: Text(
          'Welcome back!',
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
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: TextField(
                          autocorrect: false,
                          keyboardAppearance: Brightness.light,
                          style: GoogleFonts.openSans(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          obscureText: true,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: hebenActive, width: 2),
                            ),
                            hintText: 'Password',
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: FlatButton(
                          onPressed: () {
                            Navigation().segue(
                                page: ForgotPassword(),
                                context: context,
                                fullScreen: false);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(11.0),
                          ),
                          child: Text(
                            'Forgot password?',
                            style: GoogleFonts.openSans(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
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
                  onPressed: () {
                    Navigation().segueToRoot(
                        page: Root(), context: context, fullScreen: true);
                  },
                  child: Container(
                      width: DeviceSize().getWidth(context) / 1.4,
                      height: 50,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Log in',
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
