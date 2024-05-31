import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class RoleSelectionScreen extends StatelessWidget {
  final UserDataViewModel _userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please select your role',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildRoleOption('trainer', Theme.of(context)),
            SizedBox(height: 20),
            _buildRoleOption('trainee', Theme.of(context)),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Note: This selection is not changeable at a later stage.',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ),
            SizedBox(height: 20),
            buildLoginButton(
              onPressed: () {
                Get.toNamed('/bodydetail');
              },
              text: ('Save'),
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
        print(role);
      },
      child: Obx(
        () => Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: _userDataViewModel.role.value == role
                ? theme.colorScheme.primary.withOpacity(0.2)
                : theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            role,
            style: TextStyle(
              fontSize: 18,
              color: _userDataViewModel.role.value == role
                  ? theme.colorScheme.primary
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
