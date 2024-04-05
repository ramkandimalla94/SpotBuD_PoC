import 'package:get/get.dart';

class WorkoutSessionViewModel extends GetxController {
  Rx<DateTime> startTime = DateTime.now().obs;
  Rx<DateTime> endTime = DateTime.now().obs;
  RxList<Exercise> exercises = <Exercise>[].obs;

  void startSession(String bodyPart) {
    startTime.value = DateTime.now();
    exercises.clear();
  }

  void endSession() {
    endTime.value = DateTime.now();
  }

  void addExercise(String bodyPart, String exerciseName) {
    exercises.add(Exercise(bodyPart: bodyPart, exerciseName: exerciseName));
  }

  void removeExercise(int index) {
    exercises.removeAt(index);
  }
}

class Exercise {
  final String bodyPart;
  final String exerciseName;

  Exercise({required this.bodyPart, required this.exerciseName});
}
