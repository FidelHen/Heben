import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/registration_title.dart';
import 'package:heben/components/toast.dart';
import 'package:heben/screens/root/root.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/navigation.dart';
import 'package:heben/utils/user.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:overlay_support/overlay_support.dart';

class AskTags extends StatefulWidget {
  AskTags(
      {@required this.name,
      @required this.bio,
      @required this.profileImage,
      @required this.backgroundImage});
  final String name;
  final String bio;
  final File profileImage;
  final File backgroundImage;

  @override
  _AskTagsState createState() => _AskTagsState();
}

class _AskTagsState extends State<AskTags> {
  bool isLoading;
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

  List<String> tagTitles = [];

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      opacity: 0.5,
      color: Colors.black,
      progressIndicator: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 40,
              child: Text('Creating your account',
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  )),
            ),
            Container(
              height: 50,
              child: Center(
                child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
      child: Scaffold(
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
                            onPressed: (tag) {
                              if (tag.active) {
                                tagTitles.add(tag.title);
                              } else {
                                tagTitles.remove(tag.title);
                              }
                            },
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
                    uploadData();
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
      ),
    );
  }

  uploadData() async {
    print(tagTitles);

    String profileImageURL;
    String backgroundImageURL;

    setState(() {
      isLoading = true;
    });
    if (tagTitles.length >= 3) {
      String uid = await User().getUid();
      if (widget.profileImage != null) {
        StorageReference profileImageRef =
            FirebaseStorage.instance.ref().child('users/$uid/profileImage');

        await profileImageRef
            .putFile(widget.profileImage)
            .onComplete
            .then((image) async {
          await image.ref.getDownloadURL().then((url) {
            profileImageURL = url;
          });
        });
      }

      if (widget.backgroundImage != null) {
        StorageReference backgroundImageRef =
            FirebaseStorage.instance.ref().child('users/$uid/backgroundImage');
        await backgroundImageRef
            .putFile(widget.backgroundImage)
            .onComplete
            .then((image) async {
          await image.ref.getDownloadURL().then((url) {
            backgroundImageURL = url;
          });
        });
      }

      final batch = Firestore.instance.batch();

      tagTitles.forEach((tag) {
        batch.setData(
            Firestore.instance
                .collection('users')
                .document(uid)
                .collection('tagsInterestedIn')
                .document(tag.toLowerCase().trim()),
            {
              'tag': tag.toLowerCase().trim(),
              'addedOn': DateTime.now().millisecondsSinceEpoch,
            });
      });

      batch.setData(
          Firestore.instance.collection('users').document(uid),
          {
            'backgroundImage': backgroundImageURL ?? '',
            'profileImage': profileImageURL ?? '',
            'name': widget.name ?? '',
            'bio': widget.bio ?? '',
            'isRegistered': true,
            'followers': 0,
            'following': 0,
            'score': 0
          },
          merge: true);

      batch.setData(
          Firestore.instance
              .collection('followers')
              .document(uid)
              .collection('users')
              .document(uid),
          {'uid': uid});

      batch.setData(
          Firestore.instance
              .collection('following')
              .document(uid)
              .collection('users')
              .document(uid),
          {'uid': uid});

      batch.commit().then((_) {
        setState(() {
          isLoading = false;
        });

        Navigation()
            .segueToRoot(page: Root(), context: context, fullScreen: true);
      });
    } else {
      showOverlayNotification((context) {
        return WarningToast(message: 'Please select 3 or more tags');
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
