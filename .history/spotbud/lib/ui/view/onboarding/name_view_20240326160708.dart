import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/textform.dart';

class NameView extends StatelessWidget {
  final UserDataViewModel viewModel = Get.put(UserDataViewModel());
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, // Assign form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_circle_left_outlined,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 125),
              Text(
                'Enter Your Name',
                style: TextStyle(
                  fontSize: 32,
                  color: AppColors.acccentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              buildStyledInput(
                controller: firstNameController,
                labelText: 'First Name',
                hintText: 'Enter your first name',
                autofocus: true,
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              buildLoginButton(
                text: 'Continue',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String firstName = firstNameController.text.trim();
                    String lastName = lastNameController.text.trim();
                    await viewModel.saveUserName(firstName, lastName);
                    // Redirect to trial screen after storing name
                    Get.toNamed('/login');
                  }
                },
                buttonColor: Colors.white,
              ),
              SizedBox(height: 30),
              // Logo
              Image.asset(
                AppAssets.logogolden,
                width: 300,
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
