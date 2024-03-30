// user_data_viewmodel.dart

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxString firstName = ''.obs;
  final RxString lastName = ''.obs;
  final RxString email = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Map<String, dynamic>> workoutHistory =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserNames();
    fetchWorkoutHistory(); // Fetch workout history when the ViewModel initializes
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

  Future<void> fetchWorkoutHistory() async {
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
              List<dynamic> historyList = userData['workoutHistory'];
              List<Map<String, dynamic>> parsedHistoryList = [];

              // Parsing each history item
              historyList.forEach((item) {
                if (item is Map<String, dynamic>) {
                  parsedHistoryList.add(item);
                }
              });

              workoutHistory.value = parsedHistoryList;
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching workout history: $e');
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
              this.email.value = email ?? '';
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
