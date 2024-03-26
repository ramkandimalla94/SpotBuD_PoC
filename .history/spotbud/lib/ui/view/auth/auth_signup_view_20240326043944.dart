import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/viewmodels/auth_viewmodel.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/textform.dart';

class SignUpView extends StatelessWidget {
  final AuthViewModel viewModel = Get.put(AuthViewModel());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
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
                AppAssets.logowhite,
                width: 300,
                height: 200,
              ),

              SizedBox(height: 20),
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
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
                text: 'Sign Up',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    try {
                      bool isSignedUp = await viewModel.signUpWithEmailPassword(
                          email, password);
                      if (isSignedUp) {
                        // Sign-up successful, redirect to '/name' screen
                        Get.toNamed('/name');
                      } else {
                        // Sign-up failed, show generic error message
                        Get.snackbar(
                          'Sign Up Failed',
                          'Failed to sign up. Please try again later.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    } catch (e) {
                      // Handle different Firebase Auth exceptions
                      String errorMessage =
                          'Failed to sign up. Please try again later.';
                      print('Firebase Auth Exception: ${e.toString()}');
                      if (e is FirebaseAuthException) {
                        print('Error code: ${e.code}');
                        if (e.code == 'email-already-in-use') {
                          errorMessage = 'This email is already registered.';
                        } else if (e.code == 'weak-password') {
                          errorMessage = 'The password provided is too weak.';
                        }
                        // Add more cases for other possible error codes
                      }
                      // Show error message in snackbar
                      Get.snackbar(
                        'Sign Up Failed',
                        errorMessage,
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
                  // Navigate to login screen
                  Get.toNamed('/login');
                },
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
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
