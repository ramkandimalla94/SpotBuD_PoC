import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginViewModel extends GetxController {
  var email = ''.obs;
  var password = ''.obs;

  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;

  Future<bool> verifyCredentials(String email, String password) async {
    // Logic to verify user credentials, for now, using hardcoded values
    const String sampleEmail = 'admin@example.com';
    const String samplePassword = '123';
    return email == sampleEmail && password == samplePassword;
  }

  void login() async {
    bool isValid = await verifyCredentials(email.value, password.value);
    if (isValid) {
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
