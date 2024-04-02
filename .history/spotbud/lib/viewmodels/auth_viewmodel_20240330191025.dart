import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';

class AuthViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Show a custom loading indicator using Get.dialog
      Get.dialog(
        LoadingIndicator(), // Your custom loading indicator widget
        barrierDismissible: false,
      );

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // Save user data to Firestore
        if (userCredential.user != null) {
          await saveUserDataFromGoogleSignIn(userCredential.user!);
        }

        // Close the custom loading indicator
        Get.back();

        return userCredential;
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    } finally {
      // Close the custom loading indicator even in case of an error
      Get.back();
    }
    return null;
  }

  // Future<void> saveUserDataFromGoogleSignIn(User user) async {
  //   try {
  //     // Reference to the users collection and document for the current user
  //     CollectionReference users = _firestore.collection('users');
  //     DocumentReference userDoc = users.doc(user.uid);

  //     // Save the user's data to Firestore
  //     await userDoc.set({
  //       'firstName': user.displayName!
  //           .split(' ')[0], // Extract first name from display name
  //       'lastName': user.displayName!
  //           .split(' ')[1], // Extract last name from display name
  //       'email': user.email,
  //       'workoutHistory': [],
  //     });

  //     // Update observables or do any other required tasks
  //   } catch (e) {
  //     print('Error saving user data from Google Sign-In: $e');
  //   }
  // }
  Future<void> saveUserDataFromGoogleSignIn(User user) async {
    try {
      // Reference to the users collection and document for the current user
      CollectionReference users = _firestore.collection('users');
      DocumentReference userDoc = users.doc(user.uid);

      // Check if the user's document already exists in Firestore
      DocumentSnapshot userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        // Save the user's data to Firestore only if the document does not exist
        await userDoc.set({
          'firstName': user.displayName!
              .split(' ')[0], // Extract first name from display name
          'lastName': user.displayName!
              .split(' ')[1], // Extract last name from display name
          'email': user.email,
          'workoutHistory': [],
        });
      } else {
        print('User data already exists in Firestore');
      }

      // Update observables or do any other required tasks
    } catch (e) {
      print('Error saving user data from Google Sign-In: $e');
    }
  }

  Future<UserCredential?> signUpWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential; // Return UserCredential if sign-up is successful
    } catch (e) {
      print("Error signing up: $e");
      return null; // Return null if sign-up fails
    }
  }

  Future<UserCredential?> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential; // Return UserCredential if login is successful
    } catch (e) {
      print("Error signing in: $e");
      return null; // Return null if login fails
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
