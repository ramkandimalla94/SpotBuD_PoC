import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/lifesyle.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

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
            _buildLifestyleOption(Lifestyle.Sedentary),
            _buildLifestyleOption(Lifestyle.LightlyActive),
            _buildLifestyleOption(Lifestyle.ModeratelyActive),
            _buildLifestyleOption(Lifestyle.VeryActive),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _userDataViewModel.saveLifestyle();
                Get.back(); // Go back to the previous screen
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLifestyleOption(Lifestyle lifestyle) {
    return GestureDetector(
      onTap: () {
        _userDataViewModel.lifestyle.value = lifestyle;
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _userDataViewModel.lifestyle.value == lifestyle
              ? Colors.blue.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          lifestyle.displayText,
          style: TextStyle(
            fontSize: 18,
            color: _userDataViewModel.lifestyle.value == lifestyle
                ? Colors.blue
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}