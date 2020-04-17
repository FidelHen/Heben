import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/user_heading.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/gallery/photo.dart';
import 'package:heben/utils/gallery/src/delegate/badge_delegate.dart';
import 'package:heben/utils/gallery/src/delegate/checkbox_builder_delegate.dart';
import 'package:heben/utils/gallery/src/delegate/sort_delegate.dart';
import 'package:heben/utils/gallery/src/entity/options.dart';
import 'package:heben/utils/gallery/src/provider/i18n_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class ChangeImages extends StatefulWidget {
  @override
  _ChangeImagesState createState() => _ChangeImagesState();
}

class _ChangeImagesState extends State<ChangeImages> {
  String currentSelected = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: GFAppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Change images',
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
      body: Column(children: <Widget>[
        UserHeading(
          name: 'Fidel Henriquez',
          bio: 'Hey guys I am the founder of heben, thank you for joining!',
          profileImage:
              'https://images.unsplash.com/photo-1457449940276-e8deed18bfff?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80',
          backgroundImage:
              'https://images.unsplash.com/photo-1505506874110-6a7a69069a08?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
          followers: 0,
          following: 0,
          isLive: false,
          role: UserRole.friend,
          isRegistering: true,
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            width: DeviceSize().getWidth(context),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigation()
          //     .segueToRoot(page: Root(), context: context, fullScreen: true);
        },
        label: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Text(
                'Save',
                style:
                    GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w800),
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
