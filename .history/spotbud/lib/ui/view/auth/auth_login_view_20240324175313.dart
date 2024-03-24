import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/viewmodels/login_viewmodel.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/ui/widgets/textform.dart';

class LoginView extends StatelessWidget {
  final LoginViewModel viewModel = Get.put(LoginViewModel());
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
              'assets/logowhite.png', // Replace 'assets/logo.png' with your logo path
              width: 300, // Adjust width as needed
              height: 200, // Adjust height as needed
            ),
            Text('Login',
                style: AppTheme.primaryText(
                    size: 40, color: AppColors.backgroundColor,fontWeight: )),
            SizedBox(height: 30),
            buildStyledInput(
              controller: emailController,
              labelText: 'Email',
              hintText: 'Enter your email address',
              prefixIcon: Icons.email,
              autofocus: true,
            ),
            SizedBox(height: 20),
            buildStyledInput(
              controller: passwordController,
              labelText: "Password",
              hintText: "Enter your password",
              prefixIcon: Icons.password,
              autofocus: true,
              obscureText: true,
            ),
            SizedBox(height: 40),
            buildLoginButton(
              text: 'Login',
              onPressed: () {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                if (email.isNotEmpty && password.isNotEmpty) {
                  // Perform login verification here
                  // For simplicity, let's check against hardcoded values
                  if (email == 'admin@example.com' && password == '123') {
                    // Login successful, redirect to '/trial' screen
                    Get.offNamed('/trial');
                  } else {
                    // Login failed, show error in snackbar
                    Get.snackbar(
                      'Login Failed',
                      'Invalid email or password',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } else {
                  // Fields are empty, show error in snackbar
                  Get.snackbar(
                    'Login Failed',
                    'Email and password are required',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              buttonColor: Colors.white,
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
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
