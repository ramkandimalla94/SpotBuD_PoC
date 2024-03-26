import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/workout_form.dart';

class MachineSelectionScreen extends StatelessWidget {
  final String bodyPart;

  // Map of body parts to corresponding exercises
  final Map<String, List<String>> exercises = {
    'Legs': ['Squat Rack', 'Leg Press', 'Leg Curl', 'Leg Extension'],
    'Chest': ['Bench Press', 'Dumbbell Press', 'Chest Fly', 'Push-up'],
    'Back': ['Deadlift', 'Pull-up', 'Seated Row', 'Lat Pulldown'],
    'Shoulders': ['Military Press', 'Lateral Raise', 'Front Raise', 'Shrug'],
    'Arms': ['Bicep Curl', 'Tricep Dip', 'Hammer Curl', 'Skull Crusher'],
  };

  MachineSelectionScreen({required this.bodyPart});

  @override
  Widget build(BuildContext context) {
    // Get the list of exercises for the selected body part
    List<String> bodyPartExercises = exercises[bodyPart] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Exercise'),
      ),
      body: ListView.builder(
        itemCount: bodyPartExercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(bodyPartExercises[index]),
            onTap: () {
              _handleMachineSelection(bodyPartExercises[index]);
            },
          );
        },
      ),
    );
  }

  void _handleMachineSelection(String machine) {
    // Navigate to workout logging form and pass the selected machine
    Get.to(() => WorkoutLoggingForm(bodyPart: bodyPart, machine: machine));
  }
}
