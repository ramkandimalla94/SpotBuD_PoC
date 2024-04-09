import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/gender.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class UserInfoPage extends StatelessWidget {
  final RxDouble weightLbs = 0.0.obs; // Observable to store weight input in lbs
  final RxDouble weightKg = 0.0.obs; // Observable to store weight input in kg
  final Rx<WeightUnit> selectedUnit =
      WeightUnit.lbs.obs; // Observable to store selected weight unit
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

    // Method to update weight in lbs
    void updateWeightLbs(double newWeightKg) {
      weightKg.value = newWeightKg;
      weightLbs.value = newWeightKg / 0.453592; // Convert kg to lbs
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
            Text('Enter Weight:'),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (selectedUnit.value == WeightUnit.lbs) {
                        updateWeightKg(
                            double.parse(value)); // Update weight in kg
                      } else {
                        updateWeightLbs(
                            double.parse(value)); // Update weight in lbs
                      }
                    },
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: DropdownButton<WeightUnit>(
                    value: selectedUnit.value,
                    onChanged: (value) {
                      // Update selected unit
                      selectedUnit.value = value!;
                      // Update weight values based on the selected unit
                      if (value == WeightUnit.lbs) {
                        weightKg.value = weightLbs.value * 0.453592;
                      } else {
                        weightLbs.value = weightKg.value / 0.453592;
                      }
                    },
                    items: WeightUnit.values.map((unit) {
                      return DropdownMenuItem<WeightUnit>(
                        value: unit,
                        child: Text(unit.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Obx(() => Text(
                      'Weight (lbs): ${weightLbs.value.toStringAsFixed(2)}')),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Obx(() => Text(
                      'Weight (kg): ${weightKg.value.toStringAsFixed(2)}')),
                ),
              ],
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
                  (selectedUnit.value == WeightUnit.lbs)
                      ? weightLbs.value
                      : weightKg.value, // Pass weight
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

enum WeightUnit {
  lbs,
  kg,
}
