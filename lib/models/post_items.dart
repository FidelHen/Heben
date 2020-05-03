import 'package:flutter/material.dart';
import 'package:heben/utils/enums.dart';

abstract class PostItems {}

class PostHeaderItem implements PostItems {
  PostHeaderItem({
    @required this.username,
    @required this.profileImage,
    @required this.timestamp,
    @required this.body,
    @required this.image,
    @required this.video,
    @required this.popularity,
    @required this.likes,
    @required this.liked,
    @required this.comments,
    @required this.postUid,
    @required this.bookmarked,
    @required this.challengeUid,
    @required this.challengeTitle,
  });

  final String username;
  final String profileImage;
  final String timestamp;
  final String body;
  final String image;
  final String video;
  final CurrentPostPopularity popularity;
  final int likes;
  final bool liked;
  final int comments;
  final String postUid;
  final bool bookmarked;
  final String challengeTitle;
  final String challengeUid;
}

class PostCommentItem implements PostItems {
  PostCommentItem(
      {@required this.username,
      @required this.profileImage,
      @required this.timestamp,
      @required this.body,
      @required this.commentUid,
      @required this.userUid});

  final String username;
  final String profileImage;
  final String timestamp;
  final String body;
  final String commentUid;
  final String userUid;
}
