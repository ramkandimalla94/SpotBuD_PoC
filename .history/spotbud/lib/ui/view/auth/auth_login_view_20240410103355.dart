import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/auth_viewmodel.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/textform.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthViewModel viewModel = Get.put(AuthViewModel());
  final UserDataViewModel userModel = Get.put(UserDataViewModel());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool isLoading = false;

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
                    setState(() {
                      isLoading = true; // Set isLoading to true when logging in
                    });
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
                    setState(() {
                      isLoading =
                          false; // Set isLoading to false after login attempt
                    });
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

              Column(
                children: [
                  Container(
                    height: 70,
                    child: isLoading
                        ? LoadingIndicator() // Show CircularProgressIndicator if isLoading is true
                        : IconButton(
                            icon: Image.asset(AppAssets.google),
                            onPressed: () {
                              // setState(() {
                              //   isLoading =
                              //       true; // Set isLoading to true when signing in with Google
                              // });
                              viewModel
                                  .signInWithGoogle()
                                  .then((userCredential) {
                                if (userCredential != null) {
                                  if (userModel.hasInitialData.value) {
                                    // If the user has provided details, redirect to the home screen
                                    Get.toNamed('/mainscreen');
                                  } else {
                                    // If the user hasn't provided details, redirect to the body detail page
                                    Get.toNamed('/authbodydetail');
                                  }
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
                                setState(() {
                                  isLoading =
                                      false; // Set isLoading to false after Google sign-in attempt
                                });
                              });
                            }),
                  ),
                ],
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
