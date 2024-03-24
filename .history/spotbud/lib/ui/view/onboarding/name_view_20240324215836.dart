import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/viewmodels/userdata_viewmodel.dart';
import 'package:spotbud/ui/widgets/textform.dart';

class NameView extends StatelessWidget {
  final NameViewModel viewModel = Get.put(NameViewModel());
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Name')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            ElevatedButton(
              onPressed: () async {
                String firstName = firstNameController.text.trim();
                String lastName = lastNameController.text.trim();
                if (firstName.isNotEmpty && lastName.isNotEmpty) {
                  await viewModel.saveUserName(firstName, lastName);
                  // Redirect to trial screen after storing name
                  Get.toNamed('/trial');
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
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
