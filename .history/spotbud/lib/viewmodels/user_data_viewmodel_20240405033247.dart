import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotbud/core/models/machines.dart';
import 'package:spotbud/ui/widgets/assets.dart';

class UserDataViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;

  // Fetch user data from Firestore and update the observables
  Future<void> fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentSnapshot userData =
            await _firestore.collection('data').doc(userId).get();
        if (userData.exists) {
          Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
          firstName.value = data['firstName'] ?? '';
          lastName.value = data['lastName'] ?? '';
          email.value = data['email'] ?? '';
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Save user data to Firestore
  Future<void> saveUserData(String firstName, String lastName) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        await _firestore.collection('data').doc(userId).set({
          'firstName': firstName,
          'lastName': lastName,
          'email': user.email,
          'customMachine': [
            {
              "bodypart": "Legs",
              "machine": [
                {"Single": false, "name": "Squat Rack", "type": "Machine"}
              ]
            },
            {
              "bodypart": "Chest",
              "machine": [
                {"Single": true, "name": "Bench Press", "type": "Machine"}
              ]
            }
            // Add more default custom machines if needed
          ],
          'workoutHistory': [],
        });
        this.firstName.value = firstName;
        this.lastName.value = lastName;
        print('User data saved successfully');
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Add workout details to Firestore
  Future<void> addWorkoutDetails(Map<String, dynamic> workoutData) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        await _firestore.collection('data').doc(userId).update({
          'workoutHistory': FieldValue.arrayUnion([workoutData]),
        });
        print('Workout details added successfully');
      }
    } catch (e) {
      print('Error adding workout details: $e');
    }
  }

  // Fetch workout history from Firestore
  Future<List<Map<String, dynamic>>> fetchWorkoutHistory() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentSnapshot userData =
            await _firestore.collection('data').doc(userId).get();
        if (userData.exists) {
          Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
          List<Map<String, dynamic>> workoutHistory =
              List<Map<String, dynamic>>.from(data['workoutHistory'] ?? []);
          return workoutHistory;
        }
      }
      return [];
    } catch (e) {
      print('Error fetching workout history: $e');
      return [];
    }
  }
}
