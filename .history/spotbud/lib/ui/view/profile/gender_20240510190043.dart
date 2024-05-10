import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/gender.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

class GenderSelectionScreen extends StatelessWidget {
  final UserDataViewModel _userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Gender'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: AppColors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGenderOption(Gender.Male, AppAssets.male, Colors.blue),
                SizedBox(width: 20),
                _buildGenderOption(
                    Gender.Female, AppAssets.female, Colors.pink),
                SizedBox(width: 20),
                _buildGenderOption(
                    Gender.Others, AppAssets.otherGender, Colors.orange),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showSaveDialog(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(
      Gender gender, String assetPath, Color borderColor) {
    return GestureDetector(
      onTap: () {
        _userDataViewModel.gender.value = gender;
      },
      child: Obx(
        () => Container(
          width: 170,
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: AssetImage(assetPath),
              fit: BoxFit.cover,
            ),
            border: Border.all(
              color: _userDataViewModel.gender.value == gender
                  ? borderColor
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
      ),
    );
  }

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Gender?'),
          content: Text('Are you sure you want to save this gender?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _userDataViewModel.saveGender(_userDataViewModel.gender.value);
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
