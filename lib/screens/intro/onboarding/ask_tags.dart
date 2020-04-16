import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/registration_title.dart';
import 'package:heben/screens/root/root.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/navigation.dart';

class AskTags extends StatefulWidget {
  @override
  _AskTagsState createState() => _AskTagsState();
}

class _AskTagsState extends State<AskTags> {
  List<String> _tags = [
    '#Bodybuilding',
    '#Yoga',
    '#Vegan',
    '#Cardio',
    '#FitnessMotivation',
    '#FitGoals',
    '#Marathon',
    '#WeightLoss',
    '#FitFam',
    '#TransformationTuesday',
    '#HomeWorkout'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GFAppBar(
        elevation: 0,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RegistrationTitle(
              title: 'Choose 3 or more tags',
              subtitle: 'Help us recommend you the good stuff.',
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 12.0, left: 12.0),
                    child: Tags(
                      columns: 5,
                      horizontalScroll: false,
                      itemCount: _tags.length,
                      itemBuilder: (index) {
                        return ItemTags(
                          key: Key(index.toString()),
                          active: false,
                          index: index,
                          title: _tags[index],
                          textStyle: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          pressEnabled: true,
                          activeColor: hebenActive,
                          border: Border.all(color: Colors.transparent),
                        );
                      },
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
                        'Done',
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
    );
  }
}
