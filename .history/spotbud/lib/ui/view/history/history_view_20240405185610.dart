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
                final startTimeTimestamp = workout['timestamp'] as Timestamp?;
                final startTime = startTimeTimestamp != null
                    ? startTimeTimestamp.toDate()
                    : DateTime.now();

                return ExpansionTile(
                  title:
                      Text('Workout #${index + 1} - ${startTime.toString()}'),
                  children: [
                    // Your expansion tile content here
                    // Use workout data to display workout details
                  ],
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
}
