import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/gender.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class UserInfoPage extends StatelessWidget {
  final UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());

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
            Text('Enter Weight (lbs):'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Your implementation
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
                      // Your implementation
                    },
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      // Your implementation
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text('Select Gender:'),
            Obx(() => DropdownButton<Gender>(
                  value: userDataViewModel.gender.value,
                  onChanged: (value) {
                    userDataViewModel.gender.value = value!;
                  },
                  items: Gender.values.map((Gender gender) {
                    return DropdownMenuItem<Gender>(
                      value: gender,
                      child: Text(gender.toString().split('.').last),
                    );
                  }).toList(),
                )),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Save user data
                userDataViewModel.saveBodyDetails(
                  // Pass weight, feet, inches, and gender
                  , // Replace with actual weight
                  0, // Replace with actual feet
                  0, // Replace with actual inches
                  userDataViewModel.gender.value, // Get selected gender
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
