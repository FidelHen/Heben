import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heben/utils/user.dart';

class Social {
  likePost({@required String postUid}) async {
    String uid = await User().getUid();
    final batch = Firestore.instance.batch();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    batch.setData(
        Firestore.instance
            .collection('posts')
            .document(postUid)
            .collection('activity')
            .document(uid),
        {'uid': uid, 'liked': true, 'likedAt': timestamp},
        merge: true);

    batch.setData(
      Firestore.instance
          .collection('users')
          .document(uid)
          .collection('likes')
          .document(postUid),
      {'postUid': postUid, 'timestamp': timestamp},
    );

    batch.updateData(
      Firestore.instance.collection('posts').document(postUid),
      {'likes': FieldValue.increment(1), 'liked.$uid': true},
    );

    batch.commit();
  }

  unlikePost({@required String postUid}) async {
    String uid = await User().getUid();
    final batch = Firestore.instance.batch();

    batch.setData(
        Firestore.instance
            .collection('posts')
            .document(postUid)
            .collection('activity')
            .document(uid),
        {
          'uid': uid,
          'liked': false,
        },
        merge: true);

    batch.delete(
      Firestore.instance
          .collection('users')
          .document(uid)
          .collection('likes')
          .document(postUid),
    );

    batch.updateData(
      Firestore.instance.collection('posts').document(postUid),
      {'likes': FieldValue.increment(-1), 'liked.$uid': false},
    );

    batch.commit();
  }

  bookmarkPost({@required String postUid}) async {
    String uid = await User().getUid();
    final batch = Firestore.instance.batch();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    batch.setData(
        Firestore.instance
            .collection('posts')
            .document(postUid)
            .collection('activity')
            .document(uid),
        {'uid': uid, 'bookmarked': true, 'bookmarkedAt': timestamp},
        merge: true);

    batch.setData(
      Firestore.instance
          .collection('users')
          .document(uid)
          .collection('bookmarks')
          .document(postUid),
      {'postUid': postUid, 'timestamp': timestamp},
    );

    batch.updateData(
      Firestore.instance.collection('posts').document(postUid),
      {'bookmarked.$uid': true},
    );

    batch.commit();
  }

  unBookmarkPost({@required String postUid}) async {
    String uid = await User().getUid();
    final batch = Firestore.instance.batch();

    batch.setData(
        Firestore.instance
            .collection('posts')
            .document(postUid)
            .collection('activity')
            .document(uid),
        {'uid': uid, 'bookmarked': false},
        merge: true);

    batch.delete(
      Firestore.instance
          .collection('users')
          .document(uid)
          .collection('bookmarks')
          .document(postUid),
    );

    batch.updateData(
      Firestore.instance.collection('posts').document(postUid),
      {'bookmarked.$uid': false},
    );

    batch.commit();
  }

  deletePost({@required String postUid}) async {
    String uid = await User().getUid();
  }
}
