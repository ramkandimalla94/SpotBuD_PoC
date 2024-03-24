import 'package:flutter/material.dart';

Widget buildStyledInput({
  required TextEditingController controller,
  String labelText = 'Email',
  String hintText = 'Enter your email',
  bool obscureText = false,
  IconData? prefixIcon,
  bool autofocus = false,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.blue[800],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            obscureText: obscureText,
            autofocus: autofocus,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: Colors.white)
                  : null,
            ),
          ),
        ),
      ],
    ),
  );
}