import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/machine_selection_view.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class WorkoutLoggingForm extends StatefulWidget {
  @override
  State<WorkoutLoggingForm> createState() => _WorkoutLoggingFormState();
}

class _WorkoutLoggingFormState extends State<WorkoutLoggingForm> {
  final WorkoutLoggingFormController controller =
      Get.put(WorkoutLoggingFormController());

  final UserDataViewModel userDataViewModel = Get.find();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.acccentColor),
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Log Workout',
          style: AppTheme.secondaryText(
              size: 22,
              fontWeight: FontWeight.w500,
              color: AppColors.acccentColor),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            onPressed: () => _saveWorkout(),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Today\'s Date: ${DateTimeUtils.getFormattedDate(_selectedDate)}',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.date_range, color: AppColors.acccentColor),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              //SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'Start Time: ${DateTimeUtils.getFormattedTime(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedStartTime.hour, _selectedStartTime.minute))}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  IconButton(
                    icon:
                        Icon(Icons.access_time, color: AppColors.acccentColor),
                    onPressed: () => _selectStartTime(context),
                  ),

                  //SizedBox(height: 1),

                  Text(
                    'End Time: ${DateTimeUtils.getFormattedTime(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedEndTime.hour, _selectedEndTime.minute))}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  IconButton(
                    icon:
                        Icon(Icons.access_time, color: AppColors.acccentColor),
                    onPressed: () => _selectEndTime(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              buildWorkoutButton(
                text: 'Add Exercise',
                onPressed: () => _openBodyPartSelection(),
              ),
              SizedBox(height: 20),
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
                                  exercise['name'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      controller.removeExercise(exercise),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            for (var set in exercise['sets'])
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Set ${set['index']}:',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'Reps',
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style:
                                                TextStyle(color: Colors.white),
                                            initialValue: set['reps'],
                                            onChanged: (value) =>
                                                set['reps'] = value.trim(),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'Weight',
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style:
                                                TextStyle(color: Colors.white),
                                            initialValue: set['weight'],
                                            onChanged: (value) =>
                                                set['weight'] = value.trim(),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'lbs', // Assuming the unit is always lbs
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: AppColors.backgroundColor,
                                          ),
                                          onPressed: () => controller.removeSet(
                                              exercise, set),
                                        ),
                                      ],
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Notes',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                      ),
                                      initialValue: set['notes'],
                                      onChanged: (value) =>
                                          set['notes'] = value.trim(),
                                      maxLines: null,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            buildWorkoutButton(
                              text: 'Add Set',
                              onPressed: () =>
                                  controller.addSet(exercise: exercise),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (controller.exercises.isNotEmpty) {
      // Show a dialog if there are exercises and prompt to save workout
      var result = await Get.dialog(
        AlertDialog(
          title: Text('Save Workout?'),
          content: Text('Do you want to save the workout before leaving?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(result: true); // Discard workout
              },
              child: Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: false); // Cancel and stay on the log screen
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      );

      return result ??
          false; // Default to false (don't save) if dialog is dismissed
    }
    return true; // No exercises, allow back navigation
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

  void _saveWorkout() {
    if (controller.exercises.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one exercise before saving.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.black,
        colorText: Colors.white,
      );
      return;
    }

    // Perform validation for each set
    for (var exercise in controller.exercises) {
      final sets = exercise['sets'];
      for (var set in sets) {
        if (set['reps'].isEmpty || set['weight'].isEmpty) {
          Get.snackbar(
            'Error',
            'Please fill in both reps and weight for all sets.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.black,
            colorText: Colors.white,
          );
          return;
        }
      }
    }

    // Remove exercises with no sets
    controller.exercises.removeWhere((exercise) => exercise['sets'].isEmpty);

    // Check if there are no exercises with sets
    if (controller.exercises.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one exercise with sets before saving.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.black,
        colorText: Colors.white,
      );
      return;
    }

    // Prepare workout data
    Map<String, dynamic> workoutData = {
      'date': DateTimeUtils.getFormattedDate(_selectedDate),
      'starttime': DateTimeUtils.getFormattedTime(DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedStartTime.hour,
          _selectedStartTime.minute)),
      'endtime': controller.endTime.value.isNotEmpty
          ? controller.endTime.value
          : DateTimeUtils.getFormattedTime(
              DateTime.now()), // Current time if end time is empty
      'timestamp': FieldValue.serverTimestamp(),
      'exercises': controller.exercises.map((exercise) {
        return {
          'name': exercise['name'],
          'sets': exercise['sets'].map((set) {
            return {
              'reps': set['reps'],
              'weight': set['weight'],
              'notes': set['notes'],
            };
          }).toList(),
        };
      }).toList(),
    };

    // Save workout data to Firestore
    userDataViewModel.addWorkoutDetails(workoutData);

    Get.snackbar(
      'Success',
      'Workout saved successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.blue,
      colorText: Colors.white,
    );
    // Reset the form
    controller.reset();

    // Redirect to the main screen
    // Redirect to the main screen after a short delay
    Future.delayed(Duration(milliseconds: 500), () {
      Get.toNamed('/mainscreen');
    });
  }

  void _openBodyPartSelection() async {
    var result = await Get.to(MachineSelectionScreen());
    if (result != null && result is Map<String, String>) {
      var bodyPart = result['bodyPart'];
      var machine = result['machine'];
      if (bodyPart != null && machine != null) {
        var exercise = {
          'bodypart': '$bodyPart',
          machine: '$machine',
          'sets': []
        };
        controller.addExercise(exercise);
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
  var exercises = <Map<String, dynamic>>[].obs;
  var endTime = ''.obs;

  void addExercise(Map<String, dynamic> exercise) {
    exercises.add(exercise);
  }

  void removeExercise(Map<String, dynamic> exercise) {
    exercises.remove(exercise);
  }

  void addSet({required Map<String, dynamic> exercise}) {
    final currentSets = exercise['sets'];
    final newIndex = currentSets.length + 1;
    currentSets.add({'index': newIndex, 'reps': '', 'weight': '', 'notes': ''});
  }

  void removeSet(Map<String, dynamic> exercise, Map<String, dynamic> set) {
    final currentSets = exercise['sets'];
    currentSets.remove(set);
  }

  void setEndTime(String time) {
    endTime.value = time;
  }

  void reset() {
    exercises.clear();
    endTime.value = '';
  }
}
