import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:heben/models/notification_items.dart';

NotificationItems buildFirestoreNotifications({
  @required DocumentSnapshot snapshot,
}) {
  final data = snapshot.data;
  final timeAgo = DateTime.fromMillisecondsSinceEpoch(data['timestamp'])
      .subtract(Duration(seconds: DateTime.now().second));
  if (data['type'] == 'tagged') {
    return NotificationTaggedItem(
        username: data['senderUsername'],
        profileImage: data['profileImage'],
        timestamp: timeago.format(timeAgo, locale: 'en_short'),
        body: data['body'],
        postUid: data['postUid'],
        postType: data['postType']);
  } else if (data['type'] == 'followed') {
    return NotificationFollowItem(
      username: data['senderUsername'],
      profileImage: data['profileImage'],
      timestamp: timeago.format(timeAgo, locale: 'en_short'),
    );
  } else if (data['type'] == 'commented') {
    return NotificationCommentItem(
        username: data['senderUsername'],
        profileImage: data['profileImage'],
        timestamp: timeago.format(timeAgo, locale: 'en_short'),
        postUid: data['postUid'],
        postType: data['postType']);
  } else if (data['type'] == 'challenged') {
    return NotificationChallengedItem(
        username: data['senderUsername'],
        profileImage: data['profileImage'],
        timestamp: timeago.format(timeAgo, locale: 'en_short'),
        postUid: data['postUid'],
        challengeTitle: data['challengeTitle'],
        postType: data['postType']);
  } else if (data['type'] == 'trending') {
    return NotificationTrendingItem(
      timestamp: timeago.format(timeAgo, locale: 'en_short'),
    );
  } else if (data['type'] == 'featured') {
    return NotificationFeaturedItem(
      timestamp: timeago.format(timeAgo, locale: 'en_short'),
    );
  } else {
    return null;
  }
}
