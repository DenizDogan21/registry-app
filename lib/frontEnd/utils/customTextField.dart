import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool isObscure;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.isObscure = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          fillColor: Colors.amber[50], // Set the fill color to white
          filled: true, // Enable the fill color
          border: OutlineInputBorder(),
          // Add more decoration properties if needed
        ),
        keyboardType: keyboardType,
        obscureText: isObscure,
        validator: validator,
        // Add more properties if needed
      ),
    );
  }
}
