// MachineSelectionScreen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/work_out_form.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/ui/widgets/text.dart';

import '../../../viewmodels/user_data_viewmodel.dart';

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
      body: SingleChildScrollView(
        child: FutureBuilder<List<String>>(
          future: _userDataViewModel.getMachineNames(bodyPart),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LoadingIndicator());
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () => _showAddMachineDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddMachineDialog(BuildContext context) {
    TextEditingController machineController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Machine'),
          content: TextField(
            controller: machineController,
            decoration: InputDecoration(hintText: 'Enter Machine Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String machineName = machineController.text.trim();
                if (machineName.isNotEmpty) {
                  _addNewMachine(machineName);
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addNewMachine(String machineName) {
    print('add custom machine called');
    _userDataViewModel.addCustomMachine(bodyPart, machineName);
  }

  void _removeMachine(String machineName) {
    _userDataViewModel.removeCustomMachine(bodyPart, machineName);
    _userDataViewModel.update();
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
      onRemovePressed: () {
        _showRemoveMachineConfirmation(machineName);
      },
      imagePath: AppAssets.arms, // Set image path if needed
    );
  }

  void _showRemoveMachineConfirmation(String machineName) {
    Get.defaultDialog(
      backgroundColor: AppColors.primaryColor,
      title: 'Remove Machine',
      titleStyle: TextStyle(
        color: AppColors.acccentColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(
              'Are you sure you want to remove $machineName?',
              style: TextStyle(
                color: AppColors.acccentColor,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.acccentColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _removeMachine(machineName);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                  ),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleMachineSelection(String machine) {
    // Navigate to workout logging form and pass the selected machine
    Get.to(() => WorkoutLoggingForm(bodyPart: bodyPart, machine: machine));
  }
}
