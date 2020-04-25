import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heben/utils/colors.dart';
import 'package:heben/utils/device_size.dart';

class EmptyListButton extends StatelessWidget {
  const EmptyListButton({@required this.title, @required this.onTap});

  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: DeviceSize().getHeight(context) * 0.2,
        child: Center(
          child: Container(
            height: 40,
            child: FlatButton(
              onPressed: onTap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11.0),
              ),
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600,
                      color: hebenActive,
                      fontSize: 16)),
            ),
          ),
        ));
  }
}
