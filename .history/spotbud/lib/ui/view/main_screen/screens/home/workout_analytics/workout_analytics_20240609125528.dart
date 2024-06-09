import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/core/models/workout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:spotbud/viewmodels/exercise_viewmodel.dart';

class ExerciseAnalyticsScreen extends StatefulWidget {
  @override
  _ExerciseAnalyticsScreenState createState() =>
      _ExerciseAnalyticsScreenState();
}

class _ExerciseAnalyticsScreenState extends State<ExerciseAnalyticsScreen> {
  final WorkoutController workoutController = Get.put(WorkoutController());
  bool showLineChart = true;
  String selectedOption = 'Average Weight';
  String selectedExercise = ''; // Initialize selectedExercise
  late DateTime _focusedDay = DateTime.now();
  String selectedBodyPart = 'Overall';
  bool _isKgsPreferred = true;

  late DateTime _selectedDay;
  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _fetchData();
    _checkWeightPreference();
  }

  Future<void> _checkWeightPreference() async {
    // Fetch user's weight preference from UserViewModel using Get.find()
    final userDataViewModel = Get.find<UserDataViewModel>();
    _isKgsPreferred = userDataViewModel.isKgsPreferred.value;
  }

  String _convertWeight(String? weight) {
    if (_isKgsPreferred) {
      // If preferred weight unit is kilograms, return weight as it is
      return '$weight';
    } else {
      // Convert weight from kilograms to pounds
      final double? kg = double.tryParse(weight ?? '');
      if (kg != null) {
        final double lbs = kg * 2.20462;
        return lbs.toStringAsFixed(2);
      } else {
        return 'N/A';
      }
    }
  }

  String _preferdunit() {
    if (_isKgsPreferred) {
      // If preferred weight unit is kilograms, return weight as it is
      return 'kgs';
    } else {
      // Convert weight from kilograms to pounds

      return 'lbs';
    }
  }

  Future<void> _fetchData() async {
    await workoutController.fetchWorkoutLogs();
    // Set selectedExercise to the first exercise if available
    if (workoutController.workouts.isNotEmpty) {
      setState(() {
        selectedExercise = workoutController.workouts
            .expand((workout) =>
                workout.exercises.map((exercise) => exercise.machine))
            .toSet()
            .toList()[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: Text(
          'Exercise Analytics',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Obx(
        () {
          if (workoutController.isLoading.value) {
            return const Center(child: LoadingIndicator());
          } else {
            return _buildContent();
          }
        },
      ),
    );
  }

  Widget _buildContent() {
    int currentStreak = _calculateCurrentStreak();
    int longestStreak = _calculateLongestStreak();
    List<String> allExercises = workoutController.workouts
        .expand(
            (workout) => workout.exercises.map((exercise) => exercise.machine))
        .toSet()
        .toList();

    allExercises.sort();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeatMap(),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              _buildAnalyticsItem('Current Streak', '${currentStreak} 🔥'),
              SizedBox.square(
                dimension: 20,
              ),
              _buildAnalyticsItem("Longest Streak ", '${longestStreak} 🔥')
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Row(
            children: [
              Spacer(),
              const SizedBox(width: 20.0),
              DropdownButton<String>(
                dropdownColor: Theme.of(context).colorScheme.background,
                value: selectedTimePeriod,
                onChanged: (newValue) {
                  setState(() {
                    selectedTimePeriod = newValue!;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'All Time',
                    child: Text(
                      'All Time',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Last Week',
                    child: Text(
                      'Last Week',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Last Month',
                    child: Text(
                      'Last Month',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Last 3 Months',
                    child: Text(
                      'Last 3 Months',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Last 6 Months',
                    child: Text(
                      'Last 6 Months',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Last Year',
                    child: Text(
                      'Last Year',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Select Body Part:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 20.0),
              DropdownButton<String>(
                dropdownColor: Theme.of(context).colorScheme.background,
                value: selectedBodyPart,
                onChanged: (newValue) {
                  setState(() {
                    selectedBodyPart = newValue!;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'Overall',
                    child: Text(
                      'Overall',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ), // Include Overall option
                  ...workoutController.workouts
                      .expand((workout) => workout.exercises
                          .map((exercise) => exercise.bodyPart))
                      .toSet() // Convert to set to remove duplicates
                      .toList() // Convert back to list
                      .map<DropdownMenuItem<String>>((bodyPart) {
                    return DropdownMenuItem<String>(
                      value: bodyPart,
                      child: Text(
                        bodyPart,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    );
                  }).toList(),
                ],
              ),
              const Spacer(),
            ],
          ),
          _buildPieChart(),
          Row(
            children: [
              Text(
                'Select an Exercise:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 20.0),
              DropdownButton<String>(
                dropdownColor: Theme.of(context).colorScheme.background,
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
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16.0),
          if (selectedExercise.isNotEmpty) ...[
            _buildExerciseAnalytics(selectedExercise),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showLineChart = true;
                      });
                    },
                    child: Text(
                      'Line Graph',
                      style: TextStyle(
                        color: showLineChart
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: showLineChart
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.background,
                        elevation: 10),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showLineChart = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: !showLineChart
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.background,
                        elevation: 10),
                    child: Text(
                      'Bar Chart',
                      style: TextStyle(
                        color: !showLineChart
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showLineChart) ...[
              Column(
                children: [
                  DropdownButton<String>(
                    dropdownColor: Theme.of(context).colorScheme.background,
                    value: selectedOption,
                    onChanged: (newValue) {
                      setState(() {
                        selectedOption = newValue!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'Min Weight',
                        child: Text(
                          'Min Weight',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Max Weight',
                        child: Text(
                          'Max Weight',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Average Weight',
                        child: Text(
                          'Average Weight',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ],
                  ),
                  _buildLineGraph(workoutController.workouts, selectedExercise,
                      selectedOption),
                ],
              ),
            ] else ...[
              _buildBarGraph(
                workoutController.workouts,
                selectedExercise,
              ),
            ],
          ],
        ],
      ),
    );
  }

  String selectedTimePeriod = 'All Time';
  int _calculateCurrentStreak() {
    int streak = 0;
    DateTime today = DateTime.now();
    // Iterate backwards from today until a workout is not logged
    for (int i = 0; i < 30; i++) {
      DateTime date = today.subtract(Duration(days: i));
      if (_isWorkoutLogged(date)) {
        streak++;
      } else {
        break; // Exit the loop if no workout is logged for the day
      }
    }
    return streak;
  }

  // Method to calculate the longest streak
  int _calculateLongestStreak() {
    int longestStreak = 0;
    int currentStreak = 0;
    DateTime today = DateTime.now();
    // Iterate backwards from today until a workout is not logged
    for (int i = 0; i < 365; i++) {
      DateTime date = today.subtract(Duration(days: i));
      if (_isWorkoutLogged(date)) {
        currentStreak++;
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      } else {
        currentStreak = 0; // Reset streak if no workout is logged
      }
    }
    return longestStreak;
  }

  Widget _buildExerciseAnalytics(String selectedExercise) {
    List<Workout> filteredWorkouts =
        workoutController.workouts.where((workout) {
      return workout.exercises
          .any((exercise) => exercise.machine == selectedExercise);
    }).toList();

    // Filter workouts based on the selected time period
    DateTime now = DateTime.now();
    switch (selectedTimePeriod) {
      case 'Last Week':
        filteredWorkouts = filteredWorkouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 7)));
        }).toList();
        break;
      case 'Last Month':
        filteredWorkouts = filteredWorkouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 30)));
        }).toList();
        break;
      case 'Last 3 Months':
        filteredWorkouts = filteredWorkouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 90)));
        }).toList();
        break;
      case 'Last 6 Months':
        filteredWorkouts = filteredWorkouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 180)));
        }).toList();
        break;
      case 'Last Year':
        filteredWorkouts = filteredWorkouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 365)));
        }).toList();
        break;
      case 'All Time':
      default:
        // No filtering needed for 'Overall'
        break;
    }

    int totalSets = 0;
    int totalReps = 0;
    double totalWeight = 0.0;
    double maxWeight = 0.0;

    for (var workout in filteredWorkouts) {
      for (var exercise in workout.exercises) {
        if (exercise.machine == selectedExercise) {
          for (var set in exercise.sets) {
            int reps = int.tryParse(set.reps) ?? 0;
            double weight = double.tryParse(_convertWeight(set.weight)) ?? 0.0;

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
        Text(
          'Analytics for $selectedExercise:',
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            _buildAnalyticsItem('Total Sets', totalSets.toString()),
            const SizedBox.square(
              dimension: 20,
            ),
            _buildAnalyticsItem('Total Reps', totalReps.toString()),
            const Spacer()
          ],
        ),
        Row(
          children: [
            _buildAnalyticsItem('Average Weight',
                '${averageWeight.toStringAsFixed(2)} ' + _preferdunit()),
            const SizedBox.square(
              dimension: 20,
            ),
            _buildAnalyticsItem('Max Weight',
                '${maxWeight.toStringAsFixed(2)} ' + _preferdunit()),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
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
                color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
                fontSize: 14.0, color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }

  Widget _buildLineGraph(
      List<Workout> workouts, String selectedExercise, String selectedOption) {
    // Filter workouts based on the selected time period
    DateTime now = DateTime.now();
    switch (selectedTimePeriod) {
      case 'Last Week':
        workouts = workouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 7)));
        }).toList();
        break;
      case 'Last Month':
        workouts = workouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 30)));
        }).toList();
        break;
      case 'Last 3 Months':
        workouts = workouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 90)));
        }).toList();
        break;
      case 'Last 6 Months':
        workouts = workouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 180)));
        }).toList();
        break;
      case 'Last Year':
        workouts = workouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 365)));
        }).toList();
        break;
      case 'All Time':
      default:
        // No filtering needed for 'Overall'
        break;
    }

    Map<DateTime, List<double>> weightData = {};

    // Iterate over each workout
    for (var workout in workouts) {
      // Convert workout date string to DateTime
      DateTime date = DateTime.parse(workout.date);

      // Initialize list for weights of this workout
      List<double> weights = [];

      // Iterate over each exercise in the workout
      for (var exercise in workout.exercises) {
        if (exercise.machine == selectedExercise) {
          // Iterate over each set in the exercise
          for (var set in exercise.sets) {
            // Convert set weight string to double
            double weight = double.tryParse(_convertWeight(set.weight)) ?? 0.0;
            weights.add(weight); // Add weight to list
          }
        }
      }

      // Add weights of this workout to weightData map
      if (weights.isNotEmpty) {
        weightData[date] ??= []; // Initialize if not exist
        weightData[date]!.addAll(weights);
      }
    }

    // Define line chart data
    List<FlSpot> lineChartSpots = [];

    // Iterate over each date in weightData
    weightData.forEach((date, weights) {
      double value;
      switch (selectedOption) {
        case 'Min Weight':
          value = weights.reduce((a, b) => a < b ? a : b);
          break;
        case 'Max Weight':
          value = weights.reduce((a, b) => a > b ? a : b);
          break;
        case 'Average Weight':
        default:
          double sum = weights.reduce((a, b) => a + b);
          value = sum / weights.length;
      }
      value = double.parse(value.toStringAsFixed(2));
      lineChartSpots.add(FlSpot(date.millisecondsSinceEpoch.toDouble(), value));
    });

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 300,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: lineChartSpots,
                isCurved: false,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 2,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
            ],
            minX: weightData.isNotEmpty
                ? weightData.keys
                        .reduce((a, b) => a.isBefore(b) ? a : b)
                        .millisecondsSinceEpoch
                        .toDouble() -
                    86400000 // Subtract 1 day in milliseconds
                : 0,
            maxX: weightData.isNotEmpty
                ? weightData.keys
                        .reduce((a, b) => a.isAfter(b) ? a : b)
                        .millisecondsSinceEpoch
                        .toDouble() +
                    86400000 // Add 1 day in milliseconds
                : 0,
            minY: 0,
            maxY: weightData.isNotEmpty
                ? weightData.values
                        .expand((weights) => weights)
                        .reduce((a, b) => a > b ? a : b) +
                    10 // Add some padding to the y-axis
                : 0,
            titlesData: FlTitlesData(
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,

                    // reservedSize: 30,
                    getTitlesWidget: (value, titleMeta) {
                      // Your custom widget for left axis titles
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: value.toInt() > 99 ? 10 : 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, titleMeta) {
                      // Using getTitlesWidget to return custom widget for bottom axis titles
                      // Formatting the DateTime object to DD-MM-YYYY
                      DateTime date =
                          DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return Text(
                        DateFormat('dd').format(date),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false))),
            gridData: const FlGridData(
                show: true, drawHorizontalLine: false), // Remove grid lines
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
        ),
      ),
    );
  }

  Widget _buildBarGraph(List<Workout> workouts, String selectedExercise) {
    // Filter workouts for the selected exercise
    List<Workout> filteredWorkouts = workouts.where((workout) {
      return workout.exercises
          .any((exercise) => exercise.machine == selectedExercise);
    }).toList();

    // Filter workouts based on the selected time period
    DateTime now = DateTime.now();
    switch (selectedTimePeriod) {
      case 'Last Week':
        filteredWorkouts = filteredWorkouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 7)));
        }).toList();
        break;
      case 'Last Month':
        filteredWorkouts = filteredWorkouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 30)));
        }).toList();
        break;
      case 'Last 3 Months':
        filteredWorkouts = filteredWorkouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 90)));
        }).toList();
        break;
      case 'Last 6 Months':
        filteredWorkouts = filteredWorkouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 180)));
        }).toList();
        break;
      case 'Last Year':
        filteredWorkouts = filteredWorkouts.where((workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 365)));
        }).toList();
        break;
      case 'All Time':
      default:
        // No filtering needed for 'Overall'
        break;
    }

    // Map to hold workout sets grouped by date
    Map<DateTime, List<double>> dateWeightsMap = {};

    // Group weights by date
    for (var workout in filteredWorkouts) {
      DateTime date = DateTime.parse(workout.date);
      for (var exercise in workout.exercises) {
        if (exercise.machine == selectedExercise) {
          for (var set in exercise.sets) {
            double weight = double.tryParse(_convertWeight(set.weight)) ?? 0.0;
            dateWeightsMap[date] ??= [];
            dateWeightsMap[date]!.add(weight);
          }
        }
      }
    }

    // Sort the map by date
    var sortedDates = dateWeightsMap.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    // Create BarChartGroupData for each date
    List<BarChartGroupData> barChartGroups = sortedDates.map((date) {
      List<double> weights = dateWeightsMap[date]!;
      return BarChartGroupData(
        x: date
            .millisecondsSinceEpoch, // Using milliseconds since epoch as x value
        barRods: weights.map((weight) {
          return BarChartRodData(
            toY: weight, // Set y value directly instead of toY
            color: Theme.of(context).colorScheme.primary,
          );
        }).toList(),
      );
    }).toList();

    // Calculate maxY based on the maximum weight
    double maxY = barChartGroups.isNotEmpty
        ? dateWeightsMap.values
                .expand((weights) => weights)
                .reduce((a, b) => a > b ? a : b) +
            10
        : 10;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 300,
        child: Column(
          children: [
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: barChartGroups,
                  maxY: maxY,
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,

                        // reservedSize: 30,
                        getTitlesWidget: (value, titleMeta) {
                          // Your custom widget for left axis titles
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.5),
                            child: Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: value.toInt() > 99 ? 9 : 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, titleMeta) {
                          // Using getTitlesWidget to return custom widget for bottom axis titles
                          // Formatting the DateTime object to DD-MM-YYYY
                          DateTime date = DateTime.fromMillisecondsSinceEpoch(
                              value.toInt());
                          return Text(
                            DateFormat('dd-MM').format(date),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: true),
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, Map<String, int>> _calculateSetsByBodyPart() {
    Map<String, Map<String, int>> setsByBodyPart = {};

    for (var workout in workoutController.workouts) {
      for (var exercise in workout.exercises) {
        String bodyPart = exercise.bodyPart;
        String exerciseName = exercise.machine;
        int numSets = exercise.sets.length;

        // Initialize setsByBodyPart if not exist
        setsByBodyPart[bodyPart] ??= {};
        // Increment the count for the exercise
        setsByBodyPart[bodyPart]![exerciseName] =
            (setsByBodyPart[bodyPart]![exerciseName] ?? 0) + numSets;
      }
    }

    return setsByBodyPart;
  }

  Map<String, Map<String, int>> _filterSetsByBodyPart(
      Map<String, Map<String, int>> setsByBodyPart,
      bool Function(Workout) filter) {
    Map<String, Map<String, int>> filteredSetsByBodyPart = {};

    for (var workout in workoutController.workouts.where(filter).toList()) {
      for (var exercise in workout.exercises) {
        String bodyPart = exercise.bodyPart;
        String exerciseName = exercise.machine;
        int numSets = exercise.sets.length;

        // Initialize filteredSetsByBodyPart if not exist
        filteredSetsByBodyPart[bodyPart] ??= {};
        // Increment the count for the exercise
        filteredSetsByBodyPart[bodyPart]![exerciseName] =
            (filteredSetsByBodyPart[bodyPart]![exerciseName] ?? 0) + numSets;
      }
    }

    return filteredSetsByBodyPart;
  }

  Widget _buildPieChart() {
    Map<String, Map<String, int>> setsByBodyPart = _calculateSetsByBodyPart();

    // Filter setsByBodyPart based on the selected time period
    DateTime now = DateTime.now();
    switch (selectedTimePeriod) {
      case 'Last Week':
        setsByBodyPart = _filterSetsByBodyPart(setsByBodyPart, (workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 7)));
        });
        break;
      case 'Last Month':
        setsByBodyPart = _filterSetsByBodyPart(setsByBodyPart, (workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 30)));
        });
        break;
      case 'Last 3 Months':
        setsByBodyPart = _filterSetsByBodyPart(setsByBodyPart, (workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 90)));
        });
        break;
      case 'Last 6 Months':
        setsByBodyPart = _filterSetsByBodyPart(setsByBodyPart, (workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 180)));
        });
        break;
      case 'Last Year':
        setsByBodyPart = _filterSetsByBodyPart(setsByBodyPart, (workout) {
          DateTime workoutDate = DateTime.parse(workout.date);
          return workoutDate.isAfter(now.subtract(Duration(days: 365)));
        });
        break;
      case 'All Time':
      default:
        // No filtering needed for 'Overall'
        break;
    }

    if (selectedBodyPart == 'Overall') {
      // Calculate total sets
      int totalSets = 0;
      for (var entry in setsByBodyPart.entries) {
        totalSets += entry.value.values.reduce((a, b) => a + b);
      }

      // Convert setsByBodyPart to pie chart data
      List<PieChartSectionData> pieChartSections =
          setsByBodyPart.entries.map((entry) {
        String bodyPart = entry.key;
        int bodyPartTotalSets = entry.value.values
            .reduce((a, b) => a + b); // Total sets for body part
        double percentage = (bodyPartTotalSets / totalSets) * 100;

        return PieChartSectionData(
          color: getRandomLightColor(), // Get random color
          value: percentage, // Percentage of total sets
          title:
              '$bodyPart (${percentage.toStringAsFixed(2)}%)', // Title with percentage
          titleStyle: TextStyle(color: getRandomDarkColor()),
          radius: 100,
        );
      }).toList();

      return AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            sections: pieChartSections,
            borderData: FlBorderData(show: true),
            startDegreeOffset: Checkbox.width,
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            pieTouchData: PieTouchData(enabled: true),
            // You can add more customization here
          ),
        ),
      );
    } else {
      // Calculate sets by selected body part
      Map<String, int>? setsForSelectedPart = setsByBodyPart[selectedBodyPart];

      // Convert setsForSelectedPart to pie chart data
      List<PieChartSectionData> pieChartSections = [];
      if (setsForSelectedPart != null) {
        int totalSets = setsForSelectedPart.values.reduce((a, b) => a + b);

        pieChartSections = setsForSelectedPart.entries.map((entry) {
          String exerciseName = entry.key;
          int sets = entry.value;
          double percentage = (sets / totalSets) * 100;

          return PieChartSectionData(
            color: getRandomLightColor(), // Get random color
            value: sets.toDouble(), // Convert to double
            title: '$exerciseName (${percentage.toStringAsFixed(2)}%)',
            titleStyle: TextStyle(color: getRandomDarkColor()),
            radius: 100,
          );
        }).toList();
      }

      return AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            sections: pieChartSections,
            borderData: FlBorderData(show: false),
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            pieTouchData: PieTouchData(enabled: true),
            // You can add more customization here
          ),
        ),
      );
    }
  }

  Color getRandomLightColor() {
    Random random = Random();
    int red = random.nextInt(128) + 128; // Red in the range [128, 255]
    int green = random.nextInt(128) + 128; // Green in the range [128, 255]
    int blue = random.nextInt(128) + 128; // Blue in the range [128, 255]
    return Color.fromRGBO(red, green, blue, 1);
  }

  Color getRandomDarkColor() {
    Random random = Random();
    int red = random.nextInt(128); // Red in the range [0, 127]
    int green = random.nextInt(128); // Green in the range [0, 127]
    int blue = random.nextInt(128); // Blue in the range [0, 127]
    return Color.fromRGBO(red, green, blue, 1);
  }

  Widget _buildHeatMap() {
    return Container(
      color: Theme.of(context).colorScheme.background,
      width: MediaQuery.of(context).size.width,
      child: TableCalendar(
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
              fontSize: 15,
              color: Theme.of(context)
                  .colorScheme
                  .background), // Customize the text color
          leftChevronIcon: Icon(Icons.chevron_left,
              color: Theme.of(context)
                  .colorScheme
                  .background), // Customize the left chevron color
          rightChevronIcon: Icon(Icons.chevron_right,
              color: Theme.of(context)
                  .colorScheme
                  .background), // Customize the right chevron color
          headerPadding: EdgeInsets.symmetric(
              vertical: 0, horizontal: 5), // Adjust header padding
          headerMargin: EdgeInsets.only(bottom: 5), // Adjust header margin
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primary, // Specify the header background color
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle:
                TextStyle(color: Theme.of(context).colorScheme.secondary),
            weekendStyle:
                TextStyle(color: Theme.of(context).colorScheme.primary)),
        firstDay: DateTime(
          DateTime.now().year - 1,
        ),
        lastDay: DateTime(DateTime.now().year + 1),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          return isSameDay(_selectedDay, day);
        },
        calendarFormat: CalendarFormat.month,
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
          });
        },
        calendarStyle: const CalendarStyle(
          outsideDaysVisible: true,
          weekendTextStyle: TextStyle(color: Colors.red),
        ),
        daysOfWeekHeight: 25,
        rowHeight: 50.0,
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, date, _) {
            // Here you can customize your calendar cell to represent the heatmap.
            // For example, you can change the cell's color based on workout data.
            return Container(
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isWorkoutLogged(date)
                    ? Colors.green // Change color if workout is logged
                    : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color: _isWorkoutLogged(date)
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool _isWorkoutLogged(DateTime date) {
    // Check if there's any workout logged for the given date
    return workoutController.workouts.any((workout) =>
        DateTime.parse(workout.date).year == date.year &&
        DateTime.parse(workout.date).month == date.month &&
        DateTime.parse(workout.date).day == date.day);
  }
}

class ChipSelectWidget extends StatefulWidget {
  @override
  _ChipSelectWidgetState createState() => _ChipSelectWidgetState();
}

class _ChipSelectWidgetState extends State<ChipSelectWidget> {
  int _selectedIndex = 0; // Initial selection is Reps

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: [
        ChoiceChip(
          label: Text('Reps'),
          selected: _selectedIndex == 0,
          onSelected: (bool selected) {
            setState(() {
              _selectedIndex = selected ? 0 : 1;
            });
          },
        ),
        ChoiceChip(
          label: Text('Weights'),
          selected: _selectedIndex == 1,
          onSelected: (bool selected) {
            setState(() {
              _selectedIndex = selected ? 1 : 0;
            });
          },
        ),
      ],
    );
  }
}
