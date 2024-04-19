import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotbud/core/models/workout.dart';

class WorkoutController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Workout> workouts = <Workout>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    try {
      // Fetch workout data from Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('workouts').get();

      // Convert each document snapshot to a Workout object
      List<Workout> fetchedWorkouts =
          querySnapshot.docs.map((doc) => Workout.fromMap(doc.data())).toList();

      // Update the workouts list
      workouts.value = fetchedWorkouts;
    } catch (error) {
      print('Error fetching workouts: $error');
    }
  }
}
