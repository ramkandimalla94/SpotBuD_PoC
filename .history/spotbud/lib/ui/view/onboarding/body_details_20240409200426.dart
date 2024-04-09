import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/gender.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());
  TextEditingController weightController = TextEditingController();
  TextEditingController feetController = TextEditingController();
  TextEditingController inchesController = TextEditingController();

  bool isWeightInKg = true; // Flag to track if weight is in kg or lbs
  bool isHeightInFeet = true; // Flag to track if height is in feet or inches

  @override
  Widget build(BuildContext context) {
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
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      updateWeight(value);
                    },
                  ),
                ),
                SizedBox(width: 10.0),
                DropdownButton<String>(
                  value: isWeightInKg ? 'kg' : 'lbs',
                  onChanged: (value) {
                    setState(() {
                      isWeightInKg = value == 'kg';
                      updateWeight(weightController.text);
                    });
                  },
                  items: ['kg', 'lbs']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text('Enter Height:'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: feetController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      updateHeight(value, isFeet: true);
                    },
                  ),
                ),
                SizedBox(width: 10.0),
                Text('ft'),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    controller: inchesController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      updateHeight(value, isFeet: false);
                    },
                  ),
                ),
                SizedBox(width: 10.0),
                Text('in'),
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
                  double.parse(weightController.text), // Pass weight
                  int.parse(feetController.text), // Pass feet
                  int.parse(inchesController.text), // Pass inches
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

  // Method to update weight based on user input
  void updateWeight(String value) {
    if (isWeightInKg) {
      // Convert weight from kg to lbs if currently in kg
      double weightInKg = double.tryParse(value) ?? 0.0;
      double weightInLbs = weightInKg * 2.20462;
      weightController.text = weightInLbs.toStringAsFixed(2);
    } else {
      // Convert weight from lbs to kg if currently in lbs
      double weightInLbs = double.tryParse(value) ?? 0.0;
      double weightInKg = weightInLbs / 2.20462;
      weightController.text = weightInKg.toStringAsFixed(2);
    }
  }

  // Method to update height based on user input
  void updateHeight(String value, {required bool isFeet}) {
    if (isHeightInFeet) {
      // Convert height from feet to inches if currently in feet
      int feet = int.tryParse(value) ?? 0;
      int inches = int.tryParse(inchesController.text) ?? 0;
      int totalInches = feet * 12 + inches;
      feetController.text = (totalInches ~/ 12) as String; // Whole feet
      inchesController.text = (totalInches % 12).toString(); // Remaining inches
    } else {
      // Convert height from inches to feet if currently in inches
      int inches = int.tryParse(value) ?? 0;
      int feet = int.tryParse(feetController.text) ?? 0;
      int totalInches = inches + feet * 12;
      feetController.text = (totalInches ~/ 12).toString(); // Whole feet
      inchesController.text = (totalInches % 12).toString(); // Remaining inches
    }
  }
}
