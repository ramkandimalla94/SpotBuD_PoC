import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/workout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';

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

  bool isShowingTooltip = false;
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bluebackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.bluebackgroundColor,
        iconTheme: IconThemeData(color: AppColors.acccentColor),
        title: Text(
          'Exercise Analytics',
          style: TextStyle(color: AppColors.acccentColor),
        ),
      ),
      body: Obx(
        () {
          if (workoutController.isLoading.value) {
            return Center(child: LoadingIndicator());
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
          Row(
            children: [
              Text(
                'Select an Exercise:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: AppColors.acccentColor),
              ),
              SizedBox(width: 20.0),
              DropdownButton<String>(
                dropdownColor: AppColors.acccentColor,
                value: selectedExercise,
                onChanged: (newValue) {
                  setState(() {
                    selectedExercise = newValue!;
                  });
                },
                items: allExercises.map<DropdownMenuItem<String>>((exercise) {
                  return DropdownMenuItem<String>(
                    value: exercise,
                    child: Text(
                      exercise,
                      style: TextStyle(color: AppColors.backgroundColor),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          if (selectedExercise.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildExerciseAnalytics(selectedExercise),
                      SizedBox(height: 16.0),
                      _buildWeightChart(workouts),
                    ],
                  ),
                ),
                SizedBox(width: 20.0),
                DropdownButton<String>(
                  dropdownColor: AppColors.acccentColor,
                  value: selectedOption,
                  onChanged: (newValue) {
                    setState(() {
                      selectedOption = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'Min Weight',
                      child: Text('Min Weight'),
                    ),
                    DropdownMenuItem(
                      value: 'Max Weight',
                      child: Text('Max Weight'),
                    ),
                    DropdownMenuItem(
                      value: 'Average Weight',
                      child: Text('Average Weight'),
                    ),
                  ],
                ),
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
        Text(
          'Analytics for $selectedExercise:',
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: AppColors.acccentColor),
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            _buildAnalyticsItem('Total Sets', totalSets.toString()),
            SizedBox.square(
              dimension: 20,
            ),
            _buildAnalyticsItem('Total Reps', totalReps.toString()),
            Spacer()
          ],
        ),
        Row(
          children: [
            _buildAnalyticsItem(
                'Average Weight', '${averageWeight.toStringAsFixed(2)} kgs'),
            SizedBox.square(
              dimension: 20,
            ),
            _buildAnalyticsItem(
                'Max Weight', '${maxWeight.toStringAsFixed(2)} kgs'),
            Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsItem(String title, String value) {
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.acccentColor),
          ),
          SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(fontSize: 14.0, color: AppColors.backgroundColor),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChart(List<Workout> workouts) {
    Map<DateTime, List<double>> weightData = {};

    // Iterate over each workout
    for (var workout in workouts) {
      // Convert workout date string to DateTime
      DateTime date = DateTime.parse(workout.date);

      // Initialize list for weights of this workout
      List<double> weights = [];

      // Iterate over each exercise in the workout
      for (var exercise in workout.exercises) {
        // Iterate over each set in the exercise
        for (var set in exercise.sets) {
          // Convert set weight string to double
          double weight = double.tryParse(set.weight) ?? 0.0;
          weights.add(weight); // Add weight to list
        }
      }

      // Add weights of this workout to weightData map
      weightData[date] = weights;
    }

    // Define line chart data
    List<FlSpot> lineChartSpots = [];

    // Iterate over each date in weightData
    weightData.forEach((date, weights) {
      double sum = weights.isNotEmpty ? weights.reduce((a, b) => a + b) : 0.0;
      double averageWeight = sum / weights.length;
      lineChartSpots.add(FlSpot(date.day.toDouble(), averageWeight));
    });

    return Container(
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: lineChartSpots,
              isCurved: true,
              color: AppColors.acccentColor,
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
          ],
          minY: 0,
          maxY: weightData.values
                  .expand((weights) => weights)
                  .reduce((a, b) => a > b ? a : b) +
              10, // Add some padding to the y-axis
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, titleMeta) {
                  // Your custom widget for left axis titles
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, titleMeta) {
                  // Your custom widget for bottom axis titles
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false), // Remove grid lines
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.white, width: 1),
          ),
          backgroundColor: AppColors.primaryColor,
        ),
      ),
    );
  }
}
