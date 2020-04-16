import 'package:flutter/material.dart';

class StreamerItem {
  StreamerItem(
      {@required this.username,
      @required this.profileImage,
      @required this.backgroundImage,
      @required this.workoutTitle});

  final String username;
  final String profileImage;
  final String backgroundImage;
  final String workoutTitle;
}
