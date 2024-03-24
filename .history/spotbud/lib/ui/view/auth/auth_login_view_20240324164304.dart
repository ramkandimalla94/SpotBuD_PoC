import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/viewmodels/login_viewmodel.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';

class LoginView extends StatelessWidget {
  final LoginViewModel viewModel = Get.put(LoginViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      SingleChildScrollView(
        child: Column(Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 29.w,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_circle_left_outlined,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Text(
                  'what_your_name'.tr,
                  style: AppTheme.primaryText(
                    size: 30.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                    height: 1.1.h,
                  ),
                ),
              ],
            ),
            TextField(
              onChanged: viewModel.setEmail,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              onChanged: viewModel.setPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: viewModel.login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
