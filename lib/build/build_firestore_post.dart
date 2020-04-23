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

  final timeAgo = DateTime.fromMillisecondsSinceEpoch(data['timestamp'])
      .subtract(Duration(seconds: DateTime.now().second));

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
  } else if (data['type'] == PostContentType.challenge.toString()) {
    return ContentChallengeItem(
        username: data['username'],
        profileImage: data['profileImage'],
        timestamp: timeago.format(timeAgo, locale: 'en_short'),
        challengeTitle: data['challengeTitle'],
        popularity: popularity,
        likes: data['likes'],
        liked: false,
        intTimestamp: data['timestamp'],
        comments: data['comments'],
        participants: data['participants'],
        postUid: snapshot.documentID,
        image: data['image'],
        video: data['video'],
        creatorUid: data['userUid'],
        duration: data['duration'],
        bookmarked: false);
  } else {
    return null;
  }
}
