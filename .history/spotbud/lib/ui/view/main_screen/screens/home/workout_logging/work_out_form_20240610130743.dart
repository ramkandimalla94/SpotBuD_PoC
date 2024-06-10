import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/main_screen/screens/home/workout_logging/exercise_selection/body.dart';
import 'package:spotbud/ui/view/main_screen/screens/home/workout_logging/exercise_selection/machine_selection_view.dart';
import 'package:spotbud/ui/view/main_screen/screens/home/workout_logging/exercise_selection/routine.dart';
import 'package:spotbud/ui/view/main_screen/screens/home/workout_logging/timer_and_stopwatch.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutLoggingForm extends StatefulWidget {
  final Map<String, dynamic>? routineData;

  WorkoutLoggingForm({this.routineData});
  @override
  State<WorkoutLoggingForm> createState() => _WorkoutLoggingFormState();
}

class _WorkoutLoggingFormState extends State<WorkoutLoggingForm> {
  final WorkoutLoggingFormController controller =
      Get.put(WorkoutLoggingFormController());

  final UserDataViewModel userDataViewModel = Get.find();
  @override
  void initState() {
    super.initState();
    _retrieveTempWorkoutData();
    _populateFromRoutine(widget.routineData);
    //_populateFormFields();
  }

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Log Workout',
          style: AppTheme.secondaryText(
              size: 22,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => StopwatchTimerScreen());
              },
              icon: Icon(Icons.timer)),
          IconButton(
            icon: const Icon(
              CupertinoIcons.trash,
            ),
            onPressed: () => controller.reset(),
          ),
          IconButton(
            icon: const Icon(
              Icons.save,
            ),
            onPressed: () => _saveWorkout(),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Today\'s Date: ${DateTimeUtils.getFormattedDate(_selectedDate)}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 15),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.date_range,
                        color: Theme.of(context).colorScheme.primary),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Start Time: ${DateTimeUtils.getFormattedTime(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedStartTime.hour, _selectedStartTime.minute))}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.access_time,
                        color: Theme.of(context).colorScheme.primary),
                    onPressed: () => _selectStartTime(context),
                  ),
                  Text(
                    'End Time: ${DateTimeUtils.getFormattedTime(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedEndTime.hour, _selectedEndTime.minute))}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.access_time,
                        color: Theme.of(context).colorScheme.primary),
                    onPressed: () => _selectEndTime(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  children: [
                    buildLoginButton(
                      width: 175,
                      text: 'Add Exercise',
                      onPressed: () => _openBodyPartSelection(),
                    ),
                    //SizedBox(width: 20),
                    IconButton(
                        onPressed: () {
                          Get.to(WorkoutRoutineScreen());
                        },
                        icon: Icon(Icons.route_rounded))
                  ],
                ),
              ),
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var exercise in controller.exercises)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  exercise.name,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.info,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  onPressed: () =>
                                      _showExerciseHistoryDialog(exercise.name),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  onPressed: () =>
                                      controller.removeExercise(exercise),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            for (var set in controller.getSets(exercise))
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Set ${set.index}:',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Reps',
                                              labelStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                            ),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            initialValue: set.reps,
                                            onChanged: (value) =>
                                                set.reps = value.trim(),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Weight',
                                              labelStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                            ),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            initialValue: set.weight,
                                            onChanged: (value) =>
                                                set.weight = value.trim(),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          userDataViewModel
                                              .getDisplayWeightUnit(), // Assuming the unit is always lbs
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          onPressed: () => controller.removeSet(
                                              exercise, set),
                                        ),
                                      ],
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Notes',
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      ),
                                      initialValue: set.notes,
                                      onChanged: (value) =>
                                          set.notes = value.trim(),
                                      maxLines: null,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            buildLoginButton(
                              text: 'Add Set',
                              onPressed: () => controller.addSet(
                                  exercise: exercise, theme: Theme.of(context)),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _saveWorkout(),
        label: Text(
          'Save Workout',
          style: TextStyle(color: AppColors.black),
        ),
        icon: Icon(
          Icons.check,
          color: AppColors.black,
        ),
        backgroundColor:
            Theme.of(context).colorScheme.primary, // Use your desired color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _showExerciseHistoryDialog(String machineName) async {
    // Get the current user ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      // Extract machine name from exercise name
      List<String> parts = machineName.split(' - ');
      if (parts.length != 2) {
        print('Invalid machine name format: $machineName');
        return;
      }
      String machine = parts[1]; // Get the part after ' - '

      showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400, // Adjust height according to your requirement
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('data')
                  .doc(userId)
                  .collection('workouts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingIndicator());
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No workout history available.',
                      style: AppTheme.secondaryText(
                        size: 15,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  print('Error fetching workout history: ${snapshot.error}');
                  return Center(
                    child: Text(
                      'Error fetching workout history.',
                      style: AppTheme.secondaryText(
                        size: 15,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  var filteredDocs = snapshot.data!.docs.where((doc) {
                    var exercises = doc['exercises'];
                    if (exercises != null) {
                      return exercises
                          .any((exercise) => exercise['machine'] == machine);
                    }
                    return false;
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return Center(
                      child: Text(
                        'No workout history available for $machine.',
                        style: AppTheme.secondaryText(
                          size: 15,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      var workoutData =
                          filteredDocs[index].data() as Map<String, dynamic>;
                      List<dynamic> exercises = workoutData['exercises'];
                      String date = workoutData['date'];
                      String time = workoutData['startTime'];
                      return ExpansionTile(
                        title: Text(
                          date + '    Time: ' + time,
                          style: AppTheme.secondaryText(
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        initiallyExpanded: index == 0, // Expand the first tile
                        children: exercises.map<Widget>((exercise) {
                          List<dynamic> sets = exercise['sets'];
                          List<Widget> setWidgets = sets.map((set) {
                            String reps = set['reps'] ?? 'Data Not Available';
                            String weight =
                                set['weight'] ?? 'Data Not Available';
                            if (userDataViewModel.isKgsPreferred.value) {
                              return ListTile(
                                title: Text(
                                  'Reps: $reps  Weights: $weight kg',
                                  style: AppTheme.secondaryText(
                                    size: 15,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // You can display other set details here
                              );
                            } else {
                              // Convert kg to lbs
                              double weightInKg = double.parse(weight);
                              double weightInLbs = weightInKg * 2.20462;
                              return ListTile(
                                title: Text(
                                  'Reps: $reps  Weights: ${weightInLbs.toStringAsFixed(2)} lbs',
                                  style: AppTheme.secondaryText(
                                    size: 15,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // You can display other set details here
                              );
                            }
                          }).toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...setWidgets,
                              //Divider(), // Add a divider between exercises
                            ],
                          );
                        }).toList(),
                      );
                    },
                  );
                }
              },
            ),
          );
        },
      );
    } else {
      // Handle case where user is not logged in
      print('User is not logged in');
    }
  }

  Future<Map<String, String>?> fetchLatestSetDetails(String machineName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Fetch the latest workout containing the specified machine
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection('data')
            .doc(userId)
            .collection('workouts')
            .orderBy('timestamp', descending: true)
            .limit(14)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Iterate through each workout to find the one containing the specified machine
          for (var doc in snapshot.docs) {
            var workoutData = doc.data();
            // Get the exercises from the current workout
            List<dynamic> exercises = workoutData['exercises'];

            // Find the exercise containing the specified machine
            var exerciseContainingMachine = exercises.firstWhere(
                (exercise) => exercise['machine'] == machineName,
                orElse: () => null);

            if (exerciseContainingMachine != null) {
              // Get the sets for the specified exercise
              List<dynamic> sets = exerciseContainingMachine['sets'];
              // Get the latest set
              var latestSet = sets.isNotEmpty ? sets[0] : null;

              if (latestSet != null) {
                // Get the reps and weight from the latest set
                String reps = latestSet['reps'] ?? 'Data Not Available';
                String weight = latestSet['weight'] ?? 'Data Not Available';
                // Return the reps and weight
                return {'reps': reps, 'weight': weight};
              } else {
                print('No sets available for $machineName');
              }
            } else {
              print(
                  'Exercise containing $machineName not found in this workout');
            }
          }
        } else {
          print('No workout data available');
        }
      } else {
        throw Exception('User is not logged in');
      }
    } catch (e) {
      print('Error fetching latest set details: $e');
    }
    return null; // Return null if there's an error or no data
  }

  final String _tempWorkoutDataKey = 'temp_workout_data';
  Map<String, dynamic>? _tempWorkoutData;

  Future<bool> _onBackPressed() async {
    _tempWorkoutData = _prepareWorkoutData();
    if (_tempWorkoutData != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(_tempWorkoutDataKey, jsonEncode(_tempWorkoutData!));
    }
    return true;
  }

  void _temporarilySaveWorkoutData() async {
    // Prepare workout data
    Map<String, dynamic>? workoutData = _prepareWorkoutData();

    // Store workout data in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_tempWorkoutDataKey, jsonEncode(workoutData));
  }

  Map<String, dynamic>? _prepareWorkoutData() {
    // Prepare workout data
    List<Map<String, dynamic>> exercisesData = [];

    for (var exercise in controller.exercises) {
      final setsData = controller
          .getSets(exercise)
          .map((set) => {
                'reps': set.reps,
                'weight': set.weight,
                'notes': set.notes,
              })
          .toList();

      // Split exercise name into body part and machine
      final nameParts = exercise.name.split(' - ');
      final bodyPart = nameParts[0];
      final machine = nameParts[1];

      exercisesData.add({
        'bodyPart': bodyPart,
        'machine': machine,
        'sets': setsData,
      });
    }

    // Prepare workout data
    Map<String, dynamic> workoutData = {
      'date': DateTimeUtils.getFormattedDate(_selectedDate),
      'startTime': DateTimeUtils.getFormattedTime(DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedStartTime.hour,
          _selectedStartTime.minute)),
      'endTime': controller.endTime.value.isNotEmpty
          ? controller.endTime.value
          : DateTimeUtils.getFormattedTime(
              DateTime.now()), // Current time if end time is empty
      'exercises': exercisesData, // Set the exercises data
    };

    // Temporarily save workout data
    return workoutData;
  }

  void _retrieveTempWorkoutData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tempData = prefs.getString(_tempWorkoutDataKey);
    if (tempData != null) {
      setState(() {
        _tempWorkoutData = jsonDecode(tempData);
        _selectedDate = DateTime.parse(_tempWorkoutData!['date']);
        _selectedStartTime =
            _parseTimeStringToTimeOfDay(_tempWorkoutData!['startTime']);
        _selectedEndTime =
            _parseTimeStringToTimeOfDay(_tempWorkoutData!['endTime']);
        // Clear existing exercises and sets
        controller.exercises.clear();
        controller.sets.clear();
        // Populate exercises and sets from retrieved data
        final List<dynamic> exercisesData = _tempWorkoutData!['exercises'];
        for (var exerciseData in exercisesData) {
          final String bodyPart = exerciseData['bodyPart'];
          final String machine = exerciseData['machine'];
          final ExerciseData exercise =
              ExerciseData(name: '$bodyPart - $machine');

          controller.addExercise(exercise);
          controller.getSets(exercise).clear();
          final List<dynamic> setsData = exerciseData['sets'];
          for (var setData in setsData) {
            final int index = setsData.indexOf(setData) + 1;
            final String reps = setData['reps'] ?? '';
            final String weight = setData['weight'] ?? '';
            final String notes = setData['notes'] ?? '';
            final SetData set =
                SetData(index: index, reps: reps, weight: weight, notes: notes);
            controller.getSets(exercise).add(set);
          }
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    );
    if (picked != null && picked != _selectedStartTime)
      setState(() {
        _selectedStartTime = picked;
      });
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
    );
    if (picked != null && picked != _selectedEndTime)
      setState(() {
        _selectedEndTime = picked;
      });
  }

  Future<void> _saveWorkout() async {
    if (controller.exercises.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one exercise before saving.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.background,
        colorText: Theme.of(context).colorScheme.secondary,
      );
      return;
    }

    // Perform validation for each set
    for (var exercise in controller.exercises) {
      final sets = controller.getSets(exercise);
      for (var set in sets) {
        if (set.reps.isEmpty || set.weight.isEmpty) {
          Get.snackbar(
            'Error',
            'Please fill in both reps and weight for all sets.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Theme.of(context).colorScheme.background,
            colorText: Theme.of(context).colorScheme.secondary,
          );
          return;
        }
      }
    }

    // Remove exercises with no sets
    controller.exercises
        .removeWhere((exercise) => controller.getSets(exercise).isEmpty);

    // Check if there are no exercises with sets
    if (controller.exercises.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one exercise with sets before saving.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.background,
        colorText: Theme.of(context).colorScheme.secondary,
      );
      return;
    }

    // Prepare workout data
    List<Map<String, dynamic>> exercisesData = [];

    // Get user's preference for weight unit
    bool isKgsPreferred = userDataViewModel.isKgsPreferred.value;

    for (var exercise in controller.exercises) {
      final setsData = controller
          .getSets(exercise)
          .map((set) => {
                'reps': set.reps,
                'weight':
                    isKgsPreferred ? set.weight : _convertLbsToKg(set.weight),
                'notes': set.notes,
              })
          .toList();

      // Split exercise name into body part and machine
      final nameParts = exercise.name.split(' - ');
      final bodyPart = nameParts[0];
      final machine = nameParts[1];

      exercisesData.add({
        'bodyPart': bodyPart,
        'machine': machine,
        'sets': setsData,
      });
    }

    // Prepare workout data
    Map<String, dynamic> workoutData = {
      'date': DateTimeUtils.getFormattedDate(_selectedDate),
      'startTime': DateTimeUtils.getFormattedTime(DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedStartTime.hour,
          _selectedStartTime.minute)),
      'endTime': controller.endTime.value.isNotEmpty
          ? controller.endTime.value
          : DateTimeUtils.getFormattedTime(
              DateTime.now()), // Current time if end time is empty
      'exercises': exercisesData, // Set the exercises data
    };

    // Save workout data to Firestore
    userDataViewModel.saveWorkoutLog(workoutData);

    Get.snackbar(
      'Success',
      'Workout saved successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.primary,
      colorText: Theme.of(context).colorScheme.secondary,
    );
    // Reset the form
    controller.reset();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_tempWorkoutDataKey);
    // Redirect to the main screen after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.toNamed('/mainscreen');
    });
  }

// Function to convert weight from pounds to kilograms
  String _convertLbsToKg(String lbs) {
    // Assuming the weight is always in pounds
    double weightInLbs = double.parse(lbs);
    double weightInKg =
        weightInLbs * 0.453592; // Conversion factor from lbs to kg
    return weightInKg
        .toStringAsFixed(2); // Return weight in kg rounded to 2 decimal places
  }

  void _populateFromRoutine(Map<String, dynamic>? routineData) {
    if (routineData != null) {
      final List<dynamic> exercisesData = routineData['exercises'];

      // Clear existing exercises and sets
      controller.exercises.clear();
      controller.sets.clear();

      for (var exerciseData in exercisesData) {
        final String bodyPart = exerciseData['bodyPart'];
        final String machine = exerciseData['machine'];
        final ExerciseData exercise =
            ExerciseData(name: '$bodyPart - $machine');

        controller.addExercise(exercise);

        final List<dynamic> setsData = exerciseData['sets'];
        for (var setData in setsData) {
          final int index = setsData.indexOf(setData) + 1;
          final String reps = setData['reps'] ?? '';
          final String weight = setData['weight'] ?? '';
          final String notes = setData['notes'] ?? '';
          final SetData set =
              SetData(index: index, reps: reps, weight: weight, notes: notes);
          controller.getSets(exercise).add(set);
        }
      }
    }
  }

  TimeOfDay _parseTimeStringToTimeOfDay(String timeString) {
    final List<String> parts = timeString.split(':');
    final int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  void _openBodyPartSelection() async {
    var result = await Get.to(() => Bodypart());
    print(result);
    if (result != null && result is String) {
      var selectedBodyPart = result;

      var machineResult = await Get.to(
          () => MachineSelectionScreen(bodyPart: selectedBodyPart));
      if (machineResult != null && machineResult is Map<String, String>) {
        var bodyPart = machineResult['bodyPart'];
        var machine = machineResult['machine'];
        if (bodyPart != null && machine != null) {
          var exercise = ExerciseData(name: '$bodyPart - $machine');

          // Fetch the latest set details for the selected machine
          var latestSetDetails = await fetchLatestSetDetails(machine);

          // Add the exercise
          controller.addExercise(exercise);

          // If fetched data is available, set it as hint text
          if (latestSetDetails != null) {
            var reps = latestSetDetails['reps'] ?? '';
            var weight = latestSetDetails['weight'] ?? '';

            // Convert weight based on user preference
            if (userDataViewModel.isKgsPreferred.value) {
              controller.getSets(exercise).first.reps = reps;
              controller.getSets(exercise).first.weight = weight;
            } else {
              // Convert kg to lbs
              double weightInKg = double.parse(weight);
              double weightInLbs = weightInKg * 2.20462;
              controller.getSets(exercise).first.reps = reps;
              controller.getSets(exercise).first.weight =
                  weightInLbs.toStringAsFixed(2);
            }
          }
        }
      }
    }
  }
}

class DateTimeUtils {
  static String getFormattedDate(DateTime dateTime) {
    return '${dateTime.year}-${_addLeadingZero(dateTime.month)}-${_addLeadingZero(dateTime.day)}';
  }

  static String getFormattedTime(DateTime dateTime) {
    return '${_addLeadingZero(dateTime.hour)}:${_addLeadingZero(dateTime.minute)}:${_addLeadingZero(dateTime.second)}';
  }

  static String _addLeadingZero(int value) {
    return value < 10 ? '0$value' : '$value';
  }
}

class WorkoutLoggingFormController extends GetxController {
  var exercises = <ExerciseData>[].obs;
  var endTime = ''.obs;
  var sets = <ExerciseData, List<SetData>>{}.obs;

  void addExercise(ExerciseData exercise) {
    exercises.add(exercise);
    sets[exercise] = [SetData(index: 1)];
  }

  List<SetData> getSets(ExerciseData exercise) {
    return sets[exercise] ?? [];
  }

  void addSet({required ExerciseData exercise, required ThemeData theme}) {
    final currentSets = sets[exercise] ?? [];
    if (currentSets.isNotEmpty) {
      final previousSet = currentSets.last;
      if (previousSet.reps.isEmpty || previousSet.weight.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill in both reps and weight for the current set to add a new set.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: theme.colorScheme.secondary,
        );
        return;
      }
    }

    // Create a new set and initialize it with the values of the previous set
    final newIndex = currentSets.isEmpty ? 1 : currentSets.last.index + 1;
    final newSet = SetData(index: newIndex);
    if (currentSets.isNotEmpty) {
      final previousSet = currentSets.last;
      newSet.reps = previousSet.reps;
      newSet.weight = previousSet.weight;
    }
    currentSets.add(newSet);
    sets[exercise] = currentSets;
  }

  void removeSet(ExerciseData exercise, SetData set) {
    final currentSets = sets[exercise] ?? [];
    currentSets.remove(set);
    sets[exercise] = currentSets;
  }

  void removeExercise(ExerciseData exercise) {
    exercises.remove(exercise);
    sets.remove(exercise);
  }

  void setEndTime(String time) {
    endTime.value = time;
  }

  void reset() {
    exercises.clear();
    sets.clear();
    endTime.value = '';
  }
}

class ExerciseData {
  final String name;

  ExerciseData({required this.name});
}

class SetData {
  final int index;
  String reps = '';
  String weight = '';
  String notes = '';

  SetData(
      {required this.index, this.reps = '', this.weight = '', this.notes = ''});
}
