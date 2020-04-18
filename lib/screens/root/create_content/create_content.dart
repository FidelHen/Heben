import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/screens/root/create_content/create_post.dart';
import 'package:heben/screens/root/create_content/live_stream.dart';
import 'package:heben/screens/root/create_content/start_challenge.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/navigation.dart';

class CreateContent extends StatefulWidget {
  @override
  _CreateContentState createState() => _CreateContentState();
}

class _CreateContentState extends State<CreateContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: GFAppBar(
        elevation: 0,
        title: Text(
          'Create',
          style: GoogleFonts.lato(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ContentTypeWidget(
              title: 'Create a post',
              description: 'Share anything with the community',
              image: 'images/create_post.jpeg',
              onPressed: () {
                Navigation().segue(
                    page: CreatePost(), context: context, fullScreen: false);
              },
            ),
            ContentTypeWidget(
              title: 'Start live streaming',
              description: 'Let people join your workout in real-time',
              image: 'images/start_live_streaming.jpeg',
              onPressed: () {
                Navigation().segue(
                    page: LiveStream(), context: context, fullScreen: false);
              },
            ),
            ContentTypeWidget(
              title: 'Start a challenge',
              description:
                  'If it doesn\'t challenge you, it doesn\'t change you!',
              image: 'images/start_a_challenge.jpeg',
              onPressed: () {
                Navigation().segue(
                    page: StartChallenge(),
                    context: context,
                    fullScreen: false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ContentTypeWidget extends StatelessWidget {
  ContentTypeWidget(
      {@required this.title,
      @required this.description,
      @required this.image,
      @required this.onPressed});

  final String title;
  final String description;
  final String image;
  final Function onPressed;

  final Color hebenContentOverlay = Colors.black.withOpacity(0.45);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GFImageOverlay(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(
                    title,
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'lato',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    minFontSize: 20,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AutoSizeText(
                    description,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Open_Sans',
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            height: DeviceSize().getHeight(context) / 4.5,
            width: DeviceSize().getWidth(context),
            image: AssetImage(image),
            boxFit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.50), BlendMode.darken),
          ),
        ),
      ),
    );
  }
}
