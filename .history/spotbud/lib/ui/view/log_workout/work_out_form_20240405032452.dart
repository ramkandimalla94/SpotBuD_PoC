import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/machine_selection_view.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';

class WorkoutLoggingForm extends StatefulWidget {
  @override
  State<WorkoutLoggingForm> createState() => _WorkoutLoggingFormState();
}

class _WorkoutLoggingFormState extends State<WorkoutLoggingForm> {
  final WorkoutLoggingFormController controller =
      Get.put(WorkoutLoggingFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bluebackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.bluebackgroundColor,
        title: Text(
          'Log Workout',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveWorkout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Date: ${DateTimeUtils.getFormattedDate(DateTime.now())}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Start Time: ${DateTimeUtils.getFormattedTime(DateTime.now())}',
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Obx(() => Text(
                      'End Time: ${controller.endTime.value.isEmpty ? 'Not Set' : controller.endTime.value}',
                      style: TextStyle(color: Colors.white),
                    )),
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
                          Text(
                            exercise,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          for (var set in controller.getSets(exercise))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Set ${set.index}:',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Reps',
                                      ),
                                      initialValue: set.reps,
                                      onChanged: (value) =>
                                          set.reps = value.trim(),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Weight (kg)',
                                      ),
                                      initialValue: set.weight,
                                      onChanged: (value) =>
                                          set.weight = value.trim(),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Notes',
                                      ),
                                      initialValue: set.notes,
                                      onChanged: (value) =>
                                          set.notes = value.trim(),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () =>
                                        controller.removeSet(exercise, set),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 10),
                          buildWorkoutButton(
                            text: 'Add Set',
                            onPressed: () =>
                                controller.addSet(exercise: exercise),
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                controller.removeExercise(exercise),
                          ),
                        ],
                      ),
                  ],
                )),
          ],
        ),
      ),
    );
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
    // Save workout logic here
    Get.snackbar(
      'Success',
      'Workout saved successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.blue,
      colorText: Colors.white,
    );
    // Reset the form
    controller.reset();
  }

  void _openBodyPartSelection() async {
    var result = await Get.to(MachineSelectionScreen());
    if (result != null && result is Map<String, String>) {
      var bodyPart = result['bodyPart'];
      var machine = result['machine'];
      if (bodyPart != null && machine != null) {
        var exercise = '$bodyPart - $machine';
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
  var exercises = <String>[].obs;
  var endTime = ''.obs;
  var sets = <String, List<SetData>>{}.obs;

  void addExercise(String exercise) {
    exercises.add(exercise);
    sets[exercise] = [SetData(index: 1)];
  }

  List<SetData> getSets(String exercise) {
    return sets[exercise] ?? [];
  }

  void addSet({required String exercise}) {
    final currentSets = sets[exercise] ?? [];
    final newIndex = currentSets.isEmpty ? 1 : currentSets.last.index + 1;
    currentSets.add(SetData(index: newIndex));
    sets[exercise] = currentSets;
  }

  void removeSet(String exercise, SetData set) {
    final currentSets = sets[exercise] ?? [];
    currentSets.remove(set);
    sets[exercise] = currentSets;
  }

  void removeExercise(String exercise) {
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

class SetData {
  final int index;
  String reps = '';
  String weight = '';
  String notes = '';

  SetData(
      {required this.index, this.reps = '', this.weight = '', this.notes = ''});
}
