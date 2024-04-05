import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/body_part_view.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';

class WorkoutLoggingForm extends StatelessWidget {
  final WorkoutLoggingFormController controller =
      Get.put(WorkoutLoggingFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bluebackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.bluebackgroundColor,
        title: Text(
          'Log Workout',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveWorkout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Date: ${DateTimeUtils.getFormattedDate(DateTime.now())}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Start Time: ${DateTimeUtils.getFormattedTime(DateTime.now())}',
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Text(
                  'End Time: ${controller.endTime.value.isEmpty ? 'Not Set' : controller.endTime.value}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            buildWorkoutButton(
              text: 'Add Exercise',
              onPressed: () => _openBodyPartSelection(),
            ),
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Exercises:',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    for (var exercise in controller.exercises)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          exercise,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _saveWorkout() {
    if (controller.exercises.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one exercise before saving.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.black,
        colorText: Colors.white,
      );
      return;
    }
    // Save workout logic here
    Get.snackbar(
      'Success',
      'Workout saved successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.blue,
      colorText: Colors.white,
    );
    // Reset the form
    controller.reset();
  }

  void _openBodyPartSelection() {
    Get.bottomSheet(
      BodyPartSelectionScreen(),
      backgroundColor: Colors.transparent,
    );
  }
}

class WorkoutLoggingFormController extends GetxController {
  var exercises = <String>[].obs;
  var endTime = ''.obs;

  void addExercise(String exercise) {
    exercises.add(exercise);
  }

  void setEndTime(String time) {
    endTime.value = time;
  }

  void reset() {
    exercises.clear();
    endTime.value = '';
  }
}
