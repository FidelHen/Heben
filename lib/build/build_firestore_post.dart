import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:heben/models/content_items.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:heben/utils/enums.dart';

ContentItems buildFirestorePost(
    {@required DocumentSnapshot snapshot,
    @required String uid,
    bool isPinned}) {
  final data = snapshot.data;

  CurrentPostPopularity popularity;
  if (isPinned == null) {
    popularity = EnumToString.fromString(
        CurrentPostPopularity.values, data['type'].toString().split('.')[1]);
  } else {
    popularity = isPinned
        ? CurrentPostPopularity.pinned
        : EnumToString.fromString(CurrentPostPopularity.values,
            data['type'].toString().split('.')[1]);
  }

  final timeAgo = DateTime.fromMillisecondsSinceEpoch(data['timestamp'])
      .subtract(Duration(seconds: DateTime.now().second));

  bool isLiked;
  bool isBookmarked;

  if (data['liked'][uid] == true) {
    isLiked = true;
  } else {
    isLiked = false;
  }

  if (data['bookmarked'][uid] == true) {
    isBookmarked = true;
  } else {
    isBookmarked = false;
  }

  if (data['type'] == PostContentType.text.toString()) {
    return ContentTextItem(
      username: data['username'],
      profileImage: data['profileImage'],
      timestamp: timeago.format(timeAgo, locale: 'en_short'),
      body: data['body'] ?? '',
      popularity: popularity,
      likes: data['likes'],
      liked: isLiked ?? false,
      comments: data['comments'],
      postUid: snapshot.documentID,
      bookmarked: isBookmarked ?? false,
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
        liked: isLiked ?? false,
        comments: data['comments'],
        postUid: snapshot.documentID,
        bookmarked: isBookmarked ?? false,
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
        liked: isLiked ?? false,
        comments: data['comments'],
        postUid: snapshot.documentID,
        bookmarked: isBookmarked ?? false,
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
      liked: isLiked ?? false,
      intTimestamp: data['timestamp'],
      comments: data['comments'],
      participants: data['participants'],
      postUid: snapshot.documentID,
      image: data['image'],
      video: data['video'],
      creatorUid: data['userUid'],
      duration: data['duration'],
      bookmarked: isBookmarked ?? false,
    );
  } else {
    return null;
  }
}
