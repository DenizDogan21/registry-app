import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyle {
  static TextStyle get titleTextStyle {
    return GoogleFonts.lobster(
      fontSize: 30,
      color: Colors.black,
    );
  }
  static const orangeTextStyle =
      TextStyle(fontSize: 30, color: Colors.deepOrange, fontWeight: FontWeight.w400);
  static const outputListTextStyle =
      TextStyle(fontSize: 15, color: Colors.black);
  static const outputTitleTextStyle =
      TextStyle(fontSize: 20, color: Colors.white, height: 2);



}



