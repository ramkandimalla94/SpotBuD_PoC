// history_page_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class HistoryPageView extends StatelessWidget {
  final UserDataViewModel _userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bluebackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.bluebackgroundColor,
        iconTheme: IconThemeData(color: AppColors.acccentColor),
        title: Text(
          'Workout History',
          style: TextStyle(
            color: AppColors.acccentColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: GetBuilder<UserDataViewModel>(
        builder: (controller) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.hasError) {
            return Center(child: Text('Error: ${controller.errorMessage}'));
          } else {
            return ListView.builder(
              itemCount: controller.workoutHistory.length,
              itemBuilder: (context, index) {
                final workout = controller.workoutHistory[index];
                final formattedDate =
                    DateFormat.yMMMd().format(workout['timestamp'].toDate());
                final bodyPart = workout['bodyPart'];
                final machine = workout['machine'];
                final sets = workout['sets'] as List<Map<String, dynamic>>;
                return ExpansionTile(
                  title: Text(
                    formattedDate,
                    style: TextStyle(
                      color: AppColors.acccentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.acccentColor,
                  ),
                  children: _buildBodyPartSegments(sets),
                );
              },
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildBodyPartSegments(List<Map<String, dynamic>> sets) {
    return sets.map((set) {
      return ListTile(
        title: Text(
          'Reps: ${set['reps']}, Weight: ${set['weight']}, Notes: ${set['notes']}',
          style: TextStyle(
            color: AppColors.acccentColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }).toList();
  }
}
