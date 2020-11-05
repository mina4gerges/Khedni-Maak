import 'package:flutter/material.dart';

class Palette {
  static const Color primaryColor = Color(0xFF2a9d8f);
  static const Color gradientPrimaryColor = Color(0xFF76e8da);

  static const Color secondColor = Color(0xff264653);
  static const Color thirdColor = Color(0xffe9c46a);
  static const Color fourthColor = Color(0xfff4a261);
  static const Color fifthColor = Color(0xffe76f51);

  static  LinearGradient successGradient =  LinearGradient(
    colors: [Colors.green[600], Colors.green[400]]
  );

  static  LinearGradient errorGradient =  LinearGradient(
    colors: [Colors.red[600], Colors.red[400]],
  );
}