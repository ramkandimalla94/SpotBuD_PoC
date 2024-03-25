import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/machine_selection_view.dart';
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
          ListTile(
            title: Text('Legs'),
            onTap: () {
              _handleBodyPartSelection('Legs');
            },
          ),
          ListTile(
            title: Text('Chest'),
            onTap: () {
              _handleBodyPartSelection('Chest');
            },
          ),
          // Add more ListTile widgets for other body parts
        ],
      ),
    );
  }

  void _handleBodyPartSelection(String bodyPart) {
    // Navigate to machine selection screen and pass the selected body part
    Get.to(() => MachineSelectionScreen(bodyPart: bodyPart));
  }
}
