import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/core/models/workout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
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

  late DateTime _selectedDay;
  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _fetchData();
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
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: AppColors.acccentColor),
        title: const Text(
          'Exercise Analytics',
          style: TextStyle(color: AppColors.acccentColor),
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
          Row(
            children: [
              const Text(
                'Select an Exercise:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: AppColors.acccentColor),
              ),
              const SizedBox(width: 20.0),
              DropdownButton<String>(
                dropdownColor: AppColors.primaryColor,
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
                      style: const TextStyle(color: AppColors.backgroundColor),
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
                            ? AppColors.primaryColor
                            : AppColors.acccentColor,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: showLineChart
                            ? AppColors.acccentColor
                            : AppColors.primaryColor,
                        elevation: 10),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showLineChart = false;
                      });
                    },
                    child: Text(
                      'Bar Chart',
                      style: TextStyle(
                        color: !showLineChart
                            ? AppColors.primaryColor
                            : AppColors.acccentColor,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: !showLineChart
                            ? AppColors.acccentColor
                            : AppColors.primaryColor,
                        elevation: 10),
                  ),
                ],
              ),
            ),
            if (showLineChart) ...[
              Column(
                children: [
                  DropdownButton<String>(
                    dropdownColor: AppColors.primaryColor,
                    value: selectedOption,
                    onChanged: (newValue) {
                      setState(() {
                        selectedOption = newValue!;
                      });
                    },
                    items: [
                      const DropdownMenuItem(
                        value: 'Min Weight',
                        child: Text(
                          'Min Weight',
                          style: TextStyle(color: AppColors.backgroundColor),
                        ),
                      ),
                      const DropdownMenuItem(
                        value: 'Max Weight',
                        child: Text(
                          'Max Weight',
                          style: TextStyle(color: AppColors.backgroundColor),
                        ),
                      ),
                      const DropdownMenuItem(
                        value: 'Average Weight',
                        child: Text(
                          'Average Weight',
                          style: TextStyle(color: AppColors.backgroundColor),
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
        Text(
          'Analytics for $selectedExercise:',
          style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: AppColors.acccentColor),
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
            _buildAnalyticsItem(
                'Average Weight', '${averageWeight.toStringAsFixed(2)} kgs'),
            const SizedBox.square(
              dimension: 20,
            ),
            _buildAnalyticsItem(
                'Max Weight', '${maxWeight.toStringAsFixed(2)} kgs'),
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
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
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
            style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.acccentColor),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: const TextStyle(
                fontSize: 14.0, color: AppColors.backgroundColor),
          ),
        ],
      ),
    );
  }

  Widget _buildLineGraph(
      List<Workout> workouts, String selectedExercise, String selectedOption) {
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
            double weight = double.tryParse(set.weight) ?? 0.0;
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
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
                        padding: const EdgeInsets.symmetric(horizontal: 2.5),
                        child: Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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
                        style: const TextStyle(
                          color: Colors.white,
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
            backgroundColor: AppColors.primaryColor,
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

    // Map to hold workout sets grouped by date
    Map<DateTime, List<double>> dateWeightsMap = {};

    // Group weights by date
    for (var workout in filteredWorkouts) {
      DateTime date = DateTime.parse(workout.date);
      for (var exercise in workout.exercises) {
        if (exercise.machine == selectedExercise) {
          for (var set in exercise.sets) {
            double weight = double.tryParse(set.weight) ?? 0.0;
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
            color: AppColors.acccentColor,
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
                    border: Border.all(color: Colors.white, width: 1),
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
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
                            style: const TextStyle(
                              color: Colors.white,
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
                  gridData: const FlGridData(show: false),
                  backgroundColor: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(Map<String, int> setsByBodyPart) {
    // Convert setsByBodyPart to pie chart data
    List<PieChartSectionData> pieChartSections =
        setsByBodyPart.entries.map((entry) {
      String bodyPart = entry.key;
      int numSets = entry.value;

      // Calculate percentage
      double percentage =
          numSets / setsByBodyPart.values.reduce((a, b) => a + b);

      return PieChartSectionData(
        color:
            getRandomColor(), // You can define a function to get random colors
        value: percentage * 100, // Convert to percentage
        title: '$bodyPart (${(percentage * 100).toStringAsFixed(2)}%)',
        radius: 50,
      );
    }).toList();

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

  Widget _buildHeatMap() {
    return Container(
      color: AppColors.primaryColor,
      width: MediaQuery.of(context).size.width,
      child: TableCalendar(
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
              fontSize: 15, color: AppColors.black), // Customize the text color
          leftChevronIcon: Icon(Icons.chevron_left,
              color: AppColors.black), // Customize the left chevron color
          rightChevronIcon: Icon(Icons.chevron_right,
              color: AppColors.black), // Customize the right chevron color
          headerPadding: EdgeInsets.symmetric(
              vertical: 0, horizontal: 5), // Adjust header padding
          headerMargin: EdgeInsets.only(bottom: 5), // Adjust header margin
          decoration: BoxDecoration(
            color:
                AppColors.acccentColor, // Specify the header background color
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: AppColors.backgroundColor),
            weekendStyle: TextStyle(color: AppColors.acccentColor)),
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
                    color: _isWorkoutLogged(date) ? Colors.white : Colors.white,
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

  Map<String, int> _calculateSetsByBodyPart() {
    Map<String, int> setsByBodyPart = {};

    for (var workout in workoutController.workouts) {
      for (var exercise in workout.exercises) {
        String bodyPart = exercise.bodyPart;
        int numSets = exercise.sets.length;

        // Increment the count for the body part
        setsByBodyPart[bodyPart] = (setsByBodyPart[bodyPart] ?? 0) + numSets;
      }
    }

    return setsByBodyPart;
  }
}
