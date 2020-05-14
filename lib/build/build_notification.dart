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

Widget buildNotification(
  context,
  NotificationItems item,
) {
  if (item is NotificationLikedItem) {
    return NotificationLiked(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      postType: item.postType,
      postUid: item.postUid,
    );
  } else if (item is NotificationFollowItem) {
    return NotificationFollow(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
    );
  } else if (item is NotificationCommentItem) {
    return NotificationComment(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      postUid: item.postUid,
      postType: item.postType,
    );
  } else if (item is NotificationChallengedItem) {
    return NotificationChallenged(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      postUid: item.postUid,
      postType: item.postType,
      challengeTitle: item.challengeTitle,
    );
  } else if (item is NotificationTaggedItem) {
    return NotificationTagged(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      body: item.body,
      postType: item.postType,
      postUid: item.postUid,
    );
  } else if (item is NotificationFeaturedItem) {
    return NotificationFeatured(
      timestamp: item.timestamp,
    );
  } else if (item is NotificationTrendingItem) {
    return NotificationTrending(
      timestamp: item.timestamp,
    );
  } else if (item is NotificationGoingLiveItem) {
    return NotificationGoingLive(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      streamUid: item.streamUid,
    );
  } else {
    return Container();
  }
}
