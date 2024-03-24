import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginViewModel extends GetxController {
  var email = ''.obs;
  var password = ''.obs;

  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;

  void login() {
    // Sample data for email and password for demo purposes
    const String sampleEmail = 'admin@example.com';
    const String samplePassword = '123';

    // Perform login logic by comparing with sample data
    if (email.value == sampleEmail && password.value == samplePassword) {
      // If login is successful, navigate to '/trial' screen
      Get.offNamed(
          '/trial'); // This will replace the current route with '/trial'
      // If you want to keep the login screen in the navigation stack, use Get.toNamed('/trial');
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
}
