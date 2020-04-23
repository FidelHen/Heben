import 'package:flutter/material.dart';
import 'package:heben/models/streamer_item.dart';
import 'package:heben/utils/enums.dart';

abstract class ContentItems {}

class ContentProfileHeaderItem implements ContentItems {
  ContentProfileHeaderItem({
    @required this.profileImage,
    @required this.backgroundImage,
    @required this.followers,
    @required this.following,
    @required this.name,
    @required this.description,
  });

  final String profileImage;
  final String backgroundImage;
  final int followers;
  final int following;
  final String name;
  final String description;
}

class ContentExploreHeaderItem implements ContentItems {
  ContentExploreHeaderItem({@required this.streamerList});

  final List<StreamerItem> streamerList;
}

class ContentChallengesHeaderItem implements ContentItems {}

class ContentHomeHeaderItem implements ContentItems {
  ContentHomeHeaderItem({@required this.streamerList});

  final List<StreamerItem> streamerList;
}

class ContentTextItem implements ContentItems {
  ContentTextItem({
    @required this.username,
    @required this.profileImage,
    @required this.timestamp,
    @required this.body,
    @required this.popularity,
    @required this.likes,
    @required this.liked,
    @required this.comments,
    @required this.postUid,
    @required this.bookmarked,
  });

  final String username;
  final String profileImage;
  final String timestamp;
  final String body;
  final CurrentPostPopularity popularity;
  final int likes;
  final bool liked;
  final int comments;
  final String postUid;
  final bool bookmarked;
}

class ContentImageItem implements ContentItems {
  ContentImageItem({
    @required this.username,
    @required this.profileImage,
    @required this.timestamp,
    @required this.body,
    @required this.image,
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
  final CurrentPostPopularity popularity;
  final int likes;
  final bool liked;
  final int comments;
  final String postUid;
  final bool bookmarked;
  final String challengeTitle;
  final String challengeUid;
}

class ContentVideoItem implements ContentItems {
  ContentVideoItem({
    @required this.username,
    @required this.profileImage,
    @required this.timestamp,
    @required this.body,
    @required this.video,
    @required this.popularity,
    @required this.likes,
    @required this.liked,
    @required this.bookmarked,
    @required this.comments,
    @required this.postUid,
    @required this.challengeUid,
    @required this.challengeTitle,
  });

  final String username;
  final String profileImage;
  final String timestamp;
  final String body;
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

class ContentChallengeItem implements ContentItems {
  ContentChallengeItem({
    @required this.username,
    @required this.profileImage,
    @required this.timestamp,
    @required this.challengeTitle,
    @required this.video,
    @required this.popularity,
    @required this.likes,
    @required this.liked,
    @required this.image,
    @required this.bookmarked,
    @required this.participants,
    @required this.postUid,
    @required this.creatorUid,
    @required this.comments,
    @required this.intTimestamp,
    @required this.duration,
  });

  final String username;
  final String profileImage;
  final String timestamp;
  final String challengeTitle;
  final String video;
  final CurrentPostPopularity popularity;
  final int likes;
  final bool liked;
  final String image;
  final int intTimestamp;
  final int participants;
  final String postUid;
  final String creatorUid;
  final int comments;
  final bool bookmarked;
  final String duration;
}

class ContentStreamItem implements ContentItems {
  ContentStreamItem({
    @required this.username,
    @required this.profileImage,
    @required this.popularity,
    @required this.image,
    @required this.watchers,
    @required this.postUid,
    @required this.creatorUid,
  });

  final String username;
  final String profileImage;
  final CurrentPostPopularity popularity;
  final String image;
  final int watchers;
  final String postUid;
  final String creatorUid;
}

class ContentStreamCommentItem implements ContentItems {
  ContentStreamCommentItem({
    @required this.username,
    @required this.profileImage,
    @required this.postUid,
    @required this.creatorUid,
    @required this.body,
  });

  final String username;
  final String profileImage;
  final String body;
  final String postUid;
  final String creatorUid;
}

class ContentTagFollowItem implements ContentItems {
  ContentTagFollowItem({@required this.tag, @required this.image});
  final String tag;
  final String image;
}
