import 'package:flutter/material.dart';

abstract class NotificationItems {}

class NotificationLikedItem implements NotificationItems {
  NotificationLikedItem(
      {@required this.username,
      @required this.profileImage,
      @required this.timestamp,
      @required this.postUid,
      @required this.postType});

  final String username;
  final String profileImage;
  final String timestamp;
  final String postUid;
  final String postType;
}

class NotificationFollowItem implements NotificationItems {
  NotificationFollowItem(
      {@required this.username,
      @required this.profileImage,
      @required this.timestamp});

  final String username;
  final String profileImage;
  final String timestamp;
}

class NotificationGoingLiveItem implements NotificationItems {
  NotificationGoingLiveItem(
      {@required this.username,
      @required this.profileImage,
      @required this.streamUid,
      @required this.timestamp});

  final String username;
  final String streamUid;
  final String profileImage;
  final String timestamp;
}

class NotificationCommentItem implements NotificationItems {
  NotificationCommentItem(
      {@required this.username,
      @required this.profileImage,
      @required this.timestamp,
      @required this.postUid,
      @required this.postType});

  final String username;
  final String profileImage;
  final String timestamp;

  final String postUid;
  final String postType;
}

class NotificationChallengedItem implements NotificationItems {
  NotificationChallengedItem(
      {@required this.username,
      @required this.profileImage,
      @required this.timestamp,
      @required this.postUid,
      @required this.challengeTitle,
      @required this.postType});

  final String username;
  final String profileImage;
  final String timestamp;
  final String postUid;
  final String postType;
  final String challengeTitle;
}

class NotificationTaggedItem implements NotificationItems {
  NotificationTaggedItem({
    @required this.username,
    @required this.profileImage,
    @required this.timestamp,
    @required this.body,
    @required this.postUid,
    @required this.postType,
  });

  final String username;
  final String profileImage;
  final String timestamp;
  final String body;
  final String postUid;
  final String postType;
}

class NotificationFeaturedItem implements NotificationItems {
  NotificationFeaturedItem({@required this.timestamp});

  final String timestamp;
}

class NotificationTrendingItem implements NotificationItems {
  NotificationTrendingItem({@required this.timestamp});

  final String timestamp;
}
