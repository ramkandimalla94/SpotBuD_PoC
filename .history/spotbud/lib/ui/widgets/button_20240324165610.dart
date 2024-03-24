import 'package:flutter/material.dart';

Widget buildLoginButton({
  required String text,
  required VoidCallback onPressed,
  Color textColor = Colors.white,
  Color primaryColor = Colors.blue,
  double height = 50,
  double width = 100,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue[900],
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Adjust border radius as needed
        ),
        padding: EdgeInsets.zero, // Dark blue color for shadow
        elevation: 5, // Adjust elevation as needed
        shadowColor: Colors.blue[900], // Dark blue color for shadow
        textStyle: TextStyle(color: textColor),
        // Add gradient background
        // You can adjust colors and stops as needed
        // Here we use a linear gradient from primaryColor to dark blue
        // You can also use other gradient types like radial or sweep
        overlayColor: MaterialStateProperty.all(
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, Colors.blue[900]!],
            stops: [0.0, 0.7], // Adjust stops as needed
          ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(10.0), // Adjust border radius as needed
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    ),
  );
}
