import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  late String greeting = ''; // Initialize with empty string
  late String currentTime;

  @override
  void initState() {
    super.initState();
    _nameViewModel.fetchUserNames();
    updateDateTime();
    // Update time every minute
    Timer.periodic(Duration(minutes: 1), (timer) {
      updateDateTime();
    });
  }

  void updateDateTime() {
    // Get current time
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    final timeFormat = DateFormat('hh:mm a');
    final dateFormat = DateFormat('MMMM d, y');
    setState(() {
      // Set greeting based on current hour
      if (hour < 12) {
        greeting = 'Good Morning!';
      } else if (hour < 17) {
        greeting = 'Good Afternoon!';
      } else {
        greeting = 'Good Evening!';
      }
      // Set current time
      currentTime = timeFormat.format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                greeting,
                style: AppTheme.primaryText(
                    size: 32.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Obx(
                () {
                  final firstName = _nameViewModel.firstName.value;
                  final formattedName = firstName.isNotEmpty
                      ? '${firstName[0].toUpperCase()}${firstName.substring(1).toLowerCase()}'
                      : '';
                  return Text(
                    formattedName,
                    style: AppTheme.secondaryText(
                      size: 35.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.acccentColor,
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                customHomeButton(
                    text: "Log Workout",
                    onPressed: () {
                      Get.to(WorkoutLoggingForm());
                    },
                    icon: AppAssets.dumble),
                customHomeButton(
                    text: "History",
                    onPressed: () {
                      Get.toNamed('/history');
                    },
                    icon: AppAssets.history),
              ],
            ),
            Center(
              child: customHomeButton(
                  text: "Progress Tracker",
                  onPressed: () {},
                  icon: AppAssets.progress),
            ),
            SizedBox(height: 150), // Add some space between buttons and logo
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Current Date: ${DateFormat('MMMM d, y').format(DateTime.now())}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Current Time: $currentTime',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
