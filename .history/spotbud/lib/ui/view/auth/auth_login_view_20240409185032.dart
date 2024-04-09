import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';
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

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, // Assign form key
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  } else if (!isValidEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              buildStyledInput(
                controller: passwordController,
                labelText: "Password",
                hintText: "Enter your password",
                prefixIcon: Icons.password,
                autofocus: false,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              buildLoginButton(
                text: 'Login',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    UserCredential? userCredential = await viewModel
                        .signInWithEmailPassword(email, password);
                    if (userCredential != null) {
                      // Login successful, redirect to '/mainscreen' screen
                      Get.toNamed('/mainscreen');
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
                  }
                },
                buttonColor: Colors.white,
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Get.toNamed('/signup');
                  // Navigate to sign-up screen
                },
                child: Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Container(
                height: 100,
                child: IconButton(
                    icon: Image.asset(AppAssets.google),
                    onPressed: () {
                      viewModel.signInWithGoogle().then((userCredential) {
                        if (userCredential != null) {
                          Get.toNamed('/mainscreen');
                          // Navigate to the home screen or perform other actions
                        } else {
                          Get.snackbar(
                            'Sign-In Error',
                            'Failed to sign in. Please try again later.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          ); // Handle sign-in failure
                        }
                      });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
