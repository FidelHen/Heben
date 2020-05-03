import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/utils/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Widget refreshHeader() {
  return ClassicHeader(
    refreshingIcon: Container(
      child: SpinKitThreeBounce(
        color: Colors.grey,
        size: 25,
      ),
    ),
    completeIcon: SpinKitThreeBounce(
      color: hebenSuccess,
      size: 25,
    ),
    releaseIcon: SpinKitThreeBounce(
      color: Colors.grey,
      size: 25,
    ),
    idleIcon: SpinKitThreeBounce(
      color: Colors.grey,
      size: 25,
    ),
    failedIcon: SpinKitThreeBounce(
      color: hebenRed,
      size: 25,
    ),
    refreshingText: '',
    releaseText: '',
    failedText: '',
    idleText: '',
    completeText: '',
  );
}

Widget refreshFooter() {
  return ClassicFooter(
    loadStyle: LoadStyle.ShowWhenLoading,
    idleIcon: Container(),
    idleText: '',
    canLoadingIcon: Icon(
      EvaIcons.refresh,
      color: Colors.grey,
    ),
    noDataText: '',
    textStyle: GoogleFonts.openSans(),
    height: 100,
  );
}
