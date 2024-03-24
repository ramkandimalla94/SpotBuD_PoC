import 'package:flutter/material.dart';

Widget buildLoginButton({
  required String text,
  required VoidCallback onPressed,
  Color textColor = Colors.white,
  Color buttonColor = Colors.blue,
  double height = 30,
  double width = 40,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    ),
  );
}
