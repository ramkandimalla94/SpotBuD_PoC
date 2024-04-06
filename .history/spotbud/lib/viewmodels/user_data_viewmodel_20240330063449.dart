import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotbud/ui/widgets/assets.dart';

class UserDataViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;

  // Getter for body parts
  List<String> get bodyParts => [
        'Legs',
        'Chest',
        'Back',
        'Arms',
        'Shoulders',
        // Add more body parts here if needed
      ];
  final Map<String, List<Map<String, dynamic>>> machines = {
    'Legs': [
      {'name': 'Squat Rack', 'imagePath': AppAssets.legs},
      {'name': 'Leg Press', 'imagePath': AppAssets.legs},
      {'name': 'Leg Curl', 'imagePath': AppAssets.legs},
      {'name': 'Leg Extension', 'imagePath': AppAssets.legs},
    ],
    'Chest': [
      {'name': 'Bench Press', 'imagePath': AppAssets.chest},
      {'name': 'Dumbbell Press', 'imagePath': AppAssets.chest},
      {'name': 'Chest Fly', 'imagePath': AppAssets.chest},
      {'name': 'Push-up', 'imagePath': AppAssets.chest},
    ],
    'Back': [
      {'name': 'Deadlift', 'imagePath': AppAssets.back},
      {'name': 'Pull-up', 'imagePath': AppAssets.back},
      {'name': 'Seated Row', 'imagePath': AppAssets.back},
      {'name': 'Lat Pulldown', 'imagePath': AppAssets.back},
    ],
    'Shoulders': [
      {'name': 'Military Press', 'imagePath': AppAssets.shoulder},
      {'name': 'Lateral Raise', 'imagePath': AppAssets.shoulder},
      {'name': 'Front Raise', 'imagePath': AppAssets.shoulder},
      {'name': 'Shrug', 'imagePath': AppAssets.shoulder},
    ],
    'Arms': [
      {'name': 'Bicep Curl', 'imagePath': AppAssets.arms},
      {'name': 'Tricep Dip', 'imagePath': AppAssets.arms},
      {'name': 'Hammer Curl', 'imagePath': AppAssets.arms},
      {'name': 'Skull Crusher', 'imagePath': AppAssets.arms},
    ],
  };

  // Method to get machines associated with a body part
  List<String> getMachinesForBodyPart(String bodyPart) {
    List<Map<String, dynamic>> machinesForBodyPart = machines[bodyPart] ?? [];
    return machinesForBodyPart.map((machine) => machine['name']).toList();
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