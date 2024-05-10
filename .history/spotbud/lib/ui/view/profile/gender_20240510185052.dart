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
            GestureDetector(
              onTap: () => _userDataViewModel.saveGender(Gender.Male),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(AppAssets.male),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: _userDataViewModel.gender.value == Gender.Male
                        ? Colors.blue
                        : Colors.grey[200]!,
                    width: 3,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _userDataViewModel.saveGender(Gender.Female),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(AppAssets.female),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: _userDataViewModel.gender.value == Gender.Female
                        ? Colors.pink
                        : Colors.grey[200]!,
                    width: 3,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
