import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/lifesyle.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class LifestyleSelectionScreen extends StatelessWidget {
  final UserDataViewModel _userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Select Lifestyle',
          style: AppTheme.primaryText(
            size: 27,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: AppColors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLifestyleOption(Lifestyle.Sedentary, Theme.of(context)),
            _buildLifestyleOption(Lifestyle.LightlyActive, Theme.of(context)),
            _buildLifestyleOption(
                Lifestyle.ModeratelyActive, Theme.of(context)),
            _buildLifestyleOption(Lifestyle.VeryActive, Theme.of(context)),
            SizedBox(height: 20),
            buildLoginButton(
              onPressed: () {
                _userDataViewModel.saveLifestyle();
                Get.back(); // Go back to the previous screen
              },
              text: ('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLifestyleOption(Lifestyle lifestyle, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        _userDataViewModel.lifestyle.value = lifestyle;
      },
      child: Obx(() {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: _userDataViewModel.lifestyle.value == lifestyle
                ? theme.colorScheme.primary.withOpacity(0.2)
                : theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            lifestyle.showtext,
            style: TextStyle(
              fontSize: 18,
              color: _userDataViewModel.lifestyle.value == lifestyle
                  ? theme.colorScheme.primary
                  : theme.colorScheme.background,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}
