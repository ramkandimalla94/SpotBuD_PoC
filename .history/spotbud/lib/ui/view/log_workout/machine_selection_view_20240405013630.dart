import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkoutSessionScreen extends StatelessWidget {
  final String bodyPart;
  final WorkoutSessionViewModel _viewModel = Get.put(WorkoutSessionViewModel());

  WorkoutSessionScreen({required this.bodyPart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Body Part: $bodyPart',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _viewModel.startSession(bodyPart);
              },
              child: Text('Start Session'),
            ),
            SizedBox(height: 20),
            Obx(
              () => _viewModel.isSessionStarted.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Start Time: ${_viewModel.startTime.value}'),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            _viewModel.endSession();
                          },
                          child: Text('End Session'),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _addExercise();
                          },
                          child: Text('Add Exercise'),
                        ),
                      ],
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  void _addExercise() {
    Get.defaultDialog(
      title: 'Add Exercise',
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Here you can add dropdowns or buttons to select exercises for the body part
            // For example:
            ElevatedButton(
              onPressed: () {
                // Navigate to the screen to select exercises for the selected body part
                Get.to(() => ExerciseSelectionScreen(bodyPart: bodyPart));
              },
              child: Text('Select Exercise'),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
