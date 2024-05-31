import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class RoleSelectionScreen extends StatelessWidget {
  final UserDataViewModel _userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Role'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: AppColors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please select your role',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildRoleOption('Trainer', Theme.of(context)),
            SizedBox(height: 20),
            _buildRoleOption('Trainee', Theme.of(context)),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Note: This selection is not changeable at a later stage.',
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _userDataViewModel.saveRole();
                Get.back();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleOption(String role, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        _userDataViewModel.role.value = role;
        _userDataViewModel.saveRole();
      },
      child: Obx(
        () => Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: _userDataViewModel.role.value == role
                ? theme.colorScheme.primary.withOpacity(0.4)
                : theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            role,
            style: TextStyle(
              fontSize: 18,
              color: _userDataViewModel.role.value == role
                  ? Colors.blue
                  : theme.colorScheme.background,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
