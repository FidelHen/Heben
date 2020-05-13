import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/modals.dart';
import 'package:heben/utils/annotator/social_keyboard.dart';
import 'package:heben/utils/service.dart';
import 'package:heben/utils/social.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:heben/components/toast.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/gallery/photo.dart';
import 'package:heben/utils/gallery/src/delegate/badge_delegate.dart';
import 'package:heben/utils/gallery/src/delegate/sort_delegate.dart';
import 'package:heben/utils/gallery/src/entity/options.dart';
import 'package:heben/utils/gallery/src/provider/i18n_provider.dart';
import 'package:heben/utils/user.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class AcceptChallenge extends StatefulWidget {
  AcceptChallenge({@required this.challengeTitle, @required this.challengeUid});
  final String challengeTitle;
  final String challengeUid;
  @override
  _AcceptChallengeState createState() => _AcceptChallengeState();
}

class _AcceptChallengeState extends State<AcceptChallenge> {
  TextEditingController titleController;
  TextEditingController descriptionController;
  File currentSelected;
  VideoPlayerController videoController;
  List<Widget> challengeList = <Widget>[];
  FocusNode mainNode;
  List<Map<String, String>> challengedUsers = [];
  DocumentSnapshot snapshot;
  PostContentType mediaType;

  @override
  void initState() {
    titleController = TextEditingController();
    titleController.text = widget.challengeTitle ?? '';
    descriptionController = TextEditingController();
    mainNode = FocusNode();
    loadData();

    challengeList = [
      Padding(
        padding: EdgeInsets.all(8),
        child: GFAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            color: Colors.white,
            icon: Icon(
              EvaIcons.personAddOutline,
              color: Colors.black,
            ),
            onPressed: () {
              Modal().challengeFriendsModal(
                  context, snapshot.data['uid'], addUsersToChallenge);
            },
          ),
        ),
      ),
    ];

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    mainNode.dispose();
    if (videoController != null) {
      videoController.dispose();
    }
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
      backgroundColor: Colors.grey[100],
      appBar: GFAppBar(
        title: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: snapshot != null
              ? CachedNetworkImageProvider(snapshot.data['profileImage'] ?? '')
              : NetworkImage(''),
        ),
        centerTitle: true,
        elevation: 0,
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
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8, right: 18, left: 18),
              child: TextField(
                enabled: false,
                controller: titleController,
                maxLines: 1,
                style:
                    GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w500),
                keyboardAppearance: Brightness.light,
                decoration: InputDecoration.collapsed(
                  hintText: 'Challenge title',
                  hintStyle: GoogleFonts.lato(fontSize: 15),
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
                              child: Stack(
                                children: <Widget>[
                                  descriptionController.text.length == 0
                                      ? TextField(
                                          maxLines: 10,
                                          maxLength: 200,
                                          readOnly: true,
                                          controller: descriptionController,
                                          textInputAction: TextInputAction.done,
                                          style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.transparent),
                                          keyboardAppearance: Brightness.light,
                                          decoration: InputDecoration.collapsed(
                                            hintText:
                                                'What do you want to share?',
                                          ),
                                        )
                                      : Container(
                                          color: Colors.transparent,
                                        ),
                                  SocialKeyboard(
                                    controller: descriptionController,
                                    cursorColor: Theme.of(context).cursorColor,
                                    maxLines: 10,
                                    basicStyle: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    focusNode: mainNode,
                                    decoratedStyle: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: hebenRed,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
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
                                  mainNode.unfocus();
                                  Modal().mediaOptions(
                                      context, _pickAsset, getPicture);
                                },
                                child: currentSelected != null
                                    ? mediaType == PostContentType.image
                                        ? GFImageOverlay(
                                            colorFilter: null,
                                            boxFit: BoxFit.cover,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            image: FileImage(currentSelected),
                                            color: Colors.grey,
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: Container(
                                              color: Colors.grey,
                                              child: SizedBox.expand(
                                                child: FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: SizedBox(
                                                    width: videoController.value
                                                            .size?.width ??
                                                        0,
                                                    height: videoController
                                                            .value
                                                            .size
                                                            ?.height ??
                                                        0,
                                                    child: VideoPlayer(
                                                        videoController),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              EvaIcons.image,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ],
                                        ),
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
            child: Column(
              children: <Widget>[
                Text(
                  'Challenge friends',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Container(
                  height: 65,
                  child: GridView.builder(
                    itemCount: challengeList.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              challengeList.removeAt(index);
                              challengedUsers.removeAt(index - 1);
                            });
                          },
                          child: challengeList[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            if (currentSelected != null) {
              uploadData();
              Navigator.pop(context);
            } else {
              showOverlayNotification((context) {
                return WarningToast(
                    message: 'Please make sure you have some type of media');
              });
            }
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

  addUsersToChallenge(String username, String profileImage) {
    bool alreadyExist = false;
    challengedUsers.forEach((user) {
      if (user['username'] == username) {
        alreadyExist = true;
      }
    });

    if (!alreadyExist) {
      challengedUsers.add({'username': username, 'profileImage': profileImage});
      challengeList.add(Padding(
        padding: EdgeInsets.only(right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(profileImage),
            )
          ],
        ),
      ));
    }
  }

  void getPicture() async {
    Navigator.pop(context);
    File currentImage = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 400, maxWidth: 400);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: currentImage.path,
        cropStyle: CropStyle.rectangle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
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
        mediaType = PostContentType.image;
        currentSelected = result;
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
      pickType: PickType.all,
    );

    if (imgList == null || imgList.isEmpty) {
      return;
    } else {
      for (var e in imgList) {
        var file = await e.file;

        if (e.type == AssetType.image) {
          File croppedFile = await ImageCropper.cropImage(
              sourcePath: file.path,
              cropStyle: CropStyle.rectangle,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
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
              mediaType = PostContentType.image;
              currentSelected = result;
            });
          });
        } else if (e.type == AssetType.video) {
          if (e.videoDuration.inSeconds <= 60) {
            e.file.then((result) {
              currentSelected = result;
            });
            String url = await e.getMediaUrl();

            mediaType = PostContentType.video;
            initVideo(url);
          } else {
            showOverlayNotification((context) {
              return WarningToast(
                  message: 'Video cannot be longer than 2 minutes');
            });
          }
        }
      }
    }
  }

  initVideo(String url) {
    videoController = null;
    videoController = VideoPlayerController.network(
      url,
    )..initialize().then((_) {
        playVideo();
      });
  }

  playVideo() {
    if (videoController.value.initialized) {
      videoController
        ..setVolume(0)
        ..setLooping(true)
        ..play().then((_) {
          setState(() {});
        });
    }
  }

  Future<File> compressAndGetImage(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
    );
    return result;
  }

  uploadData() async {
    final DocumentReference docRef =
        Firestore.instance.collection('posts').document();
    final batch = Firestore.instance.batch();
    String mediaUrl;
    Map<String, dynamic> participantData;
    List<String> atList = [];
    List<String> tagList = [];

    descriptionController.text.trim().split(' ').forEach((str) {
      if (str.contains('@', 0)) {
        atList.add(str.substring(1));
      } else if (str.contains('#', 0)) {
        tagList.add(str);
      }
    });

    Social().tagUsers(
      atUsers: atList.toSet().toList(),
    );
    Social().hashtags(
        tagList: tagList.toSet().toList(), postUid: docRef.documentID);

    showOverlayNotification((context) {
      return LoadingToast(message: 'Uploading...');
    });

    StorageReference mediaRef = FirebaseStorage.instance
        .ref()
        .child('posts/${docRef.documentID}/media');

    await mediaRef.putFile(currentSelected).onComplete.then((result) async {
      await result.ref.getDownloadURL().then((url) {
        print(url);
        mediaUrl = url;
      });
    });

    if (snapshot == null) {
      snapshot = await User().getUserProfileInfo();
    }

    participantData = {
      'challengeTitle': widget.challengeTitle,
      'challengeUid': widget.challengeUid,
      'body': descriptionController.text.trim(),
      'profileImage': snapshot.data['profileImage'],
      'username': snapshot.data['username'],
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'postUid': docRef.documentID,
      'popularity': CurrentPostPopularity.normal.toString(),
      'score': 1400,
      'userUid': snapshot.data['uid'],
      'type': mediaType.toString(),
      'likes': 0,
      'comments': 0,
      'liked': {},
      'bookmarked': {},
      'challenged': challengedUsers
    };

    if (mediaType == PostContentType.video) {
      participantData.addAll({'video': mediaUrl});
    } else if (mediaType == PostContentType.image) {
      participantData.addAll({'image': mediaUrl});
    }

    challengedUsers.forEach((user) {
      if (user['username'] != snapshot.data['username']) {
        batch.setData(
            Firestore.instance.collection('notifications').document(), {
          'receiverUsername': user['username'],
          'senderUid': snapshot.data['uid'],
          'senderUsername': snapshot.data['username'],
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'type': 'challenged'
        });
      }
    });

    batch.setData(docRef, participantData);
    batch.setData(
        Firestore.instance
            .collection('posts')
            .document(widget.challengeUid)
            .collection('participants')
            .document(docRef.documentID),
        participantData);

    batch.commit().then((_) {
      showOverlayNotification((context) {
        return SuccessToast(message: 'Your post is finished uploading!');
      });
    });
  }

  loadData() async {
    snapshot = await User().getUserProfileInfo();
    setState(() {});
  }
}
