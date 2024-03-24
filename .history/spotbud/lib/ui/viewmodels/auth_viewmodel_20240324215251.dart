import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signInWithEmailPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true; // Return true if login is successful
    } catch (e) {
      print("Error signing in: $e");
      return false; // Return false if login fails
    }
  }

  Future<bool> signUpWithEmailPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true; // Return true if sign-up is successful
    } catch (e) {
      print("Error signing up: $e");
      return false; // Return false if sign-up fails
    }
  }

  Future<void> storeUserName(String firstName, String lastName) async {
    try {
      // Get the current user ID
      String userId = _auth.currentUser!.uid;
      if (userId != null) {
        // Store the user's name in Firestore
        await _firestore.collection('users').doc(userId).set({
          'firstName': firstName,
          'lastName': lastName,
        });
      }
    } catch (e) {
      print("Error storing user name: $e");
      throw e;
    }
  }
}
