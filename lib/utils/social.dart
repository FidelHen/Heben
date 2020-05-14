import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heben/components/toast.dart';
import 'package:heben/utils/user.dart';
import 'package:overlay_support/overlay_support.dart';

class Social {
  tagUsers(
      {@required List<String> atUsers,
      @required String postUid,
      @required String type,
      @required String body}) async {
    String uid = await User().getUsername();
    if (atUsers.contains(uid)) {
      atUsers.remove(uid);
    }
    if (atUsers.length != 0) {
      final batch = Firestore.instance.batch();
      DocumentSnapshot snapshot = await User().getUserProfileInfo();
      atUsers.forEach((element) {
        batch.setData(
            Firestore.instance.collection('notifications').document(), {
          'senderUsername': snapshot.data['username'],
          'senderUid': snapshot.data['uid'],
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'profileImage': snapshot.data['profileImage'],
          'type': 'tagged',
          'postType': type,
          'body': body,
          'postUid': postUid,
          'receiverUsername': element,
        });
      });

      batch.commit();
    }
  }

  hashtags({@required List<String> tagList, @required String postUid}) async {
    if (tagList.length != 0) {
      final batch = Firestore.instance.batch();
      DocumentSnapshot snapshot = await User().getUserProfileInfo();
      tagList.forEach((element) async {
        batch.setData(Firestore.instance.collection('tags').document(element), {
          'tag': element,
          'lastPostOn': DateTime.now().millisecondsSinceEpoch,
        });

        batch.setData(
            Firestore.instance
                .collection('tags')
                .document(element)
                .collection('posts')
                .document(postUid),
            {
              'uid': snapshot.data['uid'],
              'username': snapshot.data['username'],
              'postUid': postUid,
              'timestamp': DateTime.now().millisecondsSinceEpoch
            });
      });

      batch.commit();
    }
  }

  likePost(
      {@required String postUid, @required String receiverUsername}) async {
    String uid = await User().getUid();
    DocumentSnapshot snapshot = await User().getUserProfileInfo();

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

    if (uid != receiverUsername) {
      batch.setData(Firestore.instance.collection('notifications').document(), {
        'senderUsername': snapshot.data['username'],
        'senderUid': snapshot.data['uid'],
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'profileImage': snapshot.data['profileImage'],
        'type': 'tagged',
        'receiverUsername': receiverUsername,
      });
    }

    batch.updateData(
      Firestore.instance.collection('posts').document(postUid),
      {
        'likes': FieldValue.increment(1),
        'liked.$uid': true,
        'score': FieldValue.increment(30)
      },
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
      {
        'likes': FieldValue.increment(-1),
        'liked.$uid': false,
        'score': FieldValue.increment(-40)
      },
    );

    batch.commit();
  }

  pinPost({@required String postUid}) async {
    String uid = await User().getUid();

    final batch = Firestore.instance.batch();

    batch.setData(Firestore.instance.collection('posts').document(postUid),
        {'score': FieldValue.increment(50)},
        merge: true);

    batch.setData(Firestore.instance.collection('users').document(uid),
        {'pinnedPost': postUid},
        merge: true);

    batch.commit().then((_) {
      showOverlayNotification((context) {
        return SuccessToast(message: 'Post is now pinned');
      });
    });
  }

  unpinPost() async {
    String uid = await User().getUid();

    Firestore.instance
        .collection('users')
        .document(uid)
        .setData({'pinnedPost': ''}, merge: true).then(
            (_) => showOverlayNotification((context) {
                  return SuccessToast(message: 'Post is now unpinned');
                }));
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
      {'bookmarked.$uid': true, 'score': FieldValue.increment(40)},
    );

    batch.commit();
  }

  followUser({@required String userUid, @required String username}) async {
    DocumentSnapshot snapshot = await User().getUserProfileInfo();
    String uid = snapshot.data['uid'];

    final batch = Firestore.instance.batch();

    batch.setData(
        Firestore.instance
            .collection('following')
            .document(uid)
            .collection('users')
            .document(userUid),
        {'uid': userUid});

    batch.setData(
        Firestore.instance
            .collection('followers')
            .document(userUid)
            .collection('users')
            .document(uid),
        {
          'uid': uid,
        });

    batch.setData(Firestore.instance.collection('notifications').document(), {
      'receiverUid': userUid,
      'senderUid': uid,
      'receiverUsername': username,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'profileImage': snapshot.data['profileImage'],
      'type': 'followed',
      'senderUsername': snapshot.data['username'],
    });

    await Firestore.instance
        .collection('posts')
        .where('userUid', isEqualTo: userUid)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) {
        Map<String, dynamic> map = doc.data;
        map.addAll({'addedOn': DateTime.now().millisecondsSinceEpoch});
        batch.setData(
            Firestore.instance
                .collection('timeline')
                .document(uid)
                .collection('timelinePosts')
                .document(map['postUid']),
            map);
      });
    });

    batch.setData(
        Firestore.instance.collection('users').document(uid),
        {
          'following': FieldValue.increment(1),
          'score': FieldValue.increment(25)
        },
        merge: true);

    batch.setData(
        Firestore.instance.collection('users').document(userUid),
        {
          'followers': FieldValue.increment(1),
          'score': FieldValue.increment(50)
        },
        merge: true);

    batch.commit();
  }

  unfollowUser({@required String userUid}) async {
    String uid = await User().getUid();

    final batch = Firestore.instance.batch();

    batch.delete(Firestore.instance
        .collection('following')
        .document(uid)
        .collection('users')
        .document(userUid));

    batch.delete(Firestore.instance
        .collection('followers')
        .document(userUid)
        .collection('users')
        .document(uid));

    batch.setData(Firestore.instance.collection('users').document(uid),
        {'following': FieldValue.increment(-1)},
        merge: true);

    batch.setData(Firestore.instance.collection('users').document(userUid),
        {'followers': FieldValue.increment(-1)},
        merge: true);

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

    final batch = Firestore.instance.batch();

    await Firestore.instance
        .collection('posts')
        .document(postUid)
        .collection('activity')
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) {
        if (doc.data['bookmarked']) {
          batch.delete(Firestore.instance
              .collection('users')
              .document(doc.data['uid'])
              .collection('bookmarks')
              .document(postUid));
        }
        if (doc.data['liked']) {
          batch.delete(Firestore.instance
              .collection('users')
              .document(doc.data['uid'])
              .collection('likes')
              .document(postUid));
        }
        batch.delete(doc.reference);
      });
    });

    await Firestore.instance
        .collection('followers')
        .document(uid)
        .collection('users')
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) {
        batch.delete(Firestore.instance
            .collection('timeline')
            .document(doc.data['uid'])
            .collection('timelinePosts')
            .document(postUid));
      });
    });

    batch.delete(Firestore.instance.collection('posts').document(postUid));

    batch.commit().then((_) {
      showOverlayNotification((context) {
        return SuccessToast(message: 'Post is now deleted');
      });
    });
  }
}
