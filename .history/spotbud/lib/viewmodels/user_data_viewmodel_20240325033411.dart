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

        // Capitalize the first letter of the first name and last name
        String capitalizedFirstName = firstName.substring(0, 1).toUpperCase() +
            firstName.substring(1).toLowerCase();
        String capitalizedLastName = lastName.substring(0, 1).toUpperCase() +
            lastName.substring(1).toLowerCase();

        // Reference to the users collection and document for the current user
        CollectionReference users = _firestore.collection('users');
        DocumentReference userDoc = users.doc(userId);

        // Save the user's data to Firestore
        await userDoc.set({
          'firstname': capitalizedFirstName,
          'lastname': capitalizedLastName,
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
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);
        DocumentSnapshot userSnapshot = await userDocRef.get();
        if (userSnapshot.exists) {
          var userData = userSnapshot.data();
          if (userData != null && userData is Map<String, dynamic>) {
            String? firstName = userData['firstname'];
            String? lastName = userData['lastname'];
            if (firstName != null && lastName != null) {
              this.firstName.value = firstName;
              this.lastName.value = lastName;
              print('First Name: $firstName');
              print('Last Name: $lastName');
            } else {
              print('First name or Last name is null');
            }
          } else {
            print('userData is null or not a Map<String, dynamic>');
          }
        } else {
          print('User document does not exist');
        }
      } else {
        print('User is null');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
