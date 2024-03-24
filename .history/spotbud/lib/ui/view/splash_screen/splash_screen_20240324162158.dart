import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import your main screen file

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Adjust animation duration as needed
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    // Delay navigation to the main screen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Get.toNamed('/trial'); // Navigate to the main screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Change the background color as needed
      body: Center(
        child: AnimatedOpacity(
          opacity: _animation.value,
          duration: Duration(
              seconds: 1), // Adjust opacity animation duration as needed
          child: Image.asset(
            'assets/logo.png', // Replace 'logo.png' with your actual logo image path
            width: 300, // Adjust the width as needed
            height: 300, // Adjust the height as needed
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
