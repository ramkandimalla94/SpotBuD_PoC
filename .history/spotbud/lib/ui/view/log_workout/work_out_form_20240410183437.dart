import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/machine_selection_view.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
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
              Center(
                child: Row(
                  children: [
                    buildWorkoutButton(
                      width: 175,
                      text: 'Add Exercise',
                      onPressed: () => _openBodyPartSelection(),
                    ),
                    // //SizedBox(width: 20),
                    // buildWorkoutButton(
                    //   width: 175,
                    //   text: 'History',
                    //   onPressed: () => _showExerciseHistoryDialog(),
                    // ),
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
                                IconButton(
                                  icon: Icon(
                                    Icons.info,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      _showExerciseHistoryDialog(exercise.name),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Reps',
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style:
                                                TextStyle(color: Colors.white),
                                            initialValue: set.reps,
                                            onChanged: (value) =>
                                                set.reps = value.trim(),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Weight',
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style:
                                                TextStyle(color: Colors.white),
                                            initialValue: set.weight,
                                            onChanged: (value) =>
                                                set.weight = value.trim(),
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
                                      initialValue: set.notes,
                                      onChanged: (value) =>
                                          set.notes = value.trim(),
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
                  return Center(child: LoadingIndicator());
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No workout history available.'));
                } else if (snapshot.hasError) {
                  print('Error fetching workout history: ${snapshot.error}');
                  return Center(child: Text('Error fetching workout history.'));
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
                        child:
                            Text('No workout history available for $machine.'));
                  }

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      var workoutData =
                          filteredDocs[index].data() as Map<String, dynamic>;
                      List<dynamic> exercises = workoutData['exercises'];
                      String date = workoutData['date'];
                      return ExpansionTile(
                        title: Text(date),
                        initiallyExpanded: index == 0, // Expand the first tile
                        children: exercises.map<Widget>((exercise) {
                          List<dynamic> sets = exercise['sets'];
                          List<Widget> setWidgets = sets.map((set) {
                            String reps = set['reps'] ?? 'Data Not Available';
                            String weight =
                                set['weight'] ?? 'Data Not Available';
                            return ListTile(
                              title: Text('Reps: $reps  Weights: $weight'),
                              // You can display other set details here
                            );
                          }).toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...setWidgets,
                              Divider(), // Add a divider between exercises
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

  Future<void> fetchLatestSetDetails(String machineName) async {
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
            .where('exercises', isEqualTo: machineName)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Get the latest workout data
          var workoutData = snapshot.docs.first.data();
          // Get the exercises from the latest workout
          List<dynamic> exercises = workoutData['exercises'];

          // Find the specified exercise
          var exercise = exercises.firstWhere(
              (exercise) => exercise['machine'] == machineName,
              orElse: () => null);

          if (exercise != null) {
            // Get the sets for the specified exercise
            List<dynamic> sets = exercise['sets'];
            // Get the latest set
            var latestSet = sets.isNotEmpty ? sets[0] : null;

            if (latestSet != null) {
              // Get the reps and weight from the latest set
              String reps = latestSet['reps'] ?? 'Data Not Available';
              String weight = latestSet['weight'] ?? 'Data Not Available';
              // Print the reps and weight
              print('Latest Reps: $reps, Latest Weight: $weight');
            } else {
              print('No sets available for $machineName');
            }
          } else {
            print('Exercise $machineName not found in the latest workout');
          }
        } else {
          print('No workout data available for $machineName');
        }
      } else {
        throw Exception('User is not logged in');
      }
    } catch (e) {
      print('Error fetching latest set details: $e');
    }
  }

  Future<bool> _onBackPressed() async {
    if (controller.exercises.isNotEmpty) {
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

      return result ?? false;
    }
    return true;
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
      final sets = controller.getSets(exercise);
      for (var set in sets) {
        if (set.reps.isEmpty || set.weight.isEmpty) {
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
    controller.exercises
        .removeWhere((exercise) => controller.getSets(exercise).isEmpty);

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

    // Save workout data to Firestore
    userDataViewModel.saveWorkoutLog(workoutData);

    Get.snackbar(
      'Success',
      'Workout saved successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.blue,
      colorText: Colors.white,
    );
    // Reset the form
    controller.reset();

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
        var exercise = ExerciseData(name: '$bodyPart - $machine');

        // Fetch the latest set details for the selected machine
        fetchLatestSetDetails(machine);

        // Add the exercise
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

  void addSet({required ExerciseData exercise}) {
    final currentSets = sets[exercise] ?? [];
    if (currentSets.isNotEmpty) {
      final previousSet = currentSets.last;
      if (previousSet.reps.isEmpty || previousSet.weight.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill in both reps and weight for the current set to add a new set.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }
    final newIndex = currentSets.isEmpty ? 1 : currentSets.last.index + 1;
    currentSets.add(SetData(index: newIndex));
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
