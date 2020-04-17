import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heben/screens/intro/onboarding/ask_info.dart';
import 'package:heben/utils/enums.dart';
import 'package:heben/utils/navigation.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

class Auth {
  signUpWithEmail(
      {@required String email,
      @required String password,
      @required String username,
      @required BuildContext context,
      @required UserGoal goal}) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) {
      final batch = Firestore.instance.batch();

      batch.setData(
          Firestore.instance
              .collection('usernames')
              .document(username.toLowerCase().trim()),
          {'username': username.toLowerCase().trim(), 'uid': result.user.uid});

      if (goal != null) {
        batch.setData(
            Firestore.instance.collection('users').document(result.user.uid), {
          'goal': goal.toString(),
          'username': username.toLowerCase().trim(),
          'email': email.toLowerCase().trim(),
          'memberSince': DateTime.now().millisecondsSinceEpoch,
          'isRegistered': false,
        });
      }

      batch.commit().then((_) {
        Navigation()
            .segueToRoot(page: AskInfo(), context: context, fullScreen: true);
      });
    }).catchError((error) {
      if (error is PlatformException) {
        if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return PlatformAlertDialog(
                title: Text('Error'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Email is already in use'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  PlatformDialogAction(
                    child: Text('Okay'),
                    actionType: ActionType.Default,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return PlatformAlertDialog(
                title: Text('Error'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Something went wrong, please try again'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  PlatformDialogAction(
                    child: Text('Okay'),
                    actionType: ActionType.Default,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  Future<bool> checkExistingUsername(
      {@required String username, @required context}) async {
    return await Firestore.instance
        .collection('usernames')
        .document(username.trim().toLowerCase())
        .get()
        .then((result) {
      return !result.exists;
    });
  }
}
