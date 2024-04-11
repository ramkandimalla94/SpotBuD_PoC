import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotbud/ui/view/auth/auth_verification.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/ui/widgets/customalert.dart';
import 'package:spotbud/viewmodels/auth_viewmodel.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/textform.dart';

class SignUpView extends StatelessWidget {
  final AuthViewModel authViewModel = Get.put(AuthViewModel());
  final UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

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
              SizedBox(height: 40),
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 32,
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
              SizedBox(height: 20),
              buildStyledInput(
                controller: firstNameController,
                labelText: 'First Name',
                hintText: 'Enter your first name',
                autofocus: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              buildStyledInput(
                controller: lastNameController,
                labelText: 'Last Name',
                hintText: 'Enter your last name',
                autofocus: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              Obx(() => authViewModel.isLoading.value
                  ? LoadingIndicator()
                  : buildLoginButton(
                      text: 'Sign Up',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();
                          String firstName = firstNameController.text.trim();
                          String lastName = lastNameController.text.trim();
                          try {
                            // Set loading state to true
                            authViewModel.setLoading(true);

                            // Sign up with email and password
                            UserCredential? userCredential = await authViewModel
                                .signUpWithEmailPassword(email, password);
                            if (userCredential != null) {
                              // Save user data after successful sign-up
                              User user = userCredential.user!;
                              await authViewModel.saveUserDataFromEmailPassword(
                                  email: email,
                                  firstName: firstName,
                                  lastName: lastName,
                                  user: user);
                              await authViewModel.sendEmailVerification();

                              // Show success message
                              CustomAlertBox(
                                message: 'You have successfully signed up!',
                                onButtonPressed: () {
                                  Get.to(VerifyScreen());
                                },
                                title: 'Sign Up Successful',
                              );
                              Get.snackbar(
                                'Sign Up Successful',
                                'You have successfully signed up!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                              Get.to(VerifyScreen());

                              // Reset loading state
                              authViewModel.setLoading(false);
                            } else {
                              // Reset loading state
                              authViewModel.setLoading(false);

                              // Show error message if sign-up fails
                              Get.snackbar(
                                'Sign Up Failed',
                                'Failed to sign up. Please try again later.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          } catch (e) {
                            // Reset loading state
                            authViewModel.setLoading(false);

                            // Handle sign-up failure
                            String errorMessage =
                                'Failed to sign up. Please try again later.';
                            print('Firebase Auth Exception: ${e.toString()}');
                            if (e is FirebaseAuthException) {
                              print('Error code: ${e.code}');
                              if (e.code == 'email-already-in-use') {
                                errorMessage =
                                    'This email is already registered.';
                              } else if (e.code == 'weak-password') {
                                errorMessage =
                                    'The password provided is too weak.';
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
                    )),
              //SizedBox(height: 10),
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
              //  SizedBox(height: 20),
              // Logo
              Image.asset(
                AppAssets.logogolden,
                width: 300,
                height: 100,
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
