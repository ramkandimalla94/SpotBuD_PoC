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
                      width: 170,
                      height: 400,
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
                      width: 170,
                      height: 400,
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
            SizedBox(height: 10),
            Text("OR",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.secondary,
                )),
            GestureDetector(
              onTap: () {
                _userDataViewModel.gender.value = Gender.Other;
              },
              child: Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _userDataViewModel.gender.value == Gender.Other
                        ? Colors.white // Adjust the color as needed
                        : Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _userDataViewModel.gender.value == Gender.Other
                          ? Colors.white // Adjust the color as needed
                          : Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'Others',
                    style: TextStyle(
                      fontSize: 18,
                      color: _userDataViewModel.gender.value == Gender.Other
                          ? Colors.blue // Adjust the color as needed
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _userDataViewModel.saveGender(_userDataViewModel.gender.value);
                Navigator.pop(context); // Close the dialog
                Get.back(); // Go back to the previous screen
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
