import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/build/build_notification.dart';
import 'package:heben/components/refresh.dart';
import 'package:heben/models/notification_items.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

RefreshController notificationsRefreshController = RefreshController();
int notificationScrollListener = 0;

class Notifications extends StatefulWidget {
  void scrollToTop() {
    if (notificationScrollListener == 1) {
      notificationsRefreshController.position.animateTo(
        -1.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with AutomaticKeepAliveClientMixin<Notifications> {
  List<NotificationItems> currentNotificationsList = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  bool keepAlive = true;
  bool get wantKeepAlive => keepAlive;

  @override
  void initState() {
    loadTestData();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    notificationScrollListener = 1;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  floating: true,
                  snap: true,
                  automaticallyImplyLeading: false,
                  title: Text(
                    'Notifications',
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.grey[100],
                ),
              ];
            },
            body: SmartRefresher(
              controller: notificationsRefreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: refreshHeader(),
              footer: refreshFooter(),
              onLoading: () {
                notificationsRefreshController.loadComplete();
              },
              onRefresh: () {
                notificationsRefreshController.refreshCompleted();
              },
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                key: _listKey,
                itemCount: currentNotificationsList.length,
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return buildNotification(
                      context, currentNotificationsList[index]);
                },
              ),
            )),
      ),
    );
  }

  loadTestData() async {
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() {
      List<NotificationItems> list = [
        NotificationGoingLiveItem(
            username: Faker().internet.userName(),
            profileImage: 'https://i.pravatar.cc/300',
            timestamp: '1 min',
            streamUid: ''),
        NotificationLikedItem(
            username: Faker().internet.userName(),
            profileImage: 'https://i.pravatar.cc/300',
            timestamp: '1 min',
            postUid: '',
            postType: ''),
        NotificationTaggedItem(
            username: Faker().internet.userName(),
            profileImage: 'https://i.pravatar.cc/300',
            timestamp: '1 min',
            body: Faker().lorem.sentence() + '@Hello @world',
            postUid: '',
            postType: ''),
        NotificationTrendingItem(timestamp: '1 min'),
        NotificationFeaturedItem(timestamp: '3 min'),
        NotificationChallengedItem(
            username: Faker().internet.userName(),
            profileImage: 'https://picsum.photos/200',
            timestamp: '1 min',
            postUid: '',
            challengeName: '25 push up challenge',
            postType: ''),
        NotificationCommentItem(
            username: Faker().internet.userName(),
            profileImage: 'https://picsum.photos/200',
            timestamp: '1 mth',
            postUid: '',
            postType: ''),
        NotificationFollowItem(
            username: Faker().internet.userName(),
            profileImage: 'https://i.pravatar.cc/300',
            timestamp: '10 min'),
        NotificationFollowItem(
            username: Faker().internet.userName(),
            profileImage: 'https://picsum.photos/200',
            timestamp: '1 hr'),
        NotificationFollowItem(
            username: Faker().internet.userName(),
            profileImage: 'https://i.pravatar.cc/300',
            timestamp: '1 day'),
        NotificationFollowItem(
            username: Faker().internet.userName(),
            profileImage: 'https://picsum.photos/200',
            timestamp: '1 mth'),
        NotificationCommentItem(
            username: Faker().internet.userName(),
            profileImage: 'https://i.pravatar.cc/300',
            timestamp: '1 mth',
            postUid: '',
            postType: '')
      ];
      setState(() {
        currentNotificationsList.insertAll(0, list);
      });
    });
  }
}
