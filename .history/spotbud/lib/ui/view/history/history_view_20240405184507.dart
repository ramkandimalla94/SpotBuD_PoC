import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: userDataViewModel.fetchWorkoutHistory(),
        builder: (context,
            AsyncSnapshot<Map<String, List<Map<String, dynamic>>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final workoutHistory = snapshot.data!;
            return ListView.builder(
              itemCount: workoutHistory.length,
              itemBuilder: (context, index) {
                final date = workoutHistory.keys.elementAt(index);
                final workouts = workoutHistory[date]!;
                return ExpansionTile(
                  title: Text(date),
                  children: _buildWorkouts(workouts),
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

  List<Widget> _buildWorkouts(List<Map<String, dynamic>> workouts) {
    return workouts.map((workout) {
      final startTimeTimestamp = workout['starttime'] as Timestamp?;
      final startTime = startTimeTimestamp != null
          ? startTimeTimestamp.toDate()
          : DateTime.now();
      final endTimeTimestamp = workout['endtime'] as Timestamp?;
      final endTime =
          endTimeTimestamp != null ? endTimeTimestamp.toDate() : DateTime.now();

      return ListTile(
        title: Text('Start Time: $startTime | End Time: $endTime'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Body Part Exercises:'),
            ..._buildBodyPartSegments(workout['bodypart']),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildBodyPartSegments(List<Map<String, dynamic>> bodyParts) {
    return bodyParts.map((bodyPart) {
      final exercises = bodyPart['exercise'] as List<Map<String, dynamic>>;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: exercises.map<Widget>((exercise) {
          final name = exercise['exercisename'] as String;
          final sets = exercise['sets'] as List<Map<String, dynamic>>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Exercise: $name'),
              ...sets.map((set) {
                final reps = set['reps'] as String;
                final weight = set['weight'] as String;
                final notes = set['notes'] as String;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reps: $reps, Weight: $weight, Notes: $notes'),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        }).toList(),
      );
    }).toList();
  }
}
