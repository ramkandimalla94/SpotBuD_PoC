import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  @override
  void initState() {
    super.initState();
  }

  // Method to handle "Mail Verified" button press
  void _handleMailVerified() async {
    await VerificationModel().checkEmailVerificationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.backgroundColor),
        title: Text(
          'Verify Your Email',
          style: AppTheme.secondaryText(
              color: AppColors.backgroundColor,
              size: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAssets.verifymail),
              Text(
                'Please verify your email address.',
                textAlign: TextAlign.center,
                style: AppTheme.secondaryText(
                    color: AppColors.acccentColor,
                    size: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'A verification link has been sent to your email. Click on the link to verify your email address.',
                  textAlign: TextAlign.center,
                  style: AppTheme.secondaryText(
                      color: AppColors.backgroundColor,
                      size: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Check your spam folder also',
                textAlign: TextAlign.center,
                style: AppTheme.secondaryText(
                    color: AppColors.acccentColor,
                    size: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              buildLoginButton(
                onPressed: _handleMailVerified,
                text: 'Mail Verified',
              ),
              Text(
                'Click when verified',
                textAlign: TextAlign.center,
                style: AppTheme.primaryText(
                    color: AppColors.backgroundColor,
                    size: 10,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 100,
              )
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
