import 'package:flutter/material.dart';

InputDecoration customInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.grey),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
  );
}