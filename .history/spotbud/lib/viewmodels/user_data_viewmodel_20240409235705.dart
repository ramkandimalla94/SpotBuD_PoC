import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/gender.dart';

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
  Rx<double> weight = 0.0.obs;
  Rx<int> feet = 0.obs;
  Rx<int> inches = 0.obs;
  Rx<Gender> gender = Gender.Other.obs;
  RxBool hasInitialData = false.obs;

  // Define getter for startDate
  DateTime? get startDateValue => startDate.value;

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
          weight.value = (data['weight'] ?? 0.0).toDouble();
          feet.value = data['feet'] ?? 0;
          inches.value = data['inches'] ?? 0;
          gender.value = Gender.values[data['gender'] ?? Gender.Other.index];
          hasInitialData.value = true;
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

  Future<void> saveBodyDetails(
      double weight, int feet, int inches, Gender gender) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        await _firestore.collection('data').doc(userId).update({
          'weight': weight,
          'feet': feet,
          'inches': inches,
          'gender': gender.index, // Save index of the selected gender
        });
        // Update observables
        this.weight.value = weight;
        this.feet.value = feet;
        this.inches.value = inches;
        this.gender.value = gender;
        hasInitialData.value = true;
        print('User data saved successfully');
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Parse integer to Gender enum
  Gender _parseGender(int? index) {
    if (index != null && index >= 0 && index < Gender.values.length) {
      return Gender.values[index];
    } else {
      return Gender.Male; // Default to Other if index is out of bounds
    }
  }

  // Save user data to Firestore

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
}