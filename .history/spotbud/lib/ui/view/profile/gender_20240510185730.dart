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
                GestureDetector(
                  onTap: () {
                    _userDataViewModel.gender.value = Gender.Male;
                  },
                  child: Obx(
                    () => Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage(AppAssets.male),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: _userDataViewModel.gender.value == Gender.Male
                              ? Colors.blue
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    _userDataViewModel.gender.value = Gender.Female;
                  },
                  child: Obx(
                    () => Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage(AppAssets.female),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color:
                              _userDataViewModel.gender.value == Gender.Female
                                  ? Colors.pink
                                  : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
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
                _userDataViewModel.saveGender();
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
