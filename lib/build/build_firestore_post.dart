import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:heben/models/content_items.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:heben/utils/enums.dart';

ContentItems buildFirestorePost({@required DocumentSnapshot snapshot}) {
  final data = snapshot.data;
  CurrentPostPopularity popularity = EnumToString.fromString(
      CurrentPostPopularity.values, data['type'].toString().split('.')[1]);

  final int now = DateTime.now().millisecondsSinceEpoch.toInt();
  final int previous = DateTime.fromMillisecondsSinceEpoch(data['timestamp'])
      .millisecondsSinceEpoch
      .toInt();

  final timeAgo =
      DateTime.now().subtract(Duration(milliseconds: now - previous));

  if (data['type'] == PostContentType.text.toString()) {
    return ContentTextItem(
      username: data['username'],
      profileImage: data['profileImage'],
      timestamp: timeago.format(timeAgo, locale: 'en_short'),
      body: data['body'] ?? '',
      popularity: popularity,
      likes: data['likes'],
      liked: false,
      comments: data['comments'],
      postUid: snapshot.documentID,
      bookmarked: false,
    );
  } else if (data['type'] == PostContentType.image.toString()) {
    return ContentImageItem(
        username: data['username'],
        profileImage: data['profileImage'],
        timestamp: timeago.format(timeAgo, locale: 'en_short'),
        body: data['body'] ?? '',
        image: data['image'] ?? '',
        popularity: popularity,
        likes: data['likes'],
        liked: false,
        comments: data['comments'],
        postUid: snapshot.documentID,
        bookmarked: false,
        challengeTitle: data['challengeTitle'],
        challengeUid: data['challengeUid']);
  } else if (data['type'] == PostContentType.video.toString()) {
    return ContentVideoItem(
        username: data['username'],
        profileImage: data['profileImage'],
        timestamp: timeago.format(timeAgo, locale: 'en_short'),
        body: data['body'] ?? '',
        video: data['video'] ?? '',
        popularity: popularity,
        likes: data['likes'],
        liked: false,
        comments: data['comments'],
        postUid: snapshot.documentID,
        bookmarked: false,
        challengeTitle: data['challengeTitle'],
        challengeUid: data['challengeUid']);
  } else {
    return null;
  }
}
