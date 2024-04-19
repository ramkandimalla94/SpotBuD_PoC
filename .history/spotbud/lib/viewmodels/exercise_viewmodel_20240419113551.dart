import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotbud/core/models/workout.dart';

class WorkoutController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<Workout> workouts = <Workout>[].obs;
  RxList<String> loggedMachines = <String>[].obs;

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

        // Fetch workout logs
        final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('data')
            .doc(userId)
            .collection('workouts')
            .orderBy('timestamp', descending: true)
            .get();

        // Extract workouts
        List<Workout> fetchedWorkouts = snapshot.docs.map((workoutDoc) {
          return Workout(
            timestamp: workoutDoc['timestamp'],
            exercises: _extractLoggedExercises(workoutDoc),
          );
        }).toList();

        workouts.value = fetchedWorkouts;

        // Fetch logged machines
        List<String> fetchedMachines = _extractLoggedMachines(snapshot.docs);
        loggedMachines.value = fetchedMachines;
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
          name: exerciseData['machine'],
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

  List<String> _extractLoggedMachines(List<QueryDocumentSnapshot> workoutDocs) {
    Set<String> machines = Set<String>();
    workoutDocs.forEach((workoutDoc) {
      final List<dynamic>? exercisesData = workoutDoc['exercises'];
      if (exercisesData != null) {
        exercisesData.forEach((exerciseData) {
          if (exerciseData.containsKey('machine')) {
            machines.add(exerciseData['machine']);
          }
        });
      }
    });
    return machines.toList();
  }
}
