import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/gender.dart';

class UserInfoPage extends StatelessWidget {
  final RxDouble weightLbs = 0.0.obs; // Observable to store weight input in lbs
  final RxDouble weightKg = 0.0.obs; // Observable to store weight input in kg
  final UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());

  @override
  Widget build(BuildContext context) {
    int feet = 0; // Temporary variable to store feet input
    int inches = 0; // Temporary variable to store inches input

    // Method to update weight in kg
    void updateWeightKg(double newWeightLbs) {
      weightLbs.value = newWeightLbs;
      weightKg.value = newWeightLbs * 0.453592; // Convert lbs to kg
    }

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
                      updateWeightKg(
                          double.parse(value)); // Update weight in kg
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
            Obx(() =>
                Text('Weight (kg): ${weightKg.value.toStringAsFixed(2)}')),
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
                  weightLbs.value, // Pass weight in lbs
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
