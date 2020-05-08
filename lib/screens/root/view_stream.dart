import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/build/build_content.dart';
import 'package:heben/components/modals.dart';
import 'package:heben/models/content_items.dart';
import 'package:heben/utils/device_size.dart';

class ViewStream extends StatefulWidget {
  @override
  _ViewStreamState createState() => _ViewStreamState();
}

class _ViewStreamState extends State<ViewStream> {
  double _itemsOpacity;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<ContentItems> feedList = [];
  bool isTyping = false;
  FocusNode commentFocusNode;
  IjkMediaController controller = IjkMediaController();

  @override
  void initState() {
    loadStream();
    loadTestData();
    _itemsOpacity = 1.0;
    commentFocusNode = new FocusNode();
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    commentFocusNode.addListener(() {
      if (commentFocusNode.hasFocus) {
        isTyping = true;
      } else {
        isTyping = false;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    controller.dispose();
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
    return GestureDetector(
      onTap: () {
        if (_itemsOpacity == 1.0) {
          FocusScope.of(context).unfocus();
        }
        setState(() {
          _itemsOpacity = _itemsOpacity == 0.0 ? 1.0 : 0.0;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            Container(
              height: DeviceSize().getHeight(context),
              width: DeviceSize().getWidth(context),
              color: Colors.blueAccent,
              child: SizedBox(
                child: IjkPlayer(
                  mediaController: controller,
                  controllerWidgetBuilder: (mediaController) {
                    return Container();
                  },
                ),
              ),
            ),
            GFAppBar(
              elevation: 0,
              leading: AnimatedOpacity(
                duration: Duration(milliseconds: 250),
                opacity: _itemsOpacity,
                child: IconButton(
                    icon: Icon(
                      EvaIcons.chevronDown,
                      size: 40,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              actions: <Widget>[
                AnimatedOpacity(
                  duration: Duration(milliseconds: 250),
                  opacity: _itemsOpacity,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: IconButton(
                        icon: Icon(
                          EvaIcons.moreHorizotnal,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Modal().streamOptions(context);
                        }),
                  ),
                ),
              ],
              brightness: Brightness.dark,
              backgroundColor: Colors.transparent,
            ),
            Container(
              width: DeviceSize().getWidth(context),
              child: SafeArea(
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 250),
                  opacity: _itemsOpacity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: DeviceSize().getHeight(context) / 3,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 250),
                            opacity: isTyping ? 0.0 : _itemsOpacity,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      key: _listKey,
                                      itemCount: feedList.length,
                                      reverse: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return buildContent(
                                            context, feedList[index], index);
                                      },
                                    ),
                                  ),
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 15, 15),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white38,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'https://source.unsplash.com/1600x900/?portrait'),
                                                fit: BoxFit.cover),
                                          ),
                                          child: IconButton(
                                              icon: Icon(
                                                EvaIcons.person,
                                                color: Colors.transparent,
                                              ),
                                              onPressed: () {}),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 15, 15),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white24,
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                              icon: Icon(
                                                EvaIcons.messageSquare,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {}),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 15, 15),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white24,
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                              icon: Icon(
                                                EvaIcons.heart,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {}),
                                        ),
                                      ),
                                    ])
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.all(10),
                          child: SafeArea(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    width: DeviceSize().getWidth(context),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white24,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 10.0, left: 10.0),
                                      child: TextField(
                                        autofocus: false,
                                        keyboardAppearance: Brightness.light,
                                        focusNode: commentFocusNode,
                                        style: GoogleFonts.openSans(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                        decoration: InputDecoration(
                                          hintText: 'Add a comment...',
                                          hintStyle: GoogleFonts.openSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      EvaIcons.paperPlaneOutline,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {})
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadStream() async {
    await controller.setNetworkDataSource(
        'https://firebasestorage.googleapis.com/v0/b/smartbot-5abdc.appspot.com/o/Pexels%20Videos%202785531.mp4?alt=media&token=3d7f46a5-a40a-4935-b191-50df1bfe1601',
        autoPlay: true);
    await controller.play();
  }

  loadTestData() async {
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() {
      List<ContentItems> list = [
        ContentStreamCommentItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?portrait',
            postUid: Faker().lorem.word(),
            creatorUid: Faker().lorem.word(),
            body: 'So hypeddd!!!'),
        ContentStreamCommentItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?dad',
            postUid: Faker().lorem.word(),
            creatorUid: Faker().lorem.word(),
            body: 'Glad you\'re streaming again!'),
        ContentStreamCommentItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?mom',
            postUid: Faker().lorem.word(),
            creatorUid: Faker().lorem.word(),
            body: 'Really love what you\'re doing! Keep it up'),
        ContentStreamCommentItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?workout',
            postUid: Faker().lorem.word(),
            creatorUid: Faker().lorem.word(),
            body: 'Let\'s go another set!'),
        ContentStreamCommentItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?male',
            postUid: Faker().lorem.word(),
            creatorUid: Faker().lorem.word(),
            body: 'Loving this new workout!'),
        ContentStreamCommentItem(
            username: Faker().internet.userName(),
            profileImage: 'https://source.unsplash.com/1600x900/?female',
            postUid: Faker().lorem.word(),
            creatorUid: Faker().lorem.word(),
            body: 'Let\'s get it!'),
      ];
      setState(() {
        feedList.insertAll(0, list);
      });
    });
  }
}
