import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heben/components/toast.dart';
import 'package:heben/utils/auth.dart';
import 'package:heben/utils/service.dart';
import 'package:overlay_support/overlay_support.dart';

class User {
  Future<String> getUid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    return user.uid;
  }

  Future<DocumentSnapshot> getUserProfileInfo() async {
    String uid = await getUid();

    return Firestore.instance.collection('users').document(uid).get();
  }

  Future<void> changeBio(
      {@required BuildContext context, @required String bio}) async {
    String uid = await getUid();

    await Firestore.instance
        .collection('users')
        .document(uid)
        .setData({'bio': bio}, merge: true);

    showOverlayNotification((context) {
      return SuccessToast(message: 'Successfully changed bio');
    });
    Navigator.pop(context);
  }

  Future<void> changeUsername(
      {@required BuildContext context, @required String username}) async {
    String lowercaseUsername = username.trim().toLowerCase();
    if (Service().usernameValidator(username: lowercaseUsername)) {
      bool available = await Auth()
          .checkExistingUsername(username: username, context: context);
      if (available) {
        DocumentSnapshot snapshot = await getUserProfileInfo();
        final batch = Firestore.instance.batch();

        batch.delete(Firestore.instance
            .collection('usernames')
            .document(snapshot.data['username']));

        batch.setData(
            Firestore.instance
                .collection('users')
                .document(snapshot.data['uid']),
            {
              'username': lowercaseUsername,
            },
            merge: true);

        batch.setData(
            Firestore.instance
                .collection('usernames')
                .document(lowercaseUsername),
            {'username': lowercaseUsername, 'uid': snapshot.data['uid']});

        await batch.commit();

        showOverlayNotification((context) {
          return SuccessToast(message: 'Successfully changed username');
        });
        Navigator.pop(context);
      } else {
        showOverlayNotification((context) {
          return WarningToast(message: 'Username is already taken');
        });
      }
    } else {
      showOverlayNotification((context) {
        return WarningToast(
            message: 'No spaces or special characters for username');
      });
    }
  }
}
