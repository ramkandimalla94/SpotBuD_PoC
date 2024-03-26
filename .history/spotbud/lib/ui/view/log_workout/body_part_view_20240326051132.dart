import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/machine_selection_view.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class BodyPartSelectionScreen extends StatelessWidget {
  final UserDataViewModel _userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Body Part'),
      ),
      body: Column(
        children: [
          _buildButtonRow('Legs', 'Chest'),
          _buildButtonRow('Back', 'Arms'),
          // Add more rows as needed
        ],
      ),
    );
  }

  Widget _buildButtonRow(String bodyPart1, String bodyPart2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: customhomebutton(
            text: bodyPart1,
            onPressed: () {
              _handleBodyPartSelection(bodyPart1);
            },
            imagePath: 'assets/$bodyPart1.png', // Replace with your image path
          ),
        ),
        SizedBox(width: 10), // Adjust the spacing between buttons as needed
        Expanded(
          child: customhomebutton(
            text: bodyPart2,
            onPressed: () {
              _handleBodyPartSelection(bodyPart2);
            },
            imagePath: 'assets/$bodyPart2.png', // Replace with your image path
          ),
        ),
      ],
    );
  }

  void _handleBodyPartSelection(String bodyPart) {
    // Navigate to machine selection screen and pass the selected body part
    Get.to(() => MachineSelectionScreen(bodyPart: bodyPart));
  }
}
