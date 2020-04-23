import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:heben/components/content/content_post_comment.dart';
import 'package:heben/components/content/content_post_header.dart';
import 'package:heben/models/post_items.dart';

Widget buildPost(context, PostItems item, [int index]) {
  if (item is PostHeaderItem) {
    return ContentPostHeader(
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
      video: item.video,
    );
  } else if (item is PostCommentItem) {
    return ContentPostComment(
      body: Faker().lorem.sentence() + ' @Hello' + ' #World',
      creatorUid: null,
      username: null,
    );
  } else {
    return Container();
  }
}
