import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class MachineSelectionScreen extends StatelessWidget {
  final UserDataViewModel _userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Machine'),
      ),
      body: Column(
        children: [
          // Display list of machines based on selected body part
          // Example: ListView.builder(...)
          // Each list item should call _handleMachineSelection method on tap
          ListTile(
            title: Text('Squat Rack'), // Example machine
            onTap: () {
              _handleMachineSelection('Squat Rack');
            },
          ),
          ListTile(
            title: Text('Bench Press'), // Example machine
            onTap: () {
              _handleMachineSelection('Bench Press');
            },
          ),
          // Add more ListTile widgets for other machines
        ],
      ),
    );
  }

  void _handleMachineSelection(String machine) {
    // Navigate to workout logging form and pass the selected machine
    Get.to(() => WorkoutLoggingForm(machine: machine));
  }
}
