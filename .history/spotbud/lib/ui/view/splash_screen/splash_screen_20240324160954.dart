import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import your main screen file

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Delay navigation to the main screen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Get.off(); // Navigate to the main screen
    });

    return Scaffold(
      backgroundColor: Colors.white, // Change the background color as needed
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Replace 'logo.png' with your actual logo image path
          width: 150, // Adjust the width as needed
          height: 150, // Adjust the height as needed
        ),
      ),
    );
  }
}
