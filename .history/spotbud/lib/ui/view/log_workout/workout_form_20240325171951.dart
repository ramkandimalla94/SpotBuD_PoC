import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class WorkoutLoggingForm extends StatelessWidget {
  final String bodyPart;
  final String machine;
  final UserDataViewModel _userDataViewModel = Get.find();

  WorkoutLoggingForm({required this.bodyPart, required this.machine});

  @override
  Widget build(BuildContext context) {
    TextEditingController repsController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController notesController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Log Workout - $machine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: repsController,
              decoration: InputDecoration(labelText: 'Reps'),
            ),
            TextFormField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight'),
            ),
            TextFormField(
              controller: notesController,
              decoration: InputDecoration(labelText: 'Notes'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveWorkoutDetails(
                  repsController.text,
                  weightController.text,
                  notesController.text,
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveWorkoutDetails(String reps, String weight, String notes) {
    // Save workout details using UserDataViewModel
    _userDataViewModel.addWorkoutDetails({
      'timestamp': DateTime.now(),
      'bodyPart': bodyPart,
      'machine': machine,
      'sets': [
        {
          'reps': int.parse(reps),
          'weight': int.parse(weight),
          'notes': notes,
        }
      ],
    });
    // Navigate back to the machine selection screen
    Get.back();
  }
}
