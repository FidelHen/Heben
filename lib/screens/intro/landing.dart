import 'package:auto_size_text/auto_size_text.dart';
import 'package:demoji/demoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/screens/intro/log_in.dart';
import 'package:heben/screens/intro/sign_up.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/navigation.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              right: DeviceSize().getWidth(context) / 10,
              left: DeviceSize().getWidth(context) / 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    height: 50, child: Image.asset('images/heben_logo.png')),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: DeviceSize().getHeight(context) / 20),
                      child: AutoSizeText.rich(
                        TextSpan(
                            text: 'Welcome to',
                            style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.w600),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' Heben',
                                style: GoogleFonts.lato(
                                    color: hebenRed,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800),
                              )
                            ]),
                      ),
                    ),
                    Text(
                      'I am going to get...',
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: DeviceSize().getHeight(context) / 25),
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: <Widget>[
                          goalCards(
                              emoji: Demoji.muscle,
                              title: 'Strong',
                              goal: UserGoal.strong,
                              width: DeviceSize().getWidth(context),
                              context: context),
                          goalCards(
                              emoji: Demoji.leafy_greens,
                              title: 'Healthy',
                              goal: UserGoal.strong,
                              width: DeviceSize().getWidth(context),
                              context: context),
                          goalCards(
                              emoji: Demoji.fire,
                              title: 'Lean',
                              goal: UserGoal.strong,
                              width: DeviceSize().getWidth(context),
                              context: context),
                          goalCards(
                              emoji: Demoji.trophy,
                              title: 'Motivated',
                              goal: UserGoal.strong,
                              width: DeviceSize().getWidth(context),
                              context: context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: FlatButton(
                  onPressed: () {
                    Navigation().segue(
                        page: LogIn(), context: context, fullScreen: true);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(11.0),
                  ),
                  child: Text(
                    'Already have an account?',
                    style: GoogleFonts.openSans(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget goalCards(
      {@required String emoji,
      @required String title,
      @required UserGoal goal,
      @required width,
      @required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: RaisedButton(
        onPressed: () {
          Navigation()
              .segue(page: SignUp(), context: context, fullScreen: false);
        },
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(11.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              emoji,
              style: TextStyle(fontSize: width * 0.1),
            ),
            Text(
              title,
              style: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
