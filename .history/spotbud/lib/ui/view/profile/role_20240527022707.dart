import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
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
            _buildRoleOptionsRow(context),
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

  Widget _buildRoleOptionsRow(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRoleOption('trainer', Theme.of(context)),
        SizedBox(
          height: 20,
        ),
        _buildRoleOption('trainee', Theme.of(context)),
      ],
    );
  }

  Widget _buildRoleOption(String role, ThemeData theme) {
    final imagePath = role == 'trainer' ? AppAssets.trainer : AppAssets.trainee;
    return GestureDetector(
      onTap: () {
        _userDataViewModel.role.value = role;
        _userDataViewModel.saveRole();
        print(role);
      },
      child: Obx(
        () => Container(
          width: 170,
          height: 220,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: _userDataViewModel.role.value == role
                ? theme.colorScheme.primary.withOpacity(0.2)
                : theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 140,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Text(
                role.toUpperCase(),
                style: TextStyle(
                  fontSize: 18,
                  color: _userDataViewModel.role.value == role
                      ? theme.colorScheme.primary
                      : theme.colorScheme.background,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
