import 'package:flutter/material.dart';
import 'package:heben/components/notification/notification_challenged.dart';
import 'package:heben/components/notification/notification_comment.dart';
import 'package:heben/components/notification/notification_featured.dart';
import 'package:heben/components/notification/notification_follow.dart';
import 'package:heben/components/notification/notification_going_live.dart';
import 'package:heben/components/notification/notification_liked.dart';
import 'package:heben/components/notification/notification_tagged.dart';
import 'package:heben/components/notification/notification_trending.dart';
import 'package:heben/models/notification_items.dart';

Widget buildNotification(context, NotificationItems item, [int index]) {
  bool firstIndex = false;

  if (index == 0) {
    firstIndex = true;
  }

  if (item is NotificationLikedItem) {
    return NotificationLiked(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      firstIndex: firstIndex,
      postType: item.postType,
      postUid: item.postUid,
    );
  } else if (item is NotificationFollowItem) {
    return NotificationFollow(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      firstIndex: firstIndex,
    );
  } else if (item is NotificationCommentItem) {
    return NotificationComment(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      firstIndex: firstIndex,
      postUid: item.postUid,
      postType: item.postType,
    );
  } else if (item is NotificationChallengedItem) {
    return NotificationChallenged(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      firstIndex: firstIndex,
      postUid: item.postUid,
      postType: item.postType,
      challengeName: item.challengeName,
    );
  } else if (item is NotificationTaggedItem) {
    return NotificationTagged(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      firstIndex: firstIndex,
      body: item.body,
      postType: item.postType,
      postUid: item.postUid,
    );
  } else if (item is NotificationFeaturedItem) {
    return NotificationFeatured(
      timestamp: item.timestamp,
      firstIndex: firstIndex,
    );
  } else if (item is NotificationTrendingItem) {
    return NotificationTrending(
      timestamp: item.timestamp,
      firstIndex: firstIndex,
    );
  } else if (item is NotificationGoingLiveItem) {
    return NotificationGoingLive(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      firstIndex: firstIndex,
      streamUid: item.streamUid,
    );
  } else {
    return Container();
  }
}
