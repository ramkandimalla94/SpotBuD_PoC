import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/ui/view/main_screen/pedometer_controller.dart';
import 'package:spotbud/ui/view/workout_logging/exercise_selection/body.dart';
import 'package:spotbud/ui/view/workout_logging/work_out_form.dart';
import 'package:spotbud/ui/view/workout_analytics/workout_analytics.dart';
import 'package:spotbud/ui/view/onboarding/role.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/step_counter_data.dart';
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
  late Timer _timer;
  late String gifPath = '';
  final PedometerController _pedometerController =
      Get.put(PedometerController());

  final UserDataViewModel _userDataViewModel = Get.put(UserDataViewModel());

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _nameViewModel.fetchUserNames();
    updateDateTime();
    // Update time every minute
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      updateDateTime();
    });
  }

  Future<void> _fetchUserData() async {
    await _userDataViewModel.fetchUserData();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  void updateDateTime() {
    // Get current time
    final now = DateTime.now();
    final hour = now.hour;

    // Set greeting based on current hour
    if (hour < 12 && hour > 5) {
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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
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
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                Spacer(),
                Image.asset(
                  gifPath,
                  height: 100, // Adjust height as needed
                  width: 100, // Adjust width as needed
                ),
                SizedBox(width: 20),
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Date: ${DateFormat('MMMM d, y').format(DateTime.now())}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
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
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //   child: Center(
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: <Widget>[
            //         // Obx(() =>
            //         //     Text('Steps taken: ${_pedometerController.steps.value}')),
            //         Obx(
            //           () => Text(
            //               'Daily steps: ${_pedometerController.dailySteps.value}'),
            //         ),
            //         Spacer(),
            //         Obx(() => Text(
            //             'Pedestrian status: ${_pedometerController.status.value}')),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
            customHomeButton(
                text: "Log Workout",
                onPressed: () {
                  Get.toNamed('/logworkout');
                },
                theme: Theme.of(context),
                imagePath: AppAssets.dumble),

            SizedBox(
              height: 20,
            ),
            // customHomeButton(
            //     text: "Step Counter",
            //     onPressed: () {
            //       Get.to(DailyStepRecords());
            //     },
            //     theme: Theme.of(context),
            //     imagePath: AppAssets.dumble),
            // SizedBox(
            //   height: 20,
            // ),

            customHomeButton(
                text: "History",
                onPressed: () {
                  Get.toNamed('/history');
                },
                theme: Theme.of(context),
                imagePath: AppAssets.history),
            const SizedBox(
              height: 20,
            ),
            customHomeButton(
                text: "Progress Tracker",
                onPressed: () {
                  Get.to(ExerciseAnalyticsScreen());
                },
                theme: Theme.of(context),
                imagePath: AppAssets.progress),
            SizedBox(
              height: 20,
            ),
            // Add some space between buttons and logo
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom: 20),
            //     child: Image.asset(
            //       AppAssets.logogolden,
            //       width: 150,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
//kw8P0jjOrMTa9RxKsXHkE6xcHJc2