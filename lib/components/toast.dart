import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/utils/colors.dart';
import 'package:overlay_support/overlay_support.dart';

class SuccessToast extends StatelessWidget {
  SuccessToast({@required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (_) {
            OverlaySupportEntry.of(context).dismiss();
          },
          child: GFToast(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    EvaIcons.checkmarkCircle,
                    color: hebenSuccess,
                  ),
                ),
                Expanded(
                    child: Text(
                  message,
                  style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                )),
              ],
            ),
            backgroundColor: Colors.white,
            type: GFToastType.rounded,
            autoDismiss: false,
          ),
        ),
      ),
    );
  }
}

class WarningToast extends StatelessWidget {
  WarningToast({@required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (_) {
            OverlaySupportEntry.of(context).dismiss();
          },
          child: GFToast(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    EvaIcons.alertCircleOutline,
                    color: Colors.orangeAccent,
                  ),
                ),
                Expanded(
                    child: Text(
                  message,
                  style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                )),
              ],
            ),
            backgroundColor: Colors.white,
            type: GFToastType.rounded,
            autoDismiss: false,
          ),
        ),
      ),
    );
  }
}

class LoadingToast extends StatelessWidget {
  LoadingToast({@required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (_) {
            OverlaySupportEntry.of(context).dismiss();
          },
          child: GFToast(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        EvaIcons.cloudUploadOutline,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      message,
                      style: GoogleFonts.openSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    )),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.black26,
                      valueColor: AlwaysStoppedAnimation(
                          hebenSuccess.withOpacity(0.75)),
                    ),
                  ),
                )
              ],
            ),
            backgroundColor: Colors.white,
            type: GFToastType.rounded,
            autoDismiss: false,
          ),
        ),
      ),
    );
  }
}
