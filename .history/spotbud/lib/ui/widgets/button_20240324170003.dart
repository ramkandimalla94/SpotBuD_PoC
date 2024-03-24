import 'package:flutter/material.dart';

Widget buildLoginButton({
  required String text,
  required VoidCallback onPressed,
  Color textColor = Colors.white,
  Color primaryColor = Colors.blue,
  double height = 60, // Adjust height as needed
  double width = 150, // Adjust width as needed
}) {
  return SizedBox(
    height: height,
    width: width,
    child: TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.blue[900]!;
          }
          return Colors.transparent;
        }),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, Colors.blue[900]!],
            stops: [0.0, 0.7],
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 20),
        ),
      ),
    ),
  );
}
