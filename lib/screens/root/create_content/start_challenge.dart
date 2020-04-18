import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/modals.dart';
import 'package:heben/screens/root/root.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/navigation.dart';

class StartChallenge extends StatefulWidget {
  @override
  _StartChallengeState createState() => _StartChallengeState();
}

class _StartChallengeState extends State<StartChallenge> {
  int _radioValue;

  @override
  void initState() {
    _radioValue = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: GFAppBar(
        title: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(
              'https://images.pexels.com/photos/839011/pexels-photo-839011.jpeg?auto=compress&cs=tinysrgb&h=650&w=940'),
        ),
        centerTitle: true,
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
        backgroundColor: Colors.grey[100],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Challenge duration',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: 0,
                      activeColor: hebenActive,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text(
                      '1 Day',
                      style: TextStyle(
                          fontFamily: 'Open_Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    Radio(
                      value: 1,
                      activeColor: hebenActive,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    Text(
                      '1 Week',
                      style: TextStyle(
                          fontFamily: 'Open_Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    Radio(
                      value: 2,
                      activeColor: hebenActive,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    Text(
                      '1 Month',
                      style: TextStyle(
                          fontFamily: 'Open_Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8, right: 18, left: 18),
              child: TextField(
                autofocus: true,
                maxLines: 1,
                style:
                    GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500),
                keyboardAppearance: Brightness.light,
                decoration: InputDecoration.collapsed(
                  hintText: 'Challenge title',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Container(
              height: DeviceSize().getHeight(context) / 7,
              width: DeviceSize().getWidth(context),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                maxLines: 10,
                                maxLength: 200,
                                style: GoogleFonts.lato(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                                keyboardAppearance: Brightness.light,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'What do you want to share?',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: DeviceSize().getHeight(context) / 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  // _pickAsset(PickType.all);
                                },
                                child: GFImageOverlay(
                                  colorFilter: null,
                                  boxFit: BoxFit.cover,
                                  borderRadius: BorderRadius.circular(4),
                                  image: NetworkImage(
                                    'https://images.pexels.com/photos/3994840/pexels-photo-3994840.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                                  ),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              height: 80,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: GFAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          Modal().challengeFriendsModal(context);
                        },
                        icon: Icon(
                          EvaIcons.personAdd,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        GFAvatar(
                          backgroundImage: NetworkImage(
                              'https://images.pexels.com/photos/789812/pexels-photo-789812.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
                        ),
                        Positioned(
                          left: 35,
                          child: GFAvatar(
                            backgroundImage: NetworkImage(
                                'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
                          ),
                        ),
                        Positioned(
                          left: 70,
                          child: GFAvatar(
                            backgroundImage: NetworkImage(
                                'https://images.pexels.com/photos/1300402/pexels-photo-1300402.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigation()
                .segueToRoot(page: Root(), context: context, fullScreen: true);
          },
          label: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: Text(
                  'Challenge',
                  style: GoogleFonts.lato(
                      fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              Icon(
                EvaIcons.checkmark,
                size: 20,
              )
            ],
          ),
          backgroundColor: hebenActive,
        ),
      ),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }
}
