import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/workout_form.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class MachineSelectionScreen extends StatelessWidget {
  final String bodyPart;
  final Map<String, List<String>> machines = {
    'Legs': ['Squat Rack', 'Leg Press', 'Leg Curl', 'Leg Extension'],
    'Chest': ['Bench Press', 'Dumbbell Press', 'Chest Fly', 'Push-up'],
    'Back': ['Deadlift', 'Pull-up', 'Seated Row', 'Lat Pulldown'],
    'Shoulders': ['Military Press', 'Lateral Raise', 'Front Raise', 'Shrug'],
    'Arms': ['Bicep Curl', 'Tricep Dip', 'Hammer Curl', 'Skull Crusher'],
  };

  MachineSelectionScreen({required this.bodyPart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Machine'),
      ),
      body: Column(
        children: _buildButtonRows(),
      ),
    );
  }

  List<Widget> _buildButtonRows() {
    List<Widget> rows = [];
    int numButtons = machines[bodyPart]?.length ?? 0;
    int numFullRows = numButtons ~/ 2; // Integer division

    // Add rows with two buttons each
    for (int i = 0; i < numFullRows; i++) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(machines[bodyPart]![i * 2]),
            _buildButton(machines[bodyPart]![i * 2 + 1]),
          ],
        ),
      );
    }

    // Add the last row if there's an odd number of buttons
    if (numButtons % 2 != 0) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(machines[bodyPart]![numButtons - 1]),
          ],
        ),
      );
    }

    return rows;
  }

  Widget _buildButton(String machine) {
    return custombodybutton(
      text: machine,
      onPressed: () {
        _handleMachineSelection(machine);
      },
      imagePath:
          AppAssets.placeholderImage, // Change placeholder image as needed
    );
  }

  void _handleMachineSelection(String machine) {
    // Navigate to workout logging form and pass the selected machine
    Get.to(() => WorkoutLoggingForm(bodyPart: bodyPart, machine: machine));
  }
}
