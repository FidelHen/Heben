import 'package:flutter/material.dart';

class ProfileItem {
  ProfileItem({
    @required this.uid,
    @required this.username,
    @required this.profileImage,
  });
  final String uid;
  final String username;
  final String profileImage;
}
