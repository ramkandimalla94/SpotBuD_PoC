import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotbud/ui/viewmodels/auth_viewmodel.dart';

class NameViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> saveUserName(String firstName, String lastName) async {
    try {
      // Get the current user from FirebaseAuth
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        // Reference to the users collection and document for the current user
        CollectionReference users = _firestore.collection('users');
        DocumentReference userDoc = users.doc(userId);

        // Save the user's name to Firestore
        await userDoc.set({
          'firstName': firstName,
          'lastName': lastName,
        });

        // Navigate to the next screen (e.g., '/trial') after saving the name
        Get.offNamed('/trial');
      } else {
        print('User not authenticated');
      }
    } catch (e) {
      print('Error saving user name: $e');
    }
  }
}
