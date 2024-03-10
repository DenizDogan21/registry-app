import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool isObscure;
  final String? Function(String?)? validator;
  final double fieldSize; // Variable for field size

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.isObscure = false,
    this.validator,
    this.fieldSize = 24.0, // Default field size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(fieldSize / 2.0), // Adjust padding based on fieldSize
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: fieldSize), // Adjust font size for label
          fillColor: Colors.amber[100], // Set the fill color to white
          filled: true, // Enable the fill color
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(fieldSize), // Adjust content padding based on fieldSize
        ),
        keyboardType: keyboardType,
        obscureText: isObscure,
        style: TextStyle(fontSize: fieldSize), // Adjust font size for input text
      ),
    );
  }
}
