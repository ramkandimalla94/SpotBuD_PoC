import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MachineSelectionScreen extends StatelessWidget {
  final String bodyPart;

  MachineSelectionScreen({required this.bodyPart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Machine'),
      ),
      body: Column(
        children: [
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
    Get.to(() => WorkoutLoggingForm(bodyPart: bodyPart, machine: machine));
  }
}
