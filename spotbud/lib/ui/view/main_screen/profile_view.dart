import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class ProfileView extends StatelessWidget {
  final UserDataViewModel _nameViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  'First Name: ${_nameViewModel.firstName}',
                )),
            Obx(() => Text(
                  'Last Name: ${_nameViewModel.lastName}',
                )),
            ElevatedButton(
              onPressed: () {
                // Implement logout functionality
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
