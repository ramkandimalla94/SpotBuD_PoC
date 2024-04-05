import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/work_out_form.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final UserDataViewModel _nameViewModel = Get.put(UserDataViewModel());

  @override
  void initState() {
    super.initState();
    _nameViewModel.fetchUserNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bluebackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40), // Adjust the space according to your needs
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Hi,',
                style: AppTheme.primaryText(
                    size: 32.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Obx(
                () => Text(
                  '${_nameViewModel.firstName} ${_nameViewModel.lastName}',
                  style: AppTheme.secondaryText(
                      size: 35.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.acccentColor),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            customhomebutton(
              text: "Log Workout",
              onPressed: () {
                Get.to(WorkoutLoggingForm());
              },
              imagePath: AppAssets.logworkout,
            ),
            customhomebutton(
              text: "History",
              onPressed: () {
                Get.toNamed('/history');
              },
              imagePath: AppAssets.history,
            ),
            customhomebutton(
              text: "Progress Tracker",
              onPressed: () {},
              imagePath: AppAssets.progress,
            ),
            SizedBox(height: 20), // Add some space between buttons and logo
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  AppAssets.logogolden,
                  width: 150,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
