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
  late String gifPath = '';

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

    // Set greeting based on current hour
    if (hour < 12) {
      greeting = 'Good\nMorning!';
      gifPath = AppAssets.morning;
    } else if (hour < 17) {
      greeting = 'Good\nAfternoon!';
      gifPath = AppAssets.afternoon;
    } else {
      greeting = 'Good\nEvening!';
      gifPath = AppAssets.evening;
    }

    final timeFormat = DateFormat('hh:mm a');
    setState(() {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    greeting,
                    style: AppTheme.primaryText(
                        size: 40.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.backgroundColor),
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    Image.asset(
                      gifPath,
                      height: 100, // Adjust height as needed
                      width: 100, // Adjust width as needed
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Date: ${DateFormat('MMMM d, y').format(DateTime.now())}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Time: $currentTime',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
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
              height: 10,
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
          ],
        ),
      ),
    );
  }
}
