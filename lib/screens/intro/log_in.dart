import 'package:email_validator/email_validator.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/screens/intro/forgot_password.dart';
import 'package:heben/utils/auth.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/navigation.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController;
  TextEditingController passwordController;

  bool isLoading;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      opacity: 0.5,
      color: Colors.black,
      progressIndicator: Container(
        height: 50,
        child: SpinKitThreeBounce(
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Scaffold(
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
                          controller: emailController,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          keyboardAppearance: Brightness.light,
                          style: GoogleFonts.openSans(
                              fontSize: 18, fontWeight: FontWeight.w600),
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
                            controller: passwordController,
                            keyboardAppearance: Brightness.light,
                            style: GoogleFonts.openSans(
                                fontSize: 18, fontWeight: FontWeight.w600),
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
                      validator();
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
      ),
    );
  }

  validator() {
    bool validated = EmailValidator.validate(emailController.text);
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });
    if (validated) {
      if (passwordController.text.trim().length >= 6) {
        Auth().logIn(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            context: context);
      } else {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return PlatformAlertDialog(
              title: Text('Error'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Please enter a valid password'),
                  ],
                ),
              ),
              actions: <Widget>[
                PlatformDialogAction(
                  child: Text('Okay'),
                  actionType: ActionType.Default,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return PlatformAlertDialog(
            title: Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Please enter a valid email'),
                ],
              ),
            ),
            actions: <Widget>[
              PlatformDialogAction(
                child: Text('Okay'),
                actionType: ActionType.Default,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    setState(() {
      isLoading = false;
    });
  }
}
