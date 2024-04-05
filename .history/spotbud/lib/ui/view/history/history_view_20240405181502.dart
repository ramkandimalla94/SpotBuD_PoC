import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class HistoryView extends StatelessWidget {
  final UserDataViewModel userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
      ),
      body: Obx(() {
        final workoutHistory = userDataViewModel.fetchWorkoutHistory(
          startDate: userDataViewModel.startDate.value,
          endDate: userDataViewModel.endDate.value,
          bodyPart: userDataViewModel.bodyPart.value,
          exerciseName: userDataViewModel.exerciseName.value,
        );

        return workoutHistory == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: workoutHistory.length,
                itemBuilder: (context, index) {
                  // Build list item using workoutHistory
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show filter dialog
          _showFilterDialog(context);
        },
        child: Icon(Icons.filter_list),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter History'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fields for filters
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Apply filters
                userDataViewModel.updateFilters(
                  newStartDate: /* Get selected start date */,
                  newEndDate: /* Get selected end date */,
                  newBodyPart: /* Get selected body part */,
                  newExerciseName: /* Get selected exercise name */,
                );
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}
