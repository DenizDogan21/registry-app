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
      TextStyle(fontSize: 15, color: Colors.deepOrange, fontWeight: FontWeight.w400);
  static const outputListTextStyle =
      TextStyle(fontSize: 15, color: Colors.white);
  static const outputBlackListTextStyle =
  TextStyle(fontSize: 15, color: Colors.black);
  static const outputTitleTextStyle =
      TextStyle(fontSize: 20, color: Colors.white, height: 2);
  static const outputBlackTitleTextStyle =
  TextStyle(fontSize: 20, color: Colors.black, height: 2);
  static const appBarTextStyle = TextStyle(
    color: Colors.cyanAccent, // Accent color for readability
    fontSize: 20.0, // Appropriate size for AppBar titles
    fontWeight: FontWeight.bold, // Bold text for the title
    letterSpacing: 0.5, // Letter spacing for better readability
  );
  static const appBarTabletTextStyle = TextStyle(
    color: Colors.cyanAccent, // Accent color for readability
    fontSize: 40.0, // Appropriate size for AppBar titles
    fontWeight: FontWeight.bold, // Bold text for the title
    letterSpacing: 0.5, // Letter spacing for better readability
  );




}



