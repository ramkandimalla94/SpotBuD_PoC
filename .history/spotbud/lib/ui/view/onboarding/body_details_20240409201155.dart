import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/gender.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class UserInfoPage extends StatelessWidget {
  final UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());

  @override
  Widget build(BuildContext context) {
    double weightKg = 0.0; // Temporary variable to store weight input in kg
    double weightLbs = 0.0; // Temporary variable to store weight input in lbs
    int feet = 0; // Temporary variable to store feet input
    int inches = 0; // Temporary variable to store inches input
    double heightMeters =
        0.0; // Temporary variable to store height input in meters
    double heightInches =
        0.0; // Temporary variable to store height input in inches

    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Weight:'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      weightKg = double.parse(value); // Update weight in kg
                      weightLbs = weightKg * 2.20462; // Convert kg to lbs
                    },
                    decoration: InputDecoration(
                      labelText: 'kg',
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      weightLbs = double.parse(value); // Update weight in lbs
                      weightKg = weightLbs / 2.20462; // Convert lbs to kg
                    },
                    decoration: InputDecoration(
                      labelText: 'lbs',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text('Enter Height:'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      feet = int.parse(value); // Update feet value
                      heightInches = feet * 12.0 +
                          inches; // Convert feet and inches to inches
                      heightMeters =
                          heightInches * 0.0254; // Convert inches to meters
                    },
                    decoration: InputDecoration(
                      labelText: 'feet',
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      inches = int.parse(value); // Update inches value
                      heightInches = feet * 12.0 +
                          inches; // Convert feet and inches to inches
                      heightMeters =
                          heightInches * 0.0254; // Convert inches to meters
                    },
                    decoration: InputDecoration(
                      labelText: 'inches',
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      heightMeters =
                          double.parse(value); // Update height in meters
                      heightInches =
                          heightMeters / 0.0254; // Convert meters to inches
                      feet = (heightInches ~/ 12)
                          .toInt(); // Extract feet from inches
                      inches = (heightInches % 12)
                          .toInt(); // Extract inches from remaining inches
                    },
                    decoration: InputDecoration(
                      labelText: 'meters',
                    ),
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
                  weightKg, // Pass weight in kg
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
