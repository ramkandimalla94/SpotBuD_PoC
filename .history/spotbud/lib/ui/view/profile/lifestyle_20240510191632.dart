import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

enum Lifestyle {
  Sedentary,
  LightlyActive,
  ModeratelyActive,
  VeryActive,
}

extension LifestyleExtension on Lifestyle {
  String get displayText {
    return this.toString().splitMapJoin(
          RegExp(r'(?<=[a-z])[A-Z]'),
          onMatch: (m) => ' ${m.group(0)}',
          onNonMatch: (n) => n.toLowerCase(),
        );
  }
}

class LifestyleSelectionScreen extends StatelessWidget {
  final UserDataViewModel _userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Lifestyle'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: AppColors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var lifestyle in Lifestyle.values)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _userDataViewModel.lifestyle.value = lifestyle;
                    _showSaveDialog(context);
                  },
                  child: Text(lifestyle.displayText),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Lifestyle?'),
          content: Text('Are you sure you want to save this lifestyle?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _userDataViewModel.saveLifestyle();
                Navigator.pop(context); // Close the dialog
                Get.back(); // Go back to the previous screen
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
