import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/modals.dart';
import 'package:heben/components/toast.dart';
import 'package:heben/components/user_heading.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/gallery/photo.dart';
import 'package:heben/utils/gallery/src/delegate/badge_delegate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:heben/utils/gallery/src/delegate/sort_delegate.dart';
import 'package:heben/utils/gallery/src/entity/options.dart';
import 'package:heben/utils/gallery/src/provider/i18n_provider.dart';
import 'package:heben/utils/user.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

class ChangeImages extends StatefulWidget {
  @override
  _ChangeImagesState createState() => _ChangeImagesState();
}

class _ChangeImagesState extends State<ChangeImages> {
  String currentSelected = "";
  File backgroundImage;
  File profileImage;
  ImageOption mediaType;
  bool isLoading;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: User().getUserProfileInfo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: GFAppBar(
              centerTitle: true,
              elevation: 0,
              title: Text(
                'Change images',
                style: GoogleFonts.lato(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
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
            body: Center(
              child: Container(
                height: 50,
                child: SpinKitThreeBounce(
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ),
          );
        } else {
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
                    child: Text('Uploading your new images',
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
              backgroundColor: Colors.grey[100],
              appBar: GFAppBar(
                centerTitle: true,
                elevation: 0,
                title: Text(
                  'Change images',
                  style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
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
              body: Column(children: <Widget>[
                UserHeading(
                  name: snapshot.data['name'],
                  bio: snapshot.data['bio'],
                  profileImage: snapshot.data['profileImage'],
                  backgroundImage: snapshot.data['backgroundImage'],
                  followers: snapshot.data['followers'],
                  following: snapshot.data['following'],
                  isLive: snapshot.data['isLive'] ?? false,
                  role: UserRole.friend,
                  backgroundImageFile: backgroundImage,
                  profileImageFile: profileImage,
                  isRegistering: true,
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    width: DeviceSize().getWidth(context),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          todoTab(
                              title: 'Change profile picture',
                              onPressed: () {
                                mediaType = ImageOption.profile;
                                Modal().mediaOptions(
                                    context, _pickAsset, getPicture);
                              }),
                          todoTab(
                              title: 'Change background picture',
                              onPressed: () {
                                mediaType = ImageOption.background;
                                Modal().mediaOptions(
                                    context, _pickAsset, getPicture);
                              }),
                        ]),
                  ),
                ),
              ]),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  if (backgroundImage != null || profileImage != null) {
                    uploadImages();
                  } else {
                    showOverlayNotification((context) {
                      return WarningToast(message: 'No new images selected');
                    });
                  }
                },
                label: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Text(
                        'Save',
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                    Icon(
                      EvaIcons.saveOutline,
                      size: 20,
                    )
                  ],
                ),
                backgroundColor: hebenActive,
              ),
            ),
          );
        }
      },
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
    final targetPath = dir.absolute.path + "/${Uuid().v4()}.jpg";

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
        final targetPath = dir.absolute.path + "/${Uuid().v4()}.jpg";

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

  uploadImages() async {
    String profileImageURL;
    String backgroundImageURL;

    setState(() {
      isLoading = true;
    });

    String uid = await User().getUid();

    if (profileImage != null) {
      StorageReference profileImageRef =
          FirebaseStorage.instance.ref().child('users/$uid/profileImage');

      await profileImageRef
          .putFile(profileImage)
          .onComplete
          .then((image) async {
        await image.ref.getDownloadURL().then((url) {
          profileImageURL = url;
        });
      });
    }

    if (backgroundImage != null) {
      StorageReference backgroundImageRef =
          FirebaseStorage.instance.ref().child('users/$uid/backgroundImage');
      await backgroundImageRef
          .putFile(backgroundImage)
          .onComplete
          .then((image) async {
        await image.ref.getDownloadURL().then((url) {
          backgroundImageURL = url;
        });
      });
    }

    if (backgroundImage != null || profileImage != null) {
      Map<String, dynamic> data;

      if (backgroundImage != null && profileImage != null) {
        data = {
          'profileImage': profileImageURL,
          'backgroundImage': backgroundImageURL
        };
      } else if (profileImage != null) {
        data = {
          'profileImage': profileImageURL,
        };
      } else if (backgroundImage != null) {
        data = {
          'backgroundImage': backgroundImageURL,
        };
      }
      Firestore.instance
          .collection('users')
          .document(uid)
          .setData(data, merge: true)
          .then((_) {
        setState(() {
          isLoading = false;
        });
        showOverlayNotification((context) {
          return SuccessToast(message: 'Successfully uploaded images');
        });
        Navigator.pop(context);
      });
    }
  }
}
