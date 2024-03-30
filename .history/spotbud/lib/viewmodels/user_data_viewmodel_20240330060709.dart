import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;

  Future<void> saveUserData(
      String userId, String email, String firstName, String lastName) async {
    try {
      String capitalizedFirstName = firstName.substring(0, 1).toUpperCase() +
          firstName.substring(1).toLowerCase();
      String capitalizedLastName = lastName.substring(0, 1).toUpperCase() +
          lastName.substring(1).toLowerCase();

      // Reference to the users collection and document for the current user
      CollectionReference users = _firestore.collection('users');
      DocumentReference userDoc = users.doc(userId);

      // Save the user's data to Firestore
      await userDoc.set({
        'firstName': capitalizedFirstName,
        'lastName': capitalizedLastName,
        'email': email,
        'workoutHistory': [],
      });

      // Update observables
      this.email.value = email;
      this.firstName.value = capitalizedFirstName;
      this.lastName.value = capitalizedLastName;
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Future<void> addWorkoutDetails(Map<String, dynamic> workoutData) async {
    try {
      // Get the current user from FirebaseAuth
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        // Reference to the user document in Firestore
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);

        // Add the workout details to the user's workout history
        await userDocRef.update({
          'workoutHistory': FieldValue.arrayUnion([workoutData]),
        });
      } else {
        print('User not authenticated');
      }
    } catch (e) {
      print('Error adding workout details: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchWorkoutHistory() async {
    try {
      // Get the current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get the user ID
        String userId = user.uid;

        // Reference to the user document in Firestore
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);

        // Fetch the user document
        DocumentSnapshot userSnapshot = await userDocRef.get();

        if (userSnapshot.exists) {
          // Extract workout history
          Map<String, dynamic>? userData =
              userSnapshot.data() as Map<String, dynamic>?;
          if (userData != null && userData['workoutHistory'] != null) {
            // Check if 'workoutHistory' exists and is a List<Map<String, dynamic>>
            if (userData['workoutHistory'] is List) {
              return List<Map<String, dynamic>>.from(
                  userData['workoutHistory']);
            }
          }
        }
      }
      return [];
    } catch (e) {
      print('Error fetching workout history: $e');
      return [];
    }
  }

  Future<List<String>> fetchDistinctBodyParts() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);
        DocumentSnapshot userSnapshot = await userDocRef.get();
        if (userSnapshot.exists) {
          Map<String, dynamic>? userData =
              userSnapshot.data() as Map<String, dynamic>?;
          if (userData != null && userData['workoutHistory'] != null) {
            List<dynamic> workoutHistory = userData['workoutHistory'];
            Set<String> bodyParts = Set<String>();
            workoutHistory.forEach((workout) {
              bodyParts.add(workout['bodyPart']);
            });
            return bodyParts.toList();
          }
        }
      }
      return [];
    } catch (e) {
      print('Error fetching distinct body parts: $e');
      return [];
    }
  }

  Future<void> fetchUserNames() async {
    try {
      // Get the current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      //print(user);
      if (user != null) {
        // Get the user ID
        String userId = user.uid;
        //  print(userId);
        // Reference to the user document in Firestore
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);
        // print(userDocRef);
        // Fetch the user document
        DocumentSnapshot userSnapshot = await userDocRef.get();
        //  print(userSnapshot);
        // Check if the user document exists and contains data
        if (userSnapshot.exists) {
          // Extract first name and last name
          var userData = userSnapshot.data();
          // print('userData type: ${userData.runtimeType}');
          // print('userData value: $userData');
          if (userData is Map<String, dynamic>) {
            String? firstName = userData['firstName'];
            String? lastName = userData['lastName'];
            String? email = userData['email'];
            if (firstName != null && lastName != null) {
              // Update firstName and lastName values
              this.firstName.value = firstName;
              this.lastName.value = lastName;
              print(firstName);
              print(lastName);
              print(email);
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

  Future<List<String>> fetchDistinctMachines() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);
        DocumentSnapshot userSnapshot = await userDocRef.get();
        if (userSnapshot.exists) {
          Map<String, dynamic>? userData =
              userSnapshot.data() as Map<String, dynamic>?;
          if (userData != null && userData['workoutHistory'] != null) {
            List<dynamic> workoutHistory = userData['workoutHistory'];
            Set<String> machines = Set<String>();
            workoutHistory.forEach((workout) {
              machines.add(workout['machine']);
            });
            return machines.toList();
          }
        }
      }
      return [];
    } catch (e) {
      print('Error fetching distinct machines: $e');
      return [];
    }
  }
}
