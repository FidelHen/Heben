import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/build/build_content.dart';
import 'package:heben/build/build_firestore_post.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/models/content_items.dart';
import 'package:heben/utils/device_size.dart';
import 'package:heben/utils/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Tag extends StatefulWidget {
  Tag({@required this.tag});
  final String tag;
  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  RefreshController tagRefreshController = RefreshController();
  List<ContentItems> feedList = [];
  Future getPostFuture;
  bool isLoading;
  String uid;

  @override
  void initState() {
    isLoading = true;
    tagRefreshController = RefreshController();
    getPostFuture = Firestore.instance
        .collection('tags')
        .document(widget.tag)
        .collection('posts')
        .orderBy('timestamp', descending: false)
        .getDocuments();
    loadData();

    super.initState();
  }

  @override
  void dispose() {
    tagRefreshController.dispose();
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
        centerTitle: true,
        elevation: 0,
        title: Text(
          '${widget.tag}',
          style: GoogleFonts.lato(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
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
      body: SmartRefresher(
        physics: BouncingScrollPhysics(),
        enablePullDown: !isLoading,
        enablePullUp: !isLoading,
        header: refreshHeader(),
        footer: refreshFooter(),
        onRefresh: () {
          tagRefreshController.refreshCompleted();
        },
        onLoading: () {
          tagRefreshController.loadComplete();
        },
        controller: tagRefreshController,
        child: buildList(),
      ),
    );
  }

  loadData() async {
    uid = await User().getUid();
    getPostFuture.then((snapshot) {
      final data = snapshot as QuerySnapshot;

      if (data.documents.length != 0) {
        data.documents.forEach((snapshot) async {
          await Firestore.instance
              .collection('posts')
              .document(snapshot.data['postUid'])
              .get()
              .then((doc) {
            ContentItems item = buildFirestorePost(snapshot: doc, uid: uid);
            setState(() {
              feedList.add(item);
            });
          }).then((_) {
            setState(() {
              isLoading = false;
            });
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Widget buildList() {
    if (isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              height: 50,
              child: SpinKitRing(
                color: Colors.black,
                lineWidth: 5,
                size: 40,
              ),
            ),
          )
        ],
      );
    } else {
      if (feedList.length != 0) {
        return Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            key: _listKey,
            itemCount: feedList.length,
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              return buildContent(context, feedList[index], index);
            },
          ),
        );
      } else {
        return Container(
          width: DeviceSize().getWidth(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                EvaIcons.alertCircleOutline,
                size: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sorry, this tag has no posts',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
              )
            ],
          ),
        );
      }
    }
  }
}
