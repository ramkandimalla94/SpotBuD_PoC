import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/workout.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:spotbud/viewmodels/exercise_viewmodel.dart';

class ExerciseAnalyticsScreen extends StatefulWidget {
  @override
  _ExerciseAnalyticsScreenState createState() =>
      _ExerciseAnalyticsScreenState();
}

class _ExerciseAnalyticsScreenState extends State<ExerciseAnalyticsScreen> {
  final WorkoutController workoutController = Get.put(WorkoutController());

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await workoutController.fetchWorkoutLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Analytics'),
      ),
      body: Obx(
        () {
          if (workoutController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return _buildContent();
          }
        },
      ),
    );
  }

  Widget _buildContent() {
    List<String> allExercises = workoutController.workouts
        .expand(
            (workout) => workout.exercises.map((exercise) => exercise.machine))
        .toSet()
        .toList();

    allExercises.sort();

    String selectedExercise = allExercises.isNotEmpty ? allExercises.first : '';

    return SingleChildScrollView(
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
              setState(() {
                selectedExercise = newValue!;
              });
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
        Text('Average Weight: ${averageWeight.toStringAsFixed(2)} kgs'),
        Text('Max Weight: ${maxWeight.toStringAsFixed(2)} kgs'),
      ],
    );
  }

  Widget _buildWeightChart(List<Workout> workouts) {
    List<double> weights = [];

    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        for (var set in exercise.sets) {
          double weight = double.tryParse(set.weight) ?? 0.0;
          weights.add(weight);
        }
      }
    }

    return Container(
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                weights.length,
                (index) => FlSpot(index.toDouble(), weights[index]),
              ),
              isCurved: true,
              //colors: [Colors.blue],
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          minX: 0,
          maxX: weights.length.toDouble(),
          minY: 0,
          maxY:
              weights.isNotEmpty ? weights.reduce((a, b) => a > b ? a : b) : 0,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 10,
          ),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}
