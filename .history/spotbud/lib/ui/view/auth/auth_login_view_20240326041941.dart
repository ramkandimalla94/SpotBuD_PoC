import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            // Logo
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
                  fontWeight: FontWeight.bold),
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
            buildLoginButton(
              text: 'Login',
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                if (email.isNotEmpty && password.isNotEmpty) {
                  bool success =
                      await viewModel.signInWithEmailPassword(email, password);
                  if (success) {
                    // Login successful, redirect to '/trial' screen
                    Get.toNamed('/main');
                  } else {
                    // Login failed, show error in snackbar
                    GetSnackBar(
                      message: 'Invalid email or password',
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } else {
                  // Fields are empty, show error in snackbar
                  GetBar(
                    message: 'Email and password are required',
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              buttonColor: Colors.white,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Get.toNamed('/signup');
                // Navigate to sign-up screen
              },
              child: Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}