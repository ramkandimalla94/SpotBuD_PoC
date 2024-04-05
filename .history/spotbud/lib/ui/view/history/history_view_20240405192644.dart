import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class HistoryView extends StatelessWidget {
  final UserDataViewModel userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: userDataViewModel.fetchWorkoutHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final workoutHistory = snapshot.data!;
            return ListView.builder(
              itemCount: workoutHistory.length,
              itemBuilder: (context, index) {
                final workout = workoutHistory[index];
                final date = workout['date'] as String;
                final startTime = workout['startTime'] as String;
                final endTime = workout['endTime'] as String;
                final exercises =
                    workout['exercises'] as List<Map<String, dynamic>>;

                return ExpansionTile(
                  title: ListTile(
                    title: Text('Date: $date'),
                    subtitle:
                        Text('Start Time: $startTime | End Time: $endTime'),
                  ),
                  children: _buildExerciseDetails(exercises),
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

  List<Widget> _buildExerciseDetails(List<Map<String, dynamic>> exercises) {
    return exercises.map((exercise) {
      final exerciseName = exercise['name'] as String;
      final sets = exercise['sets'] as List<Map<String, dynamic>>;

      return ListTile(
        title: Text(exerciseName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sets.map((set) {
            final reps = set['reps'] as String;
            final weight = set['weight'] as String;
            final notes = set['notes'] as String;
            return Text('Reps: $reps | Weight: $weight | Notes: $notes');
          }).toList(),
        ),
      );
    }).toList();
  }
}
