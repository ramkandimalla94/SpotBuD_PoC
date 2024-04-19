import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/workout.dart';
import 'package:flutter_chart/flutter_chart.dart';

import 'package:spotbud/viewmodels/exercise_viewmodel.dart';

class ExerciseAnalyticsScreen extends StatelessWidget {
  final WorkoutController workoutController = Get.put(WorkoutController());

  @override
  Widget build(BuildContext context) {
    List<String> allExercises = workoutController.workouts
        .expand(
            (workout) => workout.exercises.map((exercise) => exercise.machine))
        .toSet()
        .toList();

    // Sort the exercises alphabetically
    allExercises.sort();

    // Define the selected exercise variable
    String selectedExercise = allExercises.isNotEmpty ? allExercises.first : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Analytics'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select an Exercise:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButton<String>(
              value: selectedExercise,
              onChanged: (newValue) {
                // Update the selected exercise
                selectedExercise = newValue!;
              },
              items: allExercises.map<DropdownMenuItem<String>>((exercise) {
                return DropdownMenuItem<String>(
                  value: exercise,
                  child: Text(exercise),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            if (selectedExercise.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildExerciseAnalytics(selectedExercise),
                  SizedBox(height: 16.0),
                  _buildWeightChart(workoutController.workouts),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseAnalytics(String selectedExercise) {
    List<Workout> filteredWorkouts =
        workoutController.workouts.where((workout) {
      return workout.exercises
          .any((exercise) => exercise.machine == selectedExercise);
    }).toList();

    int totalSets = 0;
    int totalReps = 0;
    double totalWeight = 0.0;
    double maxWeight = 0.0;

    for (var workout in filteredWorkouts) {
      for (var exercise in workout.exercises) {
        if (exercise.machine == selectedExercise) {
          for (var set in exercise.sets) {
            int reps = int.tryParse(set.reps) ?? 0;
            double weight = double.tryParse(set.weight) ?? 0.0;

            totalSets++;
            totalReps += reps;
            totalWeight += weight;

            if (weight > maxWeight) {
              maxWeight = weight;
            }
          }
        }
      }
    }

    double averageWeight = totalSets > 0 ? totalWeight / totalSets : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Analytics for $selectedExercise:'),
        SizedBox(height: 8.0),
        Text('Total Sets: $totalSets'),
        Text('Total Reps: $totalReps'),
        Text('Average Weight: ${averageWeight.toStringAsFixed(2)} kgs'),
        Text('Max Weight: ${maxWeight.toStringAsFixed(2)} kgs'),
      ],
    );
  }

  Widget _buildWeightChart(List<Workout> workouts) {
    List<double> weights = [];
    List<String> dates = [];

    // Extract weights and dates from workouts
    workouts.forEach((workout) {
      workout.exercises.forEach((exercise) {
        exercise.sets.forEach((set) {
          weights.add(double.tryParse(set.weight) ?? 0.0);
          dates.add(workout
              .date); // Assuming there's a date property in the Workout model
        });
      });
    });

    // Create data series
    var series = [
      LineSeries(
        data: weights,
        colorFn: (_, __) => Colors.blue, // Color of the line
      ),
    ];

    // Create chart
    return LineChart(
      series,
      labels: dates,
    );
  }
}
