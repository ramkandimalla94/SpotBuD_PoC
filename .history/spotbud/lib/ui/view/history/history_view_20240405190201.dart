import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';

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
            return Center(child: LoadingIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final workoutHistory = snapshot.data!;
            return ListView.builder(
              itemCount: workoutHistory.length,
              itemBuilder: (context, index) {
                final date = workoutHistory.keys.toList()[index];
                final workouts = workoutHistory[date]!;

                return ExpansionTile(
                  title: ListTile(
                    title: Text(date),
                  ),
                  children: _buildWorkoutDetails(workouts),
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

  // Remaining code...
}

List<Widget> _buildWorkoutDetails(List<Map<String, dynamic>> workouts) {
  return workouts.map((workout) {
    final startTimeTimestamp = workout['starttime'] as Timestamp?;
    final endTimeTimestamp = workout['endtime'] as Timestamp?;
    final startTime = startTimeTimestamp != null
        ? DateFormat('HH:mm').format(startTimeTimestamp.toDate())
        : 'Unknown';
    final endTime = endTimeTimestamp != null
        ? DateFormat('HH:mm').format(endTimeTimestamp.toDate())
        : 'Unknown';

    return ListTile(
      title: Text('Start Time: $startTime'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('End Time: $endTime'),
          SizedBox(height: 8),
          Text('Body Part Exercises:'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildBodyPartSegments(workout['bodypart']),
          ),
        ],
      ),
    );
  }).toList();
}

List<Widget> _buildBodyPartSegments(
    List<Map<String, dynamic>> bodyPartExercises) {
  return bodyPartExercises.map((exercise) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          exercise['bodypart'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Exercise: ${exercise['exercisename']}'),
          Text('Sets: ${exercise['sets']}'),
        ],
      ),
    );
  }).toList();
}
