import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';

import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class HistoryPage extends StatelessWidget {
  final UserDataViewModel _userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bluebackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.bluebackgroundColor,
        title: Text(
          'Workout History ',
          style: AppTheme.primaryText(
              fontWeight: FontWeight.w500, color: AppColors.black),
        ),
      ),
      body: FutureBuilder(
        future: _userDataViewModel.fetchWorkoutHistory(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Sort workout history by date
            snapshot.data!
                .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

            // Group workout history by date
            Map<DateTime, List<Map<String, dynamic>>> groupedByDate = {};
            snapshot.data!.forEach((workout) {
              DateTime date = workout['timestamp'].toDate();
              DateTime formattedDate =
                  DateTime(date.year, date.month, date.day);
              if (groupedByDate.containsKey(formattedDate)) {
                groupedByDate[formattedDate]!.add(workout);
              } else {
                groupedByDate[formattedDate] = [workout];
              }
            });

            return ListView(
              children: groupedByDate.entries.map((entry) {
                return ExpansionTile(
                  title: Text(
                    DateFormat.yMMMd().format(entry.key),
                    style: AppTheme.primaryText(
                        color: AppColors.acccentColor,
                        fontWeight: FontWeight.w500,
                        size: 25),
                  ),
                  children: _buildBodyPartSegments(entry.value),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildBodyPartSegments(List<Map<String, dynamic>> workouts) {
    Set<String> bodyParts = Set<String>();
    workouts.forEach((workout) {
      bodyParts.add(workout['bodyPart']);
    });

    return bodyParts.map((bodyPart) {
      List<Map<String, dynamic>> filteredWorkouts =
          workouts.where((workout) => workout['bodyPart'] == bodyPart).toList();

      return ExpansionTile(
        title: Text(bodyPart),
        children: filteredWorkouts.map((workout) {
          return ListTile(
            title: Text(workout['machine']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: workout['sets'].map<Widget>((set) {
                return Text(
                    'Reps: ${set['reps']}, Weight: ${set['weight']}, Notes: ${set['notes']}');
              }).toList(),
            ),
          );
        }).toList(),
      );
    }).toList();
  }
}
