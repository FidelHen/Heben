import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:heben/utils/gallery/src/delegate/checkbox_builder_delegate.dart';
import 'package:heben/utils/gallery/src/delegate/sort_delegate.dart';
import 'package:heben/utils/gallery/src/entity/options.dart';
import 'package:heben/utils/gallery/src/provider/i18n_provider.dart';
import 'package:heben/utils/navigation.dart';
import 'package:photo_manager/photo_manager.dart';

class AskInfo extends StatefulWidget {
  @override
  _AskInfoState createState() => _AskInfoState();
}

class _AskInfoState extends State<AskInfo> {
  String currentSelected = "";

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
                  UserHeading(
                    name: 'Name',
                    bio: 'My bio',
                    profileImage: '',
                    backgroundImage: '',
                    followers: 0,
                    following: 0,
                    role: UserRole.friend,
                    isRegistering: true,
                  ),
                  Column(children: [
                    todoTab(
                        title: 'Add your name',
                        onPressed: () {
                          Modal().nameModal(context);
                        }),
                    todoTab(
                        title: 'Add your bio',
                        onPressed: () {
                          Modal().bioModal(context);
                        }),
                    todoTab(
                        title: 'Upload profile picture',
                        onPressed: () {
                          _pickAsset(PickType.all);
                        }),
                    todoTab(
                        title: 'Upload background picture',
                        onPressed: () {
                          _pickAsset(PickType.all);
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
                  Navigation().segue(
                      page: AskTags(), context: context, fullScreen: false);
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

  void _pickAsset(PickType type, {List<AssetPathEntity> pathList}) async {
    /// context is required, other params is optional.
    /// context is required, other params is optional.
    /// context is required, other params is optional.

    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      // BuildContext required
      context: context,

      /// The following are optional parameters.
      themeColor: Colors.green,
      // the title color and bottom color

      textColor: Colors.white,
      // text color
      padding: 1.0,
      // item padding
      dividerColor: Colors.grey,
      // divider color
      disableColor: Colors.grey.shade300,
      // the check box disable color
      itemRadio: 0.88,
      // the content item radio
      maxSelected: 8,
      // max picker image count
      // provider: I18nProvider.english,
      provider: I18nProvider.english,
      // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
      rowCount: 3,
      // item row count

      thumbSize: 150,
      // preview thumb size , default is 64
      sortDelegate: SortDelegate.common,
      // default is common ,or you make custom delegate to sort your gallery
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        unselectedColor: Colors.white,
        checkColor: Colors.green,
      ),
      // default is DefaultCheckBoxBuilderDelegate ,or you make custom delegate to create checkbox

      badgeDelegate: const DurationBadgeDelegate(),
      // badgeDelegate to show badge widget

      pickType: type,

      photoPathList: pathList,
    );

    if (imgList == null || imgList.isEmpty) {
      // showToast("No pick item.");
      return;
    } else {
      List<String> r = [];
      for (var e in imgList) {
        var file = await e.file;
        r.add(file.absolute.path);
      }
      currentSelected = r.join("\n\n");

      List<AssetEntity> preview = [];
      preview.addAll(imgList);
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (_) => PreviewPage(list: preview)));
    }
    setState(() {});
  }
}
