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
          customhomebutton(
            text: 'Legs',
            onPressed: () {
              _handleBodyPartSelection('Legs');
            },
            imagePath: 'assets/leg_image.png', // Replace with your image path
          ),
          customhomebutton(
            text: 'Chest',
            onPressed: () {
              _handleBodyPartSelection('Chest');
            },
            imagePath: 'assets/chest_image.png', // Replace with your image path
          ),
          // Add more customhomebutton widgets for other body parts
        ],
      ),
    );
  }

  void _handleBodyPartSelection(String bodyPart) {
    // Navigate to machine selection screen and pass the selected body part
    Get.to(() => MachineSelectionScreen(bodyPart: bodyPart));
  }
}
