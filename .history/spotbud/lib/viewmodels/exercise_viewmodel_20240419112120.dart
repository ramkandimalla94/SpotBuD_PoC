import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotbud/core/models/workout.dart';

class WorkoutController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Workout> workouts = <Workout>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchWorkoutLogs();
  }

  Future<void> _fetchWorkoutLogs() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Fetch workout logs stream
        _workoutLogsStream = _firestore
            .collection('data')
            .doc(userId)
            .collection('workouts')
            .orderBy('timestamp', descending: true)
            .snapshots();

        // Fetch workout logs
        final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('data')
            .doc(userId)
            .collection('workouts')
            .get();

        // Extract logged exercises for each workout
        List<Exercise> allExercises = [];
        snapshot.docs.forEach((workoutDoc) {
          List<Exercise> exercises = _extractLoggedExercises(workoutDoc);
          allExercises.addAll(exercises);
        });

        // Update state with logged exercises
        setState(() {
          _loggedExercises = allExercises;
        });
      }
    } catch (e) {
      print('Error fetching workout logs: $e');
    }
  }

  List<Exercise> _extractLoggedExercises(QueryDocumentSnapshot workoutDoc) {
    List<Exercise> exercises = [];
    final List<dynamic>? exercisesData = workoutDoc['exercises'];
    if (exercisesData != null) {
      exercises = exercisesData.map((exerciseData) {
        return Exercise(
          name: exerciseData['name'],
          sets: (exerciseData['sets'] as List<dynamic>).map((setData) {
            return ExerciseSet(
              reps: setData['reps'],
              weight: setData['weight'],
            );
          }).toList(),
        );
      }).toList();
    }
    return exercises;
  }
}
