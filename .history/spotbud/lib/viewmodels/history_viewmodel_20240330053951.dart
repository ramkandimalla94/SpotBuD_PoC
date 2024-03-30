import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryViewModel extends GetxController {
  RxList<Map<String, dynamic>> _workoutHistory = <Map<String, dynamic>>[].obs;
  List<String> _uniqueMachines = [];
  List<String> _uniqueBodyParts = [];

  RxList<Map<String, dynamic>> get workoutHistory => _workoutHistory;
  List<String> get uniqueMachines => _uniqueMachines;
  List<String> get uniqueBodyParts => _uniqueBodyParts;

  @override
  void onInit() {
    super.onInit();
    fetchWorkoutHistory();
  }

  Future<void> fetchWorkoutHistory() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot<Map<String, dynamic>> userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        final List<dynamic> workoutHistory =
            userDoc.data()?['workoutHistory'] ?? [];
        _workoutHistory.assignAll(workoutHistory.cast<Map<String, dynamic>>());
        _updateUniqueValues();
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error fetching workout history: $e');
    }
  }

  void _updateUniqueValues() {
    _uniqueMachines.clear();
    _uniqueBodyParts.clear();

    for (final workout in _workoutHistory) {
      final String machine = workout['machine'];
      final String bodyPart = workout['bodyPart'];
      if (!_uniqueMachines.contains(machine)) {
        _uniqueMachines.add(machine);
      }
      if (!_uniqueBodyParts.contains(bodyPart)) {
        _uniqueBodyParts.add(bodyPart);
      }
    }
  }

  void filterByMachine(String? machine) {
    if (machine != null && machine.isNotEmpty) {
      _workoutHistory.refresh(); // Reset the list
      _workoutHistory.assignAll(_workoutHistory
          .where((workout) => workout['machine'] == machine)
          .toList());
    }
  }

  void filterByBodyPart(String? bodyPart) {
    if (bodyPart != null && bodyPart.isNotEmpty) {
      _workoutHistory.refresh(); // Reset the list
      _workoutHistory.assignAll(_workoutHistory
          .where((workout) => workout['bodyPart'] == bodyPart)
          .toList());
    }
  }
}
