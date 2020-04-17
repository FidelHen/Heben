import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/modals.dart';
import 'package:heben/components/registration_title.dart';
import 'package:heben/components/user_heading.dart';
import 'package:heben/screens/intro/onboarding/ask_tags.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/gallery/photo.dart';
import 'package:heben/utils/gallery/src/delegate/badge_delegate.dart';
import 'package:heben/utils/gallery/src/delegate/sort_delegate.dart';
import 'package:heben/utils/gallery/src/entity/options.dart';
import 'package:heben/utils/gallery/src/provider/i18n_provider.dart';
import 'package:heben/utils/navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class AskInfo extends StatefulWidget {
  @override
  _AskInfoState createState() => _AskInfoState();
}

class _AskInfoState extends State<AskInfo> {
  String currentSelected = "";
  TextEditingController nameController;
  TextEditingController bioController;

  String nameText = 'Name';
  String bioText = 'Bio';

  ImageOption mediaType;

  File profileImage;
  File backgroundImage;

  @override
  void initState() {
    nameController = TextEditingController();
    bioController = TextEditingController();

    nameController.addListener(() {
      nameText = nameController.text.trim().length == 0
          ? 'Name'
          : nameController.text.trim();
    });

    bioController.addListener(() {
      bioText = bioController.text.trim().length == 0
          ? 'Bio'
          : bioController.text.trim();
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RegistrationTitle(
                title: 'Set your profile up!',
                subtitle: 'Hey don\'t sweat it you can change it later on.'),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  PreviewUserHeading(
                    name: nameText,
                    bio: bioText,
                    profileImage: profileImage,
                    backgroundImage: backgroundImage,
                    followers: 0,
                    following: 0,
                    role: UserRole.friend,
                    isLive: false,
                  ),
                  Column(children: [
                    todoTab(
                        title: 'Add your name',
                        onPressed: () {
                          Modal().nameModal(context, nameController);
                        }),
                    todoTab(
                        title: 'Add your bio',
                        onPressed: () {
                          Modal().bioModal(context, bioController);
                        }),
                    todoTab(
                        title: 'Upload profile picture',
                        onPressed: () {
                          mediaType = ImageOption.profile;
                          Modal().mediaOptions(context, _pickAsset, getPicture);
                        }),
                    todoTab(
                        title: 'Upload background picture',
                        onPressed: () {
                          mediaType = ImageOption.background;
                          Modal().mediaOptions(context, _pickAsset, getPicture);
                        }),
                  ]),
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
                        'Next',
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

  Widget todoTab({@required String title, @required Function onPressed}) {
    return FlatButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(11.0),
      ),
      child: Text(
        title,
        style: GoogleFonts.openSans(
            fontSize: 15, fontWeight: FontWeight.w600, color: hebenActive),
      ),
    );
  }

  void getPicture() async {
    Navigator.pop(context);
    File currentImage = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 400, maxWidth: 400);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: currentImage.path,
        cropStyle: mediaType == ImageOption.profile
            ? CropStyle.circle
            : CropStyle.rectangle,
        aspectRatioPresets: mediaType == ImageOption.profile
            ? [
                CropAspectRatioPreset.square,
              ]
            : [CropAspectRatioPreset.ratio5x3],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 0.5,
        ));

    final dir = await path_provider.getTemporaryDirectory();
    final targetPath =
        dir.absolute.path + "/${Faker().randomGenerator.string(50)}.jpg";

    compressAndGetImage(croppedFile, targetPath).then((result) {
      setState(() {
        if (mediaType == ImageOption.profile) {
          profileImage = result;
        } else if (mediaType == ImageOption.background) {
          backgroundImage = result;
        }
      });
    });
  }

  void _pickAsset() async {
    Navigator.pop(context);
    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      context: context,
      dividerColor: Colors.grey,
      disableColor: Colors.grey.shade300,
      itemRadio: 0.88,
      provider: I18nProvider.english,
      rowCount: 3,
      thumbSize: 150,
      sortDelegate: SortDelegate.common,
      badgeDelegate: const DurationBadgeDelegate(),
      pickType: PickType.onlyImage,
    );

    if (imgList == null || imgList.isEmpty) {
      return;
    } else {
      for (var e in imgList) {
        var file = await e.file;

        File croppedFile = await ImageCropper.cropImage(
            sourcePath: file.path,
            cropStyle: mediaType == ImageOption.profile
                ? CropStyle.circle
                : CropStyle.rectangle,
            aspectRatioPresets: mediaType == ImageOption.profile
                ? [
                    CropAspectRatioPreset.square,
                  ]
                : [CropAspectRatioPreset.ratio16x9],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: 'Crop',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 0.5,
            ));

        final dir = await path_provider.getTemporaryDirectory();
        final targetPath =
            dir.absolute.path + "/${Faker().randomGenerator.string(50)}.jpg";

        compressAndGetImage(croppedFile, targetPath).then((result) {
          setState(() {
            if (mediaType == ImageOption.profile) {
              profileImage = result;
            } else if (mediaType == ImageOption.background) {
              backgroundImage = result;
            }
          });
        });
      }
    }
  }

  Future<File> compressAndGetImage(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
    );
    return result;
  }

  validator() {
    if (nameText.trim() == 'Name') {
      nameText = '';
    }
    if (bioText.trim() == 'Bio') {
      bioText = '';
    }

    Navigation().segue(
        page: AskTags(
            name: nameText,
            bio: bioText,
            profileImage: profileImage,
            backgroundImage: backgroundImage),
        context: context,
        fullScreen: false);
  }
}
