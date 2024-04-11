import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  @override
  void initState() {
    super.initState();
    // Call checkEmailVerificationStatus after a delay of 3 seconds
    Future.delayed(Duration(seconds: 40), () {
      // Call the method to check email verification status
      VerificationModel().checkEmailVerificationStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Your Email'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please verify your email address.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              Text(
                'A verification link has been sent to your email. Click on the link to verify your email address.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerificationModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkEmailVerificationStatus() async {
    User? user = _auth.currentUser;
    if (user != null && user.emailVerified) {
      // Navigate to authbodydetail screen if email is verified
      Get.offAllNamed('/authbodydetail');
    } else {
      // Navigate to verify screen if email is not verified
      Get.offAll(VerifyScreen());
    }
  }
}
