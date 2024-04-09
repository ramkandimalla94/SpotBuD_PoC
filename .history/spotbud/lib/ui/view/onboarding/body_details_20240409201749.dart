import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/gender.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class UserInfoPage extends StatelessWidget {
  final UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());

  @override
  Widget build(BuildContext context) {
    double weightLbs = 0.0; // Temporary variable to store weight input in lbs
    double weightKg = 0.0; // Temporary variable to store weight input in kg
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
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      weightLbs = double.parse(value); // Update weight in lbs
                      weightKg = weightLbs * 0.453592; // Convert lbs to kg
                      // Update the displayed weight in kg
                      userDataViewModel.updateWeightKg(weightKg);
                    },
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: Text('(lbs)'),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Obx(() => Text(
                'Weight (kg): ${userDataViewModel.weightKg.value.toStringAsFixed(2)}')),
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
                  weightLbs, // Pass weight in lbs
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
