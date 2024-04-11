import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:spotbud/ui/view/auth/auth_verification.dart';
import 'package:spotbud/ui/widgets/assets.dart'; // Import your main screen file

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
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    Future.delayed(Duration(seconds: 3), () {
      // Check if the user is already logged in
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          if (user.emailVerified) {
            // User is signed in and email is verified, navigate to home screen
            Get.offNamed(
                '/mainscreen'); // Replace '/mainscreen' with your home screen route
          } else {
            // User is signed in but email is not verified, redirect to verification page
            Get.offNamed('/login');
          }
        } else {
          // No user is signed in, navigate to login screen
          Get.offNamed(
              '/login'); // Replace '/login' with your login screen route
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            AppAssets.logo,
            width: 300,
            height: 300,
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
