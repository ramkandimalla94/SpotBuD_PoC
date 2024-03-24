import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/viewmodels/userdata_viewmodel.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/textform.dart';

class NameView extends StatelessWidget {
  final NameViewModel viewModel = Get.put(NameViewModel());
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

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

            SizedBox(height: 2),
            Text(
              'Enter Your Name',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            buildStyledInput(
              controller: firstNameController,
              labelText: 'First Name',
              hintText: 'Enter your first name',
              autofocus: true,
            ),
            SizedBox(height: 20),
            buildStyledInput(
              controller: lastNameController,
              labelText: 'Last Name',
              hintText: 'Enter your last name',
            ),
            SizedBox(height: 40),
            buildLoginButton(
              text: 'Continue',
              onPressed: () async {
                String firstName = firstNameController.text.trim();
                String lastName = lastNameController.text.trim();
                if (firstName.isNotEmpty && lastName.isNotEmpty) {
                  await viewModel.saveUserName(firstName, lastName);
                  // Redirect to trial screen after storing name
                  Get.toNamed('/home');
                } else {
                  // Fields are empty, show error in snackbar
                  Get.snackbar(
                    'Name Entry Failed',
                    'First name and last name are required',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              buttonColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
