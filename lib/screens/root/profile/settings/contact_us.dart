import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/toast.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/user.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:overlay_support/overlay_support.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController subjectController;
  TextEditingController bodyController;
  bool isLoading;

  @override
  void initState() {
    subjectController = TextEditingController();
    bodyController = TextEditingController();
    isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    subjectController.dispose();
    bodyController.dispose();
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
            'Contact us',
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
        body: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  autofocus: true,
                  maxLines: 1,
                  controller: subjectController,
                  maxLength: 50,
                  style: GoogleFonts.lato(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  keyboardAppearance: Brightness.light,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Subject',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    maxLines: 10,
                    controller: bodyController,
                    textInputAction: TextInputAction.done,
                    style: GoogleFonts.lato(
                        fontSize: 16, fontWeight: FontWeight.w500),
                    keyboardAppearance: Brightness.light,
                    maxLength: 500,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Body',
                      hintStyle: GoogleFonts.lato(fontSize: 15),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            validator();
            // Navigation()
            //     .segueToRoot(page: Root(), context: context, fullScreen: true);
          },
          label: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: Text(
                  'Send',
                  style: GoogleFonts.lato(
                      fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              Icon(
                EvaIcons.paperPlaneOutline,
                size: 20,
              )
            ],
          ),
          backgroundColor: hebenActive,
        ),
      ),
    );
  }

  validator() async {
    if (subjectController.text.trim().length >= 2 &&
        bodyController.text.trim().length >= 2) {
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        isLoading = true;
      });
      DocumentSnapshot snapshot = await User().getUserProfileInfo();

      await Firestore.instance.collection('contactMessages').document().setData(
        {
          'body': bodyController.text.trim(),
          'subject': subjectController.text.trim(),
          'userUid': snapshot.data['uid'],
          'userEmail': snapshot.data['email'],
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      setState(() {
        isLoading = false;
      });
      showOverlayNotification((context) {
        return SuccessToast(
            message:
                'Thank you for contacting us, we will get back with you shortly');
      });
      Navigator.pop(context);
    } else {
      showOverlayNotification((context) {
        return WarningToast(
            message: 'Please make sure subject and body aren\'t empty');
      });
    }
  }
}
