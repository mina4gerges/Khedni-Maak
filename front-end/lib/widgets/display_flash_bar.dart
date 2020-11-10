import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khedni_maak/config/palette.dart';

class DisplayFlashBar{
  static displayFlashBar(String status, String text,BuildContext context) {
      Flushbar(
        backgroundGradient:
        status == 'success' ? Palette.successGradient : Palette.errorGradient,
        title: status == 'success' ? 'Success' : 'Error',
        message: text,
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        icon: Icon(
          status == 'success' ? Icons.check : Icons.error,
          size: 28.0,
          color: Colors.white,
        ),
        duration: const Duration(seconds: 3),
        onTap: (flushBar) => flushBar.dismiss(),
      )..show(context);
    }
}