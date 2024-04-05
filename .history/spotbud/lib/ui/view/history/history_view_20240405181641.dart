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
      body: FutureBuilder<List<Map<String, dynamic>>>(
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

                return ListTile(
                  title: Text('Workout #$index'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Time: $startTime'),
                      SizedBox(height: 8),
                      Text('Body Part Exercises:'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
                      ),
                    ],
                  ),
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
