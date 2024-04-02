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

  // Getter for body parts
  // List<String> get bodyParts => [
  //       'Legs',
  //       'Chest',
  //       'Back',
  //       'Arms',
  //       'Shoulders',
  //       // Add more body parts here if needed
  //     ];
  final List<Map<String, dynamic>> machines = MachineData.getMachines();

  List<String> getMachinesForBodyPart(String bodyPart) {
    // Filter machines based on the provided body part
    List<String> machinesForBodyPart = machines
        .where((machine) => machine['bodyPart'] == bodyPart)
        .map((machine) => machine['name'] as String)
        .toList();

    return machinesForBodyPart;
  }

  // Method to fetch distinct machines from workout history
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

  // Method to fetch distinct body parts from workout history
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

  Future<void> saveUserData(
      String userId, String email, String firstName, String lastName) async {
    try {
      String capitalizedFirstName = firstName.substring(0, 1).toUpperCase() +
          firstName.substring(1).toLowerCase();
      String capitalizedLastName = lastName.substring(0, 1).toUpperCase() +
          lastName.substring(1).toLowerCase();

      CollectionReference users = _firestore.collection('users');
      DocumentReference userDoc = users.doc(userId);

      await userDoc.set({
        'firstName': capitalizedFirstName,
        'lastName': capitalizedLastName,
        'email': email,
        'workoutHistory': [],
        'customMachine': [
          {
            "bodyPart": "Legs",
            "machineNames": [
              "Squat Rack",
              "Leg Press",
              "Leg Curl",
              "Leg Extension"
            ]
          },
          {
            "bodyPart": "Chest",
            "machineNames": [
              "Bench Press",
              "Dumbbell Press",
              "Chest Fly",
              "Push-up"
            ]
          },
          {
            "bodyPart": "Back",
            "machineNames": [
              "Deadlift",
              "Pull-up",
              "Seated Row",
              "Lat Pulldown"
            ]
          },
          {
            "bodyPart": "Shoulders",
            "machineNames": [
              "Military Press",
              "Lateral Raise",
              "Front Raise",
              "Shrug"
            ]
          },
          {
            "bodyPart": "Arms",
            "machineNames": [
              "Bicep Curl",
              "Tricep Dip",
              "Hammer Curl",
              "Skull Crusher"
            ]
          }
        ]
      });

      this.email.value = email;
      this.firstName.value = capitalizedFirstName;
      this.lastName.value = capitalizedLastName;
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Future<void> addWorkoutDetails(Map<String, dynamic> workoutData) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);

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
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;

        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);

        DocumentSnapshot userSnapshot = await userDocRef.get();

        if (userSnapshot.exists) {
          Map<String, dynamic>? userData =
              userSnapshot.data() as Map<String, dynamic>?;
          if (userData != null && userData['workoutHistory'] != null) {
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
          if (userData is Map<String, dynamic>) {
            String? firstName = userData['firstName'];
            String? lastName = userData['lastName'];
            String? email = userData['email'];
            if (firstName != null && lastName != null) {
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
}
