import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/viewmodels/login_viewmodel.dart';
import 'package:spotbud/ui/widgets/button.dart';

class LoginView extends StatelessWidget {
  final LoginViewModel viewModel = Get.put(LoginViewModel());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 122),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 29),
                // GestureDetector(
                //   onTap: () {
                //     Get.back();
                //   },
                  child: const Icon(
                    Icons.arrow_circle_left_outlined,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),
            SizedBox(height: 20),
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
            ),
          ],
        ),
      ),
    );
  }
}
