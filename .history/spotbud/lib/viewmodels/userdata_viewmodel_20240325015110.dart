import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NameViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserName(String firstName, String lastName) async {
    try {
      // Get the current user from FirebaseAuth
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;
        String email = user.email ?? '';

        // Reference to the users collection and document for the current user
        CollectionReference users = _firestore.collection('users');
        DocumentReference userDoc = users.doc(userId);

        // Save the user's data to Firestore
        await userDoc.set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
        });

        // Navigate to the next screen (e.g., '/trial') after saving the data
        Get.offNamed('/trial');
      } else {
        print('User not authenticated');
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Future<List<String>?> fetchUserNames() async {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get the user's email address
      String email = user.email ?? '';

      // Query Firestore to get the user document based on the email address
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      // Extract the first name and last name from the user document
// Extract the first name and last name from the user document
      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
        if (userData != null) {
          String? firstName = userData['firstname'];
          String? lastName = userData['lastname'];
          if (firstName != null && lastName != null) {
            return [firstName, lastName];
          }
        }
      }
    }
    return null; // Return null if user is not found or not logged in
  }
}
