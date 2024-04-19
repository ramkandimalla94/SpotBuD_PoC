import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/workout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

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
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.acccentColor),
        title: Text(
          'Exercise Analytics',
          style: TextStyle(color: AppColors.acccentColor),
        ),
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
        Text(
          'Analytics for $selectedExercise:',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            _buildAnalyticsItem('Total Sets', totalSets.toString()),
            Spacer(),
            _buildAnalyticsItem('Total Reps', totalReps.toString()),
            Spacer(),
            _buildAnalyticsItem(
                'Average Weight', '${averageWeight.toStringAsFixed(2)} kgs'),
          ],
        ),
        Row(
          children: [
            _buildAnalyticsItem(
                'Max Weight', '${maxWeight.toStringAsFixed(2)} kgs'),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
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
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChart(List<Workout> workouts) {
    Map<DateTime, List<double>> weightData = {};

    // Group weights by date
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        for (var set in exercise.sets) {
          DateTime date = DateTime.parse(workout.date);
          double weight = double.tryParse(set.weight) ?? 0.0;

          if (!weightData.containsKey(date)) {
            weightData[date] = [];
          }
          weightData[date]!.add(weight);
        }
      }
    }

    // Sort weight data by date
    weightData.forEach((date, weights) {
      weights.sort();
    });

    // Define bar chart data
    List<BarChartGroupData> barChartGroups = [];
    weightData.forEach((date, weights) {
      double sum = weights.isNotEmpty ? weights.reduce((a, b) => a + b) : 0.0;
      barChartGroups.add(
        BarChartGroupData(
          x: date.day.toInt(),
          barRods: weights
              .map((weight) => BarChartRodData(toY: weight, color: Colors.blue))
              .toList(),
          showingTooltipIndicators: weights.map((_) => 0).toList(),
        ),
      );
    });

    return Container(
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: weightData.values
                        .expand((weights) => weights)
                        .reduce((a, b) => a > b ? a : b) +
                    10, // Add some padding to the y-axis
                groupsSpace: 12,
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false), // Remove grid lines
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    //tooltipBgColor: Colors
                    //  .transparent, // Set background color to transparent
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      if (isShowingTooltip && touchedIndex == groupIndex) {
                        String weight =
                            "${rod.toY.toInt()}"; // Get the weight of the bar
                        return BarTooltipItem(
                          weight,
                          TextStyle(color: Colors.white),
                        );
                      } else {
                        return BarTooltipItem(
                            "",
                            TextStyle(
                                color: Colors
                                    .transparent)); // Return empty tooltip item
                      }
                    },
                  ),
                  touchCallback:
                      (FlTouchEvent event, BarTouchResponse? barTouchResponse) {
                    setState(() {
                      if (barTouchResponse != null &&
                          event is! PointerUpEvent &&
                          event is! PointerCancelEvent) {
                        isShowingTooltip = true;
                        touchedIndex =
                            barTouchResponse.spot!.touchedBarGroupIndex;
                      } else {
                        isShowingTooltip = false;
                        touchedIndex = -1;
                      }
                    });
                  },
                ),

                barGroups: barChartGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
