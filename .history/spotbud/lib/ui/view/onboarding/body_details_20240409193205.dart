import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/gender.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class UserInfoPage extends StatelessWidget {
  final UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());

  @override
  Widget build(BuildContext context) {
    double weight = 0.0; // Temporary variable to store weight input
    int feet = 0; // Temporary variable to store feet input
    int inches = 0; // Temporary variable to store inches input

    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Weight (lbs):'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                weight = double.parse(value); // Update weight value
              },
            ),
            SizedBox(height: 20.0),
            Text('Enter Height (feet and inches):'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      feet = int.parse(value); // Update feet value
                    },
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      inches = int.parse(value); // Update inches value
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text('Select Gender:'),
            Obx(
              () => DropdownButton<Gender>(
                value: userDataViewModel.gender.value,
                onChanged: (value) {
                  userDataViewModel.gender.value = value!;
                },
                items: Gender.values.map((gender) {
                  return DropdownMenuItem<Gender>(
                    value: gender,
                    child: Text(gender.toString().split('.').last),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Save user data
                userDataViewModel.saveBodyDetails(
                  weight, // Pass weight
                  feet, // Pass feet
                  inches, // Pass inches
                  userDataViewModel.gender.value, // Pass selected gender
                );
                Get.toNamed('/mainscreen');
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
