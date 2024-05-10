import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:spotbud/ui/view/auth/auth_verification.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/auth_viewmodel.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/textform.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class LoginView extends StatelessWidget {
  final AuthViewModel viewModel = Get.put(AuthViewModel());
  final UserDataViewModel userModel = Get.put(UserDataViewModel());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Future<void> _fetchUserData() async {
    await userModel.fetchUserData();
  }

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              buildStyledInput(
                theme: Theme.of(context),
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
                theme: Theme.of(context),
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
                      if (userCredential.user?.emailVerified ?? false) {
                        // Email is verified, redirect to '/mainscreen'
                        Get.offAllNamed('/mainscreen');
                      } else {
                        // Email is not verified, redirect to VerifyScreen
                        Get.offAllNamed('/verify');
                      }
                    } else {
                      // Login failed, show error in snackbar
                      Get.snackbar(
                        'Login Failed',
                        'Invalid email or password',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Theme.of(context).colorScheme.secondary,
                      );
                    }
                  }
                },
                buttonColor: Theme.of(context).colorScheme.secondary,
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Get.toNamed('/signup');
                  // Navigate to sign-up screen
                },
                child: Text(
                  'Don\'t have an account? Sign Up',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Column(
                children: [
                  Container(
                    height: 70,
                    child: Obx(() {
                      return viewModel.isLoading.value
                          ? LoadingIndicator() // Show circular progress indicator if loading
                          : IconButton(
                              icon: Image.asset(AppAssets.google),
                              onPressed: () {
                                // Set loading state while fetching user data
                                viewModel.setLoading(true);

                                // Fetch user data before sign-in
                                userModel.fetchUserData().then((_) {
                                  // Sign-in with Google after fetching user data
                                  viewModel
                                      .signInWithGoogle()
                                      .then((userCredential) {
                                    // Reset loading state after sign-in attempt
                                    viewModel.setLoading(false);

                                    if (userCredential != null) {
                                      _fetchUserData();

                                      if (userModel.hasInitialData.value) {
                                        // If the user has provided details, redirect to the home screen
                                        Get.toNamed('/mainscreen');
                                      } else {
                                        // If the user hasn't provided details, redirect to th  e body detail page
                                        Get.toNamed('/authbodydetail');
                                      }
                                    } else {
                                      Get.snackbar(
                                        'Sign-In Error',
                                        'Failed to sign in. Please try again later.',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red,
                                        colorText: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ); // Handle sign-in failure
                                    }
                                  });
                                }).catchError((error) {
                                  // Reset loading state if an error occurs during fetching user data
                                  viewModel.setLoading(false);

                                  // Error handling if fetching user data fails
                                  print('Error fetching user data: $error');
                                  Get.snackbar(
                                    'Error',
                                    'Failed to fetch user data. Please try again later.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText:
                                        Theme.of(context).colorScheme.secondary,
                                  );
                                });
                              },
                            );
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
