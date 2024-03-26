import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/work_out_form.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';

class MachineSelectionScreen extends StatelessWidget {
  final String bodyPart;

  final Map<String, List<Map<String, dynamic>>> machines = {
    'Legs': [
      {'name': 'Squat Rack', 'imagePath': AppAssets.legs},
      {'name': 'Leg Press', 'imagePath': AppAssets.legs},
      {'name': 'Leg Curl', 'imagePath': AppAssets.legs},
      {'name': 'Leg Extension', 'imagePath': AppAssets.legs},
    ],
    'Chest': [
      {'name': 'Bench Press', 'imagePath': AppAssets.chest},
      {'name': 'Dumbbell Press', 'imagePath': AppAssets.chest},
      {'name': 'Chest Fly', 'imagePath': AppAssets.chest},
      {'name': 'Push-up', 'imagePath': AppAssets.chest},
    ],
    'Back': [
      {'name': 'Deadlift', 'imagePath': AppAssets.back},
      {'name': 'Pull-up', 'imagePath': AppAssets.back},
      {'name': 'Seated Row', 'imagePath': AppAssets.back},
      {'name': 'Lat Pulldown', 'imagePath': AppAssets.back},
    ],
    'Shoulders': [
      {'name': 'Military Press', 'imagePath': AppAssets.shoulder},
      {'name': 'Lateral Raise', 'imagePath': AppAssets.shoulder},
      {'name': 'Front Raise', 'imagePath': AppAssets.shoulder},
      {'name': 'Shrug', 'imagePath': AppAssets.shoulder},
    ],
    'Arms': [
      {'name': 'Bicep Curl', 'imagePath': AppAssets.arms},
      {'name': 'Tricep Dip', 'imagePath': AppAssets.arms},
      {'name': 'Hammer Curl', 'imagePath': AppAssets.arms},
      {'name': 'Skull Crusher', 'imagePath': AppAssets.arms},
    ],
  };

  MachineSelectionScreen({required this.bodyPart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.acccentColor),
        backgroundColor: AppColors.bluebackgroundColor,
        title: Text(
          'Select Machine',
          style: AppTheme.secondaryText(
              fontWeight: FontWeight.w500, color: AppColors.acccentColor),
        ),
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

  Widget _buildButton(Map<String, dynamic> machine) {
    String name = machine['name'];
    String imagePath = machine['imagePath'];
    return CustomMachineButton(
      text: name,
      onPressed: () {
        _handleMachineSelection(name);
      },
      imagePath: imagePath,
    );
  }

  void _handleMachineSelection(String machine) {
    // Navigate to workout logging form and pass the selected machine
    Get.to(() => WorkoutLoggingForm(bodyPart: bodyPart, machine: machine));
  }
}
