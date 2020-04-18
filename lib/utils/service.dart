import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Service {
  bool usernameValidator({@required String username}) {
    final alphanumeric = RegExp(r'^\S[a-zA-Z0-9_]{3,25}$');
    return alphanumeric.hasMatch(username.trim());
  }

  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }
}
