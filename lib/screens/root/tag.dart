import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/models/content_items.dart';
import 'package:heben/utils/device_size.dart';
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

  @override
  void initState() {
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
    return FutureBuilder(
        future: getPostFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
              backgroundColor: Colors.grey[100],
              appBar: GFAppBar(
                centerTitle: true,
                elevation: 0,
                title: Text(
                  '${widget.tag}',
                  style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
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
              body: Column(
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
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.grey[100],
              appBar: GFAppBar(
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
              body: Container(
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
              ),
            );
          }
        });
  }
}
