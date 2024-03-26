import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/auth_viewmodel.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/textform.dart';

class LoginView extends StatelessWidget {
  final AuthViewModel viewModel = Get.put(AuthViewModel());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Image.asset(
              AppAssets.logogolden,
              width: 300,
              height: 200,
            ),
            SizedBox(height: 2),
            Text(
              'Welcome Back!',
              style: AppTheme.primaryText(
                size: 32,
                color: AppColors.acccentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            buildStyledInput(
              controller: emailController,
              labelText: 'Email',
              hintText: 'Enter your email address',
              prefixIcon: Icons.email,
              autofocus: false,
            ),
            SizedBox(height: 20),
            buildStyledInput(
              controller: passwordController,
              labelText: "Password",
              hintText: "Enter your password",
              prefixIcon: Icons.password,
              autofocus: false,
              obscureText: true,
            ),
            SizedBox(height: 40),
            buildLoginButton(),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Get.toNamed('/signup');
              },
              child: Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoginButton(
      {required String text, required Future<Null> Function() onPressed}) {
    return buildLoginButton(
      text: 'Login',
      onPressed: () async {
        String email = emailController.text.trim();
        String password = passwordController.text.trim();
        if (email.isNotEmpty &&
            password.isNotEmpty &&
            _isValidEmail(email) &&
            password.length >= 6) {
          bool success =
              await viewModel.signInWithEmailPassword(email, password);
          if (success) {
            Get.toNamed('/main');
          } else {
            showSnackbar('Login Failed', 'Invalid email or password');
          }
        } else {
          String errorMsg = 'Please enter valid email and password';
          if (email.isEmpty || !_isValidEmail(email)) {
            errorMsg = 'Please enter a valid email address';
          } else if (password.length < 6) {
            errorMsg = 'Password must be at least 6 characters long';
          }
          showSnackbar('Login Failed', errorMsg);
        }
      },
      //buttonColor: Colors.white,
    );
  }

  bool _isValidEmail(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.acccentColor,
      colorText: Colors.white,
      margin: EdgeInsets.all(10),
      borderRadius: 10,
      duration: Duration(seconds: 3),
      animationDuration: Duration(milliseconds: 500),
    );
  }

  Widget buildButton({
    required String text,
    required Function onPressed,
    required Color buttonColor,
  }) {
    return Container(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed as void Function()?,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
