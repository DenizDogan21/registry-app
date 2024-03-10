import 'package:turboapp/frontEnd/utils/customTextStyle.dart';
import 'package:flutter/material.dart';

Widget buildButton(BuildContext context, String text, Widget page) {
  double screenWidth = MediaQuery.of(context).size.width; // Get the screen width
  final screenSize = MediaQuery.of(context).size;
  final isTablet = screenSize.width > 600;

  return Container(
    width: screenWidth, // Set the width of the button to match the screen width
    height: isTablet ? 160: 80, // Set a fixed height for the button
    margin: EdgeInsets.symmetric(vertical: 10), // Add some vertical spacing between buttons
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.grey[900], // Button background color
        onPrimary: Colors.white, // Button text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Set the border radius to 0 for a flat design
        ),
        padding: EdgeInsets.symmetric(vertical: 20), // Inner padding for the button
      ),
      child: Text(
        text,
        style: isTablet ? CustomTextStyle.appBarTabletTextStyle: CustomTextStyle.appBarTextStyle
      ),
    ),
  );
}



