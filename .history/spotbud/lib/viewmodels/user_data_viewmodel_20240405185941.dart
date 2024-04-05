import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserDataViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  Rx<String?> bodyPart = Rx<String?>(null);
  Rx<String?> exerciseName = Rx<String?>(null);

  // Define getter for startDate
  DateTime? get startDateValue => startDate.value;

  // Method to update filters
  void updateFilters({
    DateTime? newStartDate,
    DateTime? newEndDate,
    String? newBodyPart,
    String? newExerciseName,
  }) {
    startDate.value = newStartDate;
    endDate.value = newEndDate;
    bodyPart.value = newBodyPart;
    exerciseName.value = newExerciseName;
  }

  // Fetch user data from Firestore and update the observables
  Future<void> fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentSnapshot userData =
            await _firestore.collection('data').doc(userId).get();
        if (userData.exists) {
          Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
          firstName.value = data['firstName'] ?? '';
          lastName.value = data['lastName'] ?? '';
          email.value = data['email'] ?? '';
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> saveWorkoutLog(Map<String, dynamic> workoutData) async {
    try {
      // Get the current user from FirebaseAuth
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        // Reference to the data collection
        CollectionReference dataCollection = _firestore.collection('data');

        // Save the workout log to Firestore
        await dataCollection.doc(userId).collection('workouts').add({
          'timestamp': Timestamp.now(),
          ...workoutData, // Spread operator to add workoutData fields
        });
      } else {
        print('User not authenticated');
      }
    } catch (e) {
      print('Error saving workout log: $e');
    }
  }

  Future<void> fetchUserNames() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('data').doc(userId);
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
              this.email.value = email ?? '';
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

  // Save user data to Firestore
  Future<void> saveUserData(String firstName, String lastName) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        await _firestore.collection('data').doc(userId).set({
          'firstName': firstName,
          'lastName': lastName,
          'email': user.email,
          'customMachine': [
            {
              "bodypart": "Legs",
              "machine": [
                {"Single": false, "name": "Squat Rack", "type": "Machine"}
              ]
            },
            {
              "bodypart": "Chest",
              "machine": [
                {"Single": true, "name": "Bench Press", "type": "Machine"}
              ]
            }
            // Add more default custom machines if needed
          ],
          'workoutHistory': [],
        });
        this.firstName.value = firstName;
        this.lastName.value = lastName;
        print('User data saved successfully');
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Add workout details to Firestore
  Future<void> addWorkoutDetails(Map<String, dynamic> workoutData) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        await _firestore.collection('data').doc(userId).update({
          'workoutHistory': FieldValue.arrayUnion([workoutData]),
        });
        print('Workout details added successfully');
      }
    } catch (e) {
      print('Error adding workout details: $e');
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchWorkoutHistory() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userId = currentUser.uid;
        final querySnapshot = await FirebaseFirestore.instance
            .collection('data')
            .doc(userId)
            .collection('workouts')
            .get();

        Map<String, List<Map<String, dynamic>>> workoutHistory = {};
        querySnapshot.docs.forEach((doc) {
          final workoutData = doc.data();
          final timestamp = workoutData['timestamp'] as Timestamp;
          final date = DateFormat('yyyy-MM-dd').format(timestamp.toDate());

          if (!workoutHistory.containsKey(date)) {
            workoutHistory[date] = [];
          }
          workoutHistory[date]!.add(workoutData);
        });

        return workoutHistory;
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      print('Error fetching workout history: $e');
      throw e; // Rethrow the error
    }
  }
}
