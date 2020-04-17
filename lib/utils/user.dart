import 'package:firebase_auth/firebase_auth.dart';

class User {
  Future<String> getUid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    return user.uid;
  }
}
