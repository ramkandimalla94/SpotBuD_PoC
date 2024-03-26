import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> signInWithEmailPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true; // Return true if login is successful
    } catch (e) {
      print("Error signing in: $e");
      return false; // Return false if login fails
    }
  }

  Future<bool> signUpWithEmailPassword(
      String email, String password, String firstName, String lastName) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store user's name in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      });

      return true; // Return true if sign-up is successful
    } catch (e) {
      print("Error signing up: $e");
      return false; // Return false if sign-up fails
    }
  }

  Future<void> saveWorkoutLog({
    required String bodyPart,
    required String machine,
    required List<Map<String, dynamic>> sets,
  }) async {
    try {
      // Get the current user from FirebaseAuth
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        // Reference to the workouts collection
        CollectionReference workouts = _firestore.collection('workouts');

        // Save the workout log to Firestore
        await workouts.add({
          'userId': userId,
          'timestamp': Timestamp.now(),
          'bodyPart': bodyPart,
          'machine': machine,
          'sets': sets,
        });
      } else {
        print('User not authenticated');
      }
    } catch (e) {
      print('Error saving workout log: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchWorkoutHistory() async {
    List<Map<String, dynamic>> workoutHistory = [];

    try {
      // Get the current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get the user ID
        String userId = user.uid;

        // Reference to the workouts collection
        CollectionReference workouts = _firestore.collection('workouts');

        // Query workout logs for the current user
        QuerySnapshot querySnapshot = await workouts
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .get();

        // Extract workout log data
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic>? workoutData =
              doc.data() as Map<String, dynamic>?;

          if (workoutData != null) {
            workoutHistory.add(workoutData);
          }
        });
      }
    } catch (e) {
      print('Error fetching workout history: $e');
    }

    return workoutHistory;
  }
}
