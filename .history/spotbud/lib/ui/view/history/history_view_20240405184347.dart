import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class HistoryView extends StatelessWidget {
  final UserDataViewModel userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
      ),
      body: FutureBuilder(
        future: userDataViewModel.fetchWorkoutHistory(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<Map<String, dynamic>> workoutHistory = snapshot.data!;
            final List<DateTime> dates = workoutHistory
                .map((workout) => workout['timestamp'] as DateTime)
                .toList();
            return ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, index) {
                final DateTime date = dates[index];
                final List<Map<String, dynamic>> workoutsOnDate = workoutHistory
                    .where((workout) =>
                        workout['timestamp']?.toDate().day == date.day)
                    .toList();
                return ExpansionTile(
                  title: Text(DateFormat.yMMMMd().format(date)), // Format date
                  children: _buildWorkoutsList(workoutsOnDate),
                );
              },
            );
          } else {
            return Center(child: Text('No workout history available'));
          }
        },
      ),
    );
  }

  List<Widget> _buildWorkoutsList(List<Map<String, dynamic>> workouts) {
    return workouts.map((workout) {
      final DateTime startTime = workout['timestamp']?.toDate();
      final DateTime endTime = workout['endTime']?.toDate();
      final List<Map<String, dynamic>> exercises = workout['exercises'] ?? [];
      return ListTile(
        title: Text(
          'Start Time: ${DateFormat.Hm().format(startTime)} - End Time: ${DateFormat.Hm().format(endTime)}',
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: exercises.map((exercise) {
            final String bodyPart = exercise['bodyPart'];
            final String exerciseName = exercise['exerciseName'];
            final List<Map<String, dynamic>> sets = exercise['sets'] ?? [];
            final String setsInfo = sets
                .map((set) =>
                    'Reps: ${set['reps']}, Weight: ${set['weight']}, Notes: ${set['notes']}')
                .join('\n');
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Body Part: $bodyPart, Exercise: $exerciseName',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(setsInfo),
              ],
            );
          }).toList(),
        ),
      );
    }).toList();
  }
}
