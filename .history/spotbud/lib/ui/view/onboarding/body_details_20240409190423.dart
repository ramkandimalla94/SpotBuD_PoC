import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class UserPage extends StatelessWidget {
  final UserDataViewModel userViewModel = Get.put(UserDataViewModel());

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
                userViewModel.setWeight(double.parse(value));
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
                      int feet = int.parse(value);
                      userViewModel.setHeight(
                          feet, userViewModel.user.value.inches);
                    },
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      int inches = int.parse(value);
                      userViewModel.setHeight(
                          userViewModel.user.value.feet, inches);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
