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
      body: FutureBuilder(
        future: userDataViewModel.fetchWorkoutHistory(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
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
                final startTime =
                    (workout['starttime'] as Timestamp).toDate();
                final endTime = (workout['endtime'] as Timestamp).toDate();
                final bodyPartExercises = workout['bodypart'] as List<dynamic>;

                return ListTile(
                  title: Text('Workout #$index'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Time: $startTime'),
                      Text('End Time: $endTime'),
                      SizedBox(height: 8),
                      Text('Body Part Exercises:'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: bodyPartExercises
                            .map<Widget>((bodyPartExercise) {
                          final bodyPart = bodyPartExercise['bodypart'];
                          final exercises = bodyPartExercise['exercise']
                              as List<dynamic>;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$bodyPart Exercises:'),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: exercises
                                    .map<Widget>((exercise) {
                                      final exerciseName = exercise['exercisename'];
                                      final sets = exercise['sets'] as List<dynamic>;

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('$exerciseName Sets:'),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: sets
                                                .map<Widget>((set) {
                                                  final setNumber = set['set'];
                                                  final reps = set['reps'];
                                                  final weight = set['weight'];
                                                  final notes = set['notes'];

                                                  return ListTile(
                                                    title: Text('Set $setNumber'),
                                                    subtitle: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('Reps: $reps'),
                                                        Text('Weight: $weight'),
                                                        Text('Notes: $notes'),
                                                      ],
                                                    ),
                                                  );
                                                })
                                                .toList(),
                                          ),
                                        ],
                                      );
                                    })
                                    .toList(),
                              ),
                            ],
                          );
                        })
                        .toList(),
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
