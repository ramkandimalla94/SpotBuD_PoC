import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/work_out_form.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class MachineSelectionScreen extends StatelessWidget {
  final String bodyPart;
  final UserDataViewModel _userDataViewModel = Get.find();

  MachineSelectionScreen({required this.bodyPart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bluebackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.acccentColor),
        backgroundColor: AppColors.bluebackgroundColor,
        title: Text(
          'Select Machine',
          style: AppTheme.secondaryText(
              fontWeight: FontWeight.w500, color: AppColors.acccentColor),
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: _userDataViewModel.getMachineNames(bodyPart),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<String> machineNames = snapshot.data ?? [];
            return Column(
              children: _buildButtonRows(machineNames),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildButtonRows(List<String> machineNames) {
    List<Widget> rows = [];
    int numButtons = machineNames.length;
    int numFullRows = numButtons ~/ 2; // Integer division

    // Add rows with two buttons each
    for (int i = 0; i < numFullRows; i++) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(machineNames[i * 2]),
            _buildButton(machineNames[i * 2 + 1]),
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
            _buildButton(machineNames[numButtons - 1]),
          ],
        ),
      );
    }

    return rows;
  }

  Widget _buildButton(String machineName) {
    return CustomMachineButton(
      text: machineName,
      onPressed: () {
        _handleMachineSelection(machineName);
      },
      imagePath: '', // Set image path if needed
    );
  }

  void _handleMachineSelection(String machine) {
    // Navigate to workout logging form and pass the selected machine
    Get.to(() => WorkoutLoggingForm(bodyPart: bodyPart, machine: machine));
  }
}
