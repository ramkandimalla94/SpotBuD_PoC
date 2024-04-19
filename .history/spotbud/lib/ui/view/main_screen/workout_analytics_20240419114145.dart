import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/workout.dart';
import 'package:spotbud/viewmodels/exercise_viewmodel.dart';

class ExerciseAnalyticsScreen extends StatelessWidget {
  final WorkoutController workoutController = Get.put(WorkoutController());

  @override
  Widget build(BuildContext context) {
    // Fetch all exercises ever logged by the user
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
              _buildExerciseAnalytics(selectedExercise),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseAnalytics(String selectedExercise) {
    // Filter workouts for the selected exercise
    List<Workout> filteredWorkouts =
        workoutController.workouts.where((workout) {
      return workout.exercises
          .any((exercise) => exercise.machine == selectedExercise);
    }).toList();

    // Calculate total sets and reps
    int totalSets = 0;
    int totalReps = 0;
    double totalWeight = 0.0;
    double maxWeight = 0.0;

    // Iterate through filtered workouts
    for (var workout in filteredWorkouts) {
      for (var exercise in workout.exercises) {
        if (exercise.machine == selectedExercise) {
          for (var set in exercise.sets) {
            // Parse reps and weight to integers or doubles
            int reps = int.tryParse(set.reps) ?? 0;
            double weight = double.tryParse(set.weight) ?? 0.0;

            totalSets++;
            totalReps += reps;
            totalWeight += weight;

            // Compare weight with maxWeight
            if (weight > maxWeight) {
              maxWeight = weight;
            }
          }
        }
      }
    }

    // Calculate average weight
    double averageWeight = totalSets > 0 ? totalWeight / totalSets : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Analytics for $selectedExercise:'),
        SizedBox(height: 8.0),
        Text('Total Sets: $totalSets'),
        Text('Total Reps: $totalReps'),
        Text('Average Weight: ${averageWeight.toStringAsFixed(2)}'),
        Text('Max Weight: ${maxWeight.toStringAsFixed(2)}'),
        // Add more analytics widgets here
      ],
    );
  }
}
