import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/machine_selection_view.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class BodyPartSelectionScreen extends StatelessWidget {
  final UserDataViewModel _userDataViewModel = Get.find();

  // Define a list of body parts with their respective images
  final List<Map<String, dynamic>> bodyParts = [
    {'name': 'Legs', 'imagePath': AppAssets.logo},
    {'name': 'Chest', 'imagePath': AppAssets.logo},
    {'name': 'Back', 'imagePath': AppAssets.logo},
    {'name': 'Arms', 'imagePath': AppAssets.logo},
    {'name': 'Shoulders', 'imagePath': AppAssets.logo},
    // Add more body parts here with their respective image paths
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Body Part'),
      ),
      body: Column(
        children: _buildButtonRows(),
      ),
    );
  }

  List<Widget> _buildButtonRows() {
    List<Widget> rows = [];
    int numButtons = bodyParts.length;
    int numFullRows = numButtons ~/ 2; // Integer division

    // Add rows with two buttons each
    for (int i = 0; i < numFullRows; i++) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(bodyParts[i * 2]),
            _buildButton(bodyParts[i * 2 + 1]),
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
            _buildButton(bodyParts[numButtons - 1]),
          ],
        ),
      );
    }

    return rows;
  }

  Widget _buildButton(Map<String, dynamic> bodyPart) {
    String name = bodyPart['name'];
    String imagePath = bodyPart['imagePath'];
    return custombodybutton(
      text: name,
      onPressed: () {
        _handleBodyPartSelection(name);
      },
      imagePath: imagePath,
    );
  }

  void _handleBodyPartSelection(String bodyPart) {
    // Navigate to machine selection screen and pass the selected body part
    Get.to(() => MachineSelectionScreen(bodyPart: bodyPart));
  }
}
