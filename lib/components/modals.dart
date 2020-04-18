import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';

class Modal {
  void friendsModal(BuildContext context, TextEditingController controller,
      TextEditingController mainController) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
        ),
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
                        keyboardAppearance: Brightness.light,
                        controller: controller,
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        onSubmitted: (text) {
                          mainController.text += '@' + text + ' ';
                          controller.clear();
                          Navigator.pop(context);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by username',
                          hintStyle: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.w600),
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
                ]),
                padding: EdgeInsets.all(25.0),
              ),
            ),
          );
        });
  }

  void challengeFriendsModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
        ),
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
                        keyboardAppearance: Brightness.light,
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'Challenge friends',
                          hintStyle: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.w600),
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
          borderRadius: new BorderRadius.circular(18.0),
        ),
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
          borderRadius: new BorderRadius.circular(18.0),
        ),
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
          borderRadius: new BorderRadius.circular(18.0),
        ),
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
          borderRadius: new BorderRadius.circular(18.0),
        ),
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
          borderRadius: new BorderRadius.circular(18.0),
        ),
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
          borderRadius: new BorderRadius.circular(18.0),
        ),
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
