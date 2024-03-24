import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/viewmodels/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  final LoginViewModel viewModel = Get.put(LoginViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 122,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 29,
                ),
                // GestureDetector(
                //   onTap: () {
                //     Get.back();
                //   },
                //   child: const Icon(
                //     Icons.arrow_circle_left_outlined,
                //     color: Colors.blue, // Change color as needed
                //   ),
                // ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Login', // Change text as needed
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue, // Change color as needed
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                onChanged: viewModel.setEmail,
                decoration: InputDecoration(
                  labelText: 'Email', // Change label text as needed
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                onChanged: viewModel.setPassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password', // Change label text as needed
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: viewModel.login,
              child: Text('Login'), // Change button text as needed
            ),
          ],
        ),
      ),
    );
  }
}
