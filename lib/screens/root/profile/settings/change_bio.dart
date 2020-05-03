import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/user.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ChangeBio extends StatefulWidget {
  @override
  _ChangeBioState createState() => _ChangeBioState();
}

class _ChangeBioState extends State<ChangeBio> {
  TextEditingController bioController;
  bool isLoading;

  @override
  void initState() {
    loadData();
    bioController = TextEditingController();
    isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    bioController.dispose();
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
        backgroundColor: Colors.grey[100],
        appBar: GFAppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Change bio',
            style: GoogleFonts.lato(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
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
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              maxLines: 4,
              autofocus: true,
              controller: bioController,
              textInputAction: TextInputAction.done,
              style:
                  GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500),
              keyboardAppearance: Brightness.light,
              maxLength: 150,
              decoration: InputDecoration.collapsed(
                hintText: 'Tell us something about yourself',
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            uploadData();
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

  loadData() async {
    DocumentSnapshot snapshot = await User().getUserProfileInfo();

    bioController.text = snapshot.data['bio'];
  }

  uploadData() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });

    await User().changeBio(context: context, bio: bioController.text);

    setState(() {
      isLoading = false;
    });
  }
}
