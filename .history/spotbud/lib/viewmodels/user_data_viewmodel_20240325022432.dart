import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NameViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;

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

  Future<void> fetchUserNames() async {
    try {
      // Get the current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      print(user);
      if (user != null) {
        // Get the user ID
        String userId = user.uid;
        print(userId);
        // Reference to the user document in Firestore
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);
        print(userDocRef);
        // Fetch the user document
        DocumentSnapshot userSnapshot = await userDocRef.get();
        print(userSnapshot);
        // Check if the user document exists and contains data
        if (userSnapshot.exists) {
          // Extract first name and last name
          var userData = userSnapshot.data();
          print('userData type: ${userData.runtimeType}');
          print('userData value: $userData');
          if (userData is Map<String, dynamic>) {
            String? firstName = userData['firstname'];
            String? lastName = userData['lastname'];
            if (firstName != null && lastName != null) {
              // Update firstName and lastName values
              this.firstName.value = firstName;
              this.lastName.value = lastName;
              print(firstName);
            }
          } else {
            print('userData is not a Map<String, dynamic>');
          }
        } else {
          print('User document does not exist');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
