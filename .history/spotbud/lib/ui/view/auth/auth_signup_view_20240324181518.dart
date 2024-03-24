import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/viewmodels/login_viewmodel.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/textform.dart';

class SignUpView extends StatelessWidget {
  final AuthViewModel viewModel = Get.put(AuthViewModel());
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
              text: 'Sign Up',
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                if (email.isNotEmpty && password.isNotEmpty) {
                  viewModel.signUp(email, password);
                  // After sign-up, you may want to navigate to the login screen
                  Get.toNamed('/trial');
                } else {
                  // Fields are empty, show error in snackbar
                  Get.snackbar(
                    'Sign Up Failed',
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
                // Navigate to login screen
                Get.off(LoginView());
              },
              child: Text(
                'Already have an account? Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
