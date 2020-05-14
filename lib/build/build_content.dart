import 'package:flutter/material.dart';
import 'package:heben/components/content/content_challenge.dart';
import 'package:heben/components/content/content_explore_header.dart';
import 'package:heben/components/content/content_home_header.dart';
import 'package:heben/components/content/content_image.dart';
import 'package:heben/components/content/content_stream.dart';
import 'package:heben/components/content/content_stream_comment.dart';
import 'package:heben/components/content/content_text.dart';
import 'package:heben/components/content/content_video.dart';
import 'package:heben/models/content_items.dart';

Widget buildContent(context, ContentItems item) {
  if (item is ContentTextItem) {
    return ContentText(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      body: item.body,
      popularity: item.popularity,
      likes: item.likes,
      liked: item.liked,
      comments: item.comments,
      postUid: item.postUid,
      bookmarked: item.bookmarked,
    );
  } else if (item is ContentImageItem) {
    return ContentImage(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      body: item.body,
      image: item.image,
      popularity: item.popularity,
      likes: item.likes,
      liked: item.liked,
      comments: item.comments,
      postUid: item.postUid,
      bookmarked: item.bookmarked,
      challengeTitle: item.challengeTitle,
      challengeUid: item.challengeUid,
    );
  } else if (item is ContentVideoItem) {
    return ContentVideo(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      body: item.body,
      video: item.video,
      popularity: item.popularity,
      likes: item.likes,
      liked: item.liked,
      bookmarked: item.bookmarked,
      comments: item.comments,
      postUid: item.postUid,
      challengeTitle: item.challengeTitle,
      challengeUid: item.challengeUid,
    );
  } else if (item is ContentChallengeItem) {
    return ContentChallenge(
      username: item.username,
      profileImage: item.profileImage,
      timestamp: item.timestamp,
      challengeTitle: item.challengeTitle,
      video: item.video,
      popularity: item.popularity,
      likes: item.likes,
      liked: item.liked,
      image: item.image,
      bookmarked: item.bookmarked,
      participants: item.participants,
      postUid: item.postUid,
      creatorUid: item.creatorUid,
      comments: item.comments,
      intTimestamp: item.intTimestamp,
      duration: item.duration,
    );
  } else if (item is ContentHomeHeaderItem) {
    return ContentHomeHeader();
  } else if (item is ContentExploreHeaderItem) {
    return ContentExploreHeader();
  } else if (item is ContentStreamItem) {
    return ContentStream(
        username: item.username,
        profileImage: item.profileImage,
        popularity: item.popularity,
        image: item.image,
        watchers: item.watchers,
        postUid: item.postUid,
        creatorUid: item.creatorUid);
  } else if (item is ContentStreamCommentItem) {
    return ContentSteamComment(
        username: item.username,
        profileImage: item.profileImage,
        postUid: item.postUid,
        creatorUid: item.creatorUid,
        body: item.body);
  } else {
    return Container();
  }
}
