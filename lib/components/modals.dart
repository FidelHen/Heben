import 'package:algolia/algolia.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/content/content_profile_tile.dart';
import 'package:heben/models/profile_item.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/keys.dart';

class Modal {
  void friendsModal(BuildContext context, TextEditingController controller,
      TextEditingController mainController, String uid) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(18.0),
          topRight: const Radius.circular(18.0),
        )),
        builder: (builder) {
          return SafeArea(
            child: ClipRRect(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(18.0),
                      topRight: const Radius.circular(18.0),
                    )),
                height: DeviceSize().getHeight(context) / 1.2,
                child: Column(children: [
                  Container(
                    color: Colors.white,
                    height: DeviceSize().getHeight(context) / 1.2,
                    child: FriendsModalList(
                      uid: uid,
                      isChallenge: false,
                      controller: controller,
                      mainController: mainController,
                    ),
                  )
                ]),
                padding: EdgeInsets.all(25.0),
              ),
            ),
          );
        });
  }

  void challengeFriendsModal(BuildContext context, String uid) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(18.0),
          topRight: const Radius.circular(18.0),
        )),
        builder: (builder) {
          return SafeArea(
            child: ClipRRect(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(18.0),
                      topRight: const Radius.circular(18.0),
                    )),
                height: DeviceSize().getHeight(context) / 1.2,
                child: Column(children: [
                  Container(
                    color: Colors.white,
                    height: DeviceSize().getHeight(context) / 1.2,
                    child: FriendsModalList(
                      uid: uid,
                      isChallenge: false,
                      controller: null,
                      mainController: null,
                    ),
                  )
                ]),
                padding: EdgeInsets.all(25.0),
              ),
            ),
          );
        });
  }

  void hashtagModal(BuildContext context, TextEditingController controller,
      TextEditingController mainController) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(18.0),
          topRight: const Radius.circular(18.0),
        )),
        builder: (builder) {
          return SafeArea(
            child: ClipRRect(
              child: Container(
                height: DeviceSize().getHeight(context) / 1.2,
                child: Column(children: [
                  Flexible(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: DeviceSize().getWidth(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200],
                      ),
                      child: TextField(
                        autofocus: true,
                        controller: controller,
                        keyboardAppearance: Brightness.light,
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        onSubmitted: (text) {
                          mainController.text += '#' + text + ' ';
                          controller.clear();
                          Navigator.pop(context);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by hashtag',
                          hintStyle: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          icon: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                            child: Icon(
                              EvaIcons.hash,
                              color: hebenActive,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ]),
                padding: EdgeInsets.all(25.0),
              ),
            ),
          );
        });
  }

  void nameModal(BuildContext context, TextEditingController nameController) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(18.0),
          topRight: const Radius.circular(18.0),
        )),
        builder: (builder) {
          return SafeArea(
            child: ClipRRect(
              child: Container(
                height: DeviceSize().getHeight(context) / 1.2,
                child: Column(children: [
                  Flexible(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: DeviceSize().getWidth(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200],
                      ),
                      child: TextField(
                        controller: nameController,
                        autofocus: true,
                        keyboardAppearance: Brightness.light,
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          icon: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                            child: Icon(
                              EvaIcons.personOutline,
                              color: hebenActive,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.openSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: hebenActive),
                      ),
                    ),
                  )
                ]),
                padding: EdgeInsets.all(25.0),
              ),
            ),
          );
        });
  }

  void bioModal(BuildContext context, TextEditingController bioController) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(18.0),
          topRight: const Radius.circular(18.0),
        )),
        builder: (builder) {
          return SafeArea(
            child: ClipRRect(
              child: Container(
                height: DeviceSize().getHeight(context) / 1.2,
                child: Column(children: [
                  Flexible(
                    child: AnimatedContainer(
                      padding: EdgeInsets.all(8),
                      duration: Duration(milliseconds: 200),
                      width: DeviceSize().getWidth(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200],
                      ),
                      child: TextField(
                        controller: bioController,
                        autofocus: true,
                        maxLines: 4,
                        maxLength: 150,
                        textInputAction: TextInputAction.done,
                        keyboardAppearance: Brightness.light,
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'Tell us something about yourself',
                          hintStyle: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.openSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: hebenActive),
                      ),
                    ),
                  )
                ]),
                padding: EdgeInsets.all(25.0),
              ),
            ),
          );
        });
  }

  void mediaOptions(
      BuildContext context, Function galleryFunction, Function cameraFunction) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(18.0),
          topRight: const Radius.circular(18.0),
        )),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  Container(
                    height: 20,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 6,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  ListTile(
                      leading: Icon(
                        EvaIcons.imageOutline,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Gallery',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        galleryFunction();
                      }),
                  ListTile(
                      leading: Icon(
                        EvaIcons.cameraOutline,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Camera',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        cameraFunction();
                      }),
                ],
              ),
            ),
          );
        });
  }

  void postOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(18.0),
          topRight: const Radius.circular(18.0),
        )),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  Container(
                    height: 20,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 6,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(left: 5.0, top: 5),
                        child: Image.asset(
                          'images/heben_logo.png',
                          height: 24,
                        ),
                      ),
                      title: Text(
                        'Pin to profile',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                      ),
                      onTap: () => {}),
                  ListTile(
                      leading: Icon(
                        EvaIcons.personAddOutline,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Follow',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                      ),
                      onTap: () => {}),
                  ListTile(
                      leading: Icon(
                        EvaIcons.alertTriangleOutline,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Report',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                      ),
                      onTap: () => {}),
                ],
              ),
            ),
          );
        });
  }

  void streamOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(18.0),
          topRight: const Radius.circular(18.0),
        )),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  Container(
                    height: 20,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 6,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  ListTile(
                      leading: Icon(
                        EvaIcons.personAddOutline,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Follow',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                      ),
                      onTap: () => {}),
                  ListTile(
                      leading: Icon(
                        EvaIcons.alertTriangleOutline,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Report',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                      ),
                      onTap: () => {}),
                ],
              ),
            ),
          );
        });
  }
}

class FriendsModalList extends StatefulWidget {
  FriendsModalList(
      {@required this.controller,
      @required this.mainController,
      @required this.uid,
      @required this.isChallenge});

  final TextEditingController controller;
  final TextEditingController mainController;
  final String uid;
  final bool isChallenge;
  @override
  _FriendsModalListState createState() => _FriendsModalListState();
}

class _FriendsModalListState extends State<FriendsModalList> {
  Algolia algolia;
  List<ProfileItem> feedList = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  Future getAlgoliaFuture;

  @override
  void initState() {
    algolia = Algolia.init(
      applicationId: AlgoliaKeys().getAppId(),
      apiKey: AlgoliaKeys().getApiKey(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: DeviceSize().getWidth(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200],
            ),
            child: TextField(
              autofocus: true,
              keyboardAppearance: Brightness.light,
              controller: widget.controller,
              style:
                  GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600),
              onChanged: (text) {
                getAlgoliaFuture = algolia.instance
                    .index('users')
                    .search(text)
                    .setHitsPerPage(5)
                    .getObjects();

                setState(() {});
              },
              onSubmitted: !widget.isChallenge
                  ? (text) {
                      widget.mainController.text += '@' + text + ' ';

                      widget.controller.clear();
                      Navigator.pop(context);
                    }
                  : (text) {},
              decoration: InputDecoration(
                hintText: !widget.isChallenge
                    ? 'Search by username'
                    : 'Challenge friends',
                hintStyle:
                    GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600),
                icon: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                  child: Icon(
                    EvaIcons.at,
                    color: hebenActive,
                    size: 20,
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: FutureBuilder(
              future: getAlgoliaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Container();
                } else {
                  AlgoliaQuerySnapshot data = snapshot.data;

                  if (data.hits.length != 0) {
                    int count = 0;
                    feedList.clear();

                    data.hits.asMap().forEach((index, value) {
                      if (widget.uid != value.objectID) {
                        count++;

                        feedList.add(
                          ProfileItem(
                              uid: value.objectID,
                              username: value.data['username'],
                              profileImage: value.data['profileImage'] ?? ''),
                        );
                      }
                    });

                    if (count != 0) {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        key: _listKey,
                        itemCount: feedList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ContentProfileTile(
                            uid: feedList[index].uid,
                            username: feedList[index].username,
                            profileImage: feedList[index].profileImage,
                            stopGesture: true,
                            onTap: !widget.isChallenge
                                ? () {
                                    widget.mainController.text +=
                                        '@' + feedList[index].username + ' ';

                                    widget.controller.clear();
                                    Navigator.pop(context);
                                  }
                                : () {},
                          );
                        },
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Sorry, no results found',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      );
                    }
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sorry, no results found',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    );
                  }
                }
              }),
        ),
      ],
    );
  }
}
