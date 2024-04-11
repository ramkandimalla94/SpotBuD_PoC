import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  // Create a GlobalKey for RefreshIndicator
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // Call the method to check email verification status on initial load
    _checkEmailVerificationStatus();
  }

  // Method to check email verification status
  Future<void> _checkEmailVerificationStatus() async {
    await VerificationModel().checkEmailVerificationStatus();
  }

  // Method to handle refresh action
  Future<void> _handleRefresh() async {
    await _checkEmailVerificationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Your Email'),
      ),
      // Wrap the body with RefreshIndicator
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        // Display the existing content inside a SingleChildScrollView
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
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
        ),
      ),
    );
  }
}

class VerificationModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkEmailVerificationStatus() async {
    User? user = _auth.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      // Navigate to authbodydetail screen if email is verified
      Get.offAllNamed('/authbodydetail');
    } else {
      // Navigate to verify screen if email is not verified
      Get.offAll(VerifyScreen());
    }
  }
}
