import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthViewModel extends GetxController {
  // Simulated in-memory database using a Map
  final Map<String, String> userCredentials = {
    'admin@example.com': '123', // Sample user data
  };

  var email = ''.obs;
  var password = ''.obs;

  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;

  Future<bool> verifyCredentials(String email, String password) async {
    // Logic to verify user credentials from the in-memory database
    // Check if the provided email exists in the database and if the password matches
    if (userCredentials.containsKey(email) &&
        userCredentials[email] == password) {
      return true; // Credentials are valid
    } else {
      return false; // Credentials are invalid
    }
  }

  void login() async {
    bool isValid = await verifyCredentials(email.value, password.value);
    if (isValid) {
      // If login is successful, navigate to '/trial' screen
      Get.offNamed('/trial');
    } else {
      // If login fails, show a snackbar with an error message
      Get.snackbar(
        'Login Failed',
        'Invalid email or password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  void signUp(String email, String password) {
    // Logic to add a new user to the in-memory database
    // Simply add the new user's email and password to the userCredentials map
    userCredentials[email] = password;
    // Show a snackbar to indicate successful sign-up
    Get.snackbar(
      'Sign-Up Successful',
      'New user created',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
    // Optionally, you can automatically log in the new user after sign-up
    login();
  }
}
