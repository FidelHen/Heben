import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/components/modals.dart';
import 'package:heben/screens/root/root.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/gallery/photo.dart';
import 'package:heben/utils/gallery/src/delegate/badge_delegate.dart';
import 'package:heben/utils/gallery/src/delegate/checkbox_builder_delegate.dart';
import 'package:heben/utils/gallery/src/delegate/sort_delegate.dart';
import 'package:heben/utils/gallery/src/entity/options.dart';
import 'package:heben/utils/gallery/src/provider/i18n_provider.dart';
import 'package:heben/utils/navigation.dart';
import 'package:photo_manager/photo_manager.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String currentSelected = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: GFAppBar(
        title: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(
              'https://images.pexels.com/photos/839011/pexels-photo-839011.jpeg?auto=compress&cs=tinysrgb&h=650&w=940'),
        ),
        centerTitle: true,
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
        backgroundColor: Colors.grey[100],
      ),
      body: ListView(
        children: <Widget>[
          Container(
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
                            child: TextField(
                              autofocus: true,
                              maxLines: 10,
                              maxLength: 200,
                              style: GoogleFonts.lato(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                              keyboardAppearance: Brightness.light,
                              decoration: InputDecoration.collapsed(
                                hintText: 'What do you want to share?',
                                hintStyle: GoogleFonts.lato(fontSize: 15),
                              ),
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
                                _pickAsset(PickType.all);
                              },
                              child: GFImageOverlay(
                                colorFilter: null,
                                boxFit: BoxFit.cover,
                                borderRadius: BorderRadius.circular(4),
                                image: NetworkImage(
                                  'https://images.pexels.com/photos/3994840/pexels-photo-3994840.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                                ),
                                color: Colors.grey,
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
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Container(
              height: 50,
              width: DeviceSize().getWidth(context),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Modal().hashtagModal(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                EvaIcons.hash,
                                size: 20,
                              ),
                            ),
                            Text('Hashtag',
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w600))
                          ],
                        ),
                      ),
                    ),
                  )),
                  Container(
                    width: 4,
                    color: Colors.grey[100],
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Modal().friendsModal(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                EvaIcons.at,
                                size: 20,
                              ),
                            ),
                            Text('Friends',
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w600))
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigation()
                .segueToRoot(page: Root(), context: context, fullScreen: true);
          },
          label: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: Text(
                  'Share',
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
