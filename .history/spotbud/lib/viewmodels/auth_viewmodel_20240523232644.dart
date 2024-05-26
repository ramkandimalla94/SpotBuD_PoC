import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spotbud/ui/view/auth/auth_verification.dart';

class AuthViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  RxBool isLoading = false.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // Save user data to Firestore
        if (userCredential.user != null) {
          await saveUserDataFromGoogleSignIn(userCredential.user!);
        }

        return userCredential;
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
    return null;
  }

  Future<void> saveUserDataFromGoogleSignIn(User user) async {
    try {
      // Reference to the data collection and document for the current user
      CollectionReference data = _firestore.collection('data');
      DocumentReference userDoc = data.doc(user.uid);

      // Check if the user's document already exists in Firestore
      DocumentSnapshot userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        // Save the user's data to Firestore only if the document does not exist
        await userDoc.set({
          'firstName': user.displayName!
              .split(' ')[0], // Extract first name from display name
          'lastName': user.displayName!
              .split(' ')[1], // Extract last name from display name
          'email': user.email,
          'weight': 0.00, // Initialize weight with zero
          'feet': 0, // Initialize feet with zero
          'inches': 0, // Initialize inches with zero
          'gender': 0,
          'hasInitialData': false,
          'isKgsPreferred': true,
          'customMachine': [
            {
              "bodypart": "Head",
              "machine": [
                {
                  "Single": false,
                  "name": "Neck Flexion",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Neck Extension",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Neck Lateral Flexion",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Neck Rotations",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Isometric Neck Exercise",
                  "type": "Strength: Time"
                },
                {
                  "Single": false,
                  "name": "Chin Tucks",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Neck Bridges",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Headstands",
                  "type": "Body Weight: Time"
                },
                {
                  "Single": false,
                  "name": "Shoulder Shrugs",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Resistance Band Neck Flexion",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Resistance Band Neck Extension",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Resistance Band Lateral Flexion",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Resistance Band Neck Rotations",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Neck Isometrics with Towel",
                  "type": "Strength: Time"
                },
                {
                  "Single": false,
                  "name": "Neck Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Levator Scapulae Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Scalene Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Suboccipital Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Thoracic Spine Mobility",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Cervical Retraction",
                  "type": "Strength: Reps"
                }
              ]
            },
            {
              "bodypart": "Neck",
              "machine": [
                {
                  "Single": false,
                  "name": "Neck Flexion",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Neck Extension",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Neck Lateral Flexion",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Neck Rotations",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Isometric Neck Exercise",
                  "type": "Strength: Time"
                },
                {
                  "Single": false,
                  "name": "Chin Tucks",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Neck Bridges",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Shoulder Shrugs",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Resistance Band Neck Flexion",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Resistance Band Neck Extension",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Resistance Band Lateral Flexion",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Resistance Band Neck Rotations",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Neck Isometrics with Towel",
                  "type": "Strength: Time"
                },
                {
                  "Single": false,
                  "name": "Neck Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Levator Scapulae Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Scalene Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Suboccipital Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Thoracic Spine Mobility",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Cervical Retraction",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Neck Curl Up",
                  "type": "Strength: Reps"
                }
              ]
            },,
          ],

          // Initialize workoutHistory array
        });
      } else {
        print('User data already exists in Firestore');
      }

      // Update observables or do any other required tasks
    } catch (e) {
      print('Error saving user data from Google Sign-In: $e');
    }
  }

  Future<UserCredential?> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Check if the user's email is verified
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        // Save user data to Firestore if login is successful
        // await saveUserDataFromEmailPassword(userCredential.user!);

        // Return UserCredential if login is successful
        return userCredential;
      } else {
        // If the email is not verified, redirect to the verify screen
        Get.offAll(VerifyScreen());
        return null;
      }
    } catch (e) {
      print("Error signing in: $e");
      return null; // Return null if login fails
    }
  }

  Future<void> saveUserDataFromEmailPassword({
    required User user,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    try {
      // Reference to the data collection and document for the current user
      CollectionReference data = _firestore.collection('data');
      DocumentReference userDoc = data.doc(user.uid);

      // Check if the user's document already exists in Firestore
      DocumentSnapshot userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        // Save the user's data to Firestore only if the document does not exist
        await userDoc.set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'weight': 0.00,
          'feet': 0,
          'inches': 0,
          'gender': 0,
          'hasInitialData': false,
          'isKgsPreferred': true,
          'customMachine': [
            {
              "bodypart": "Chest",
              "machine": [
                {
                  "Single": false,
                  "name": "Bench Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Incline Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Fly",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Chest Press Machine",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Push-ups",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Dumbbell Pullover",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Crossover",
                  "type": "Strength: Weight Reps"
                },
                {"Single": false, "name": "Dips", "type": "Body Weight: Reps"},
                {
                  "Single": false,
                  "name": "Decline Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Machine Chest Fly",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Back",
              "machine": [
                {
                  "Single": false,
                  "name": "Pull Up",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Deadlift",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Lat Pulldown",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "T-Bar Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Bent Over Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Seated Cable Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hyperextensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Romanian Deadlift",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Chin Up",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Legs",
              "machine": [
                {
                  "Single": false,
                  "name": "Squat",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Leg Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Deadlift",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Lunges",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Leg Curl Machine",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Leg Extension",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Bulgarian Split Squat",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Step Ups",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Glute Bridge",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Arms",
              "machine": [
                {
                  "Single": false,
                  "name": "Bicep Curl",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Tricep Extension",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hammer Curl",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Tricep Dip",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Preacher Curl",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Skull Crushers",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Concentration Curl",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Tricep Kickback",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Curl",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Close Grip Bench Press",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Biceps",
              "machine": [
                {
                  "Single": true,
                  "name": "Barbell Curl",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Preacher Curl",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Dumbbell Curl",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Cable Curl",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Hammer Curl",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Incline Dumbbell Curl",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Concentration Curl",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Reverse Curl",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "EZ Bar Curl",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Spider Curl",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Triceps",
              "machine": [
                {
                  "Single": true,
                  "name": "Tricep Extension",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Tricep Dip",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Skull Crushers",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Tricep Kickback",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Close Grip Bench Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Overhead Tricep Extension",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Cable Tricep Pushdown",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Dumbbell Tricep Kickback",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Reverse Grip Tricep Pushdown",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": true,
                  "name": "Tricep Rope Pushdown",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Shoulders",
              "machine": [
                {
                  "Single": false,
                  "name": "Shoulder Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Lateral Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Front Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Fly",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Upright Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Arnold Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Shrugs",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Face Pulls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Lying Lateral Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cuban Press",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Abs",
              "machine": [
                {
                  "Single": false,
                  "name": "Crunches",
                  "type": "Body Weight: Reps"
                },
                {"Single": false, "name": "Plank", "type": "Body Weight: Time"},
                {
                  "Single": false,
                  "name": "Russian Twists",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Hanging Leg Raises",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Bicycle Crunches",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Mountain Climbers",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Leg Raises",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Woodchoppers",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Flutter Kicks",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Side Plank",
                  "type": "Body Weight: Time"
                }
              ]
            },
            {
              "bodypart": "Cardio",
              "machine": [
                {
                  "Single": false,
                  "name": "Treadmill",
                  "type": "Cardio: Time, Distance, Kcal"
                },
                {
                  "Single": false,
                  "name": "Stationary Bike",
                  "type": "Cardio: Time, Distance, Kcal"
                },
                {
                  "Single": false,
                  "name": "Elliptical",
                  "type": "Cardio: Time, Distance, Kcal"
                },
                {
                  "Single": false,
                  "name": "Stair Climber",
                  "type": "Cardio: Time, Distance, Kcal"
                },
                {
                  "Single": false,
                  "name": "Rowing Machine",
                  "type": "Cardio: Time, Distance, Kcal"
                },
                {
                  "Single": false,
                  "name": "Jump Rope",
                  "type": "Cardio: Time, Distance, Kcal"
                },
                {
                  "Single": false,
                  "name": "Swimming",
                  "type": "Cardio: Time, Distance, Kcal"
                },
                {
                  "Single": false,
                  "name": "High-Intensity Interval Training (HIIT)",
                  "type": "Cardio: Time, Distance, Kcal"
                },
                {
                  "Single": false,
                  "name": "Cycling",
                  "type": "Cardio: Time, Distance, Kcal"
                },
                {
                  "Single": false,
                  "name": "Jogging",
                  "type": "Cardio: Time, Distance, Kcal"
                }
              ]
            }
          ],

          // Initialize workoutHistory array
        });
      } else {
        print('User data already exists in Firestore');
      }

      // Update observables or do any other required tasks
    } catch (e) {
      print('Error saving user data from email/password: $e');
    }
  }

  Future<UserCredential?> signUpWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await sendEmailVerification();

      return userCredential;
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      print("Error sending email verification: $e");
    }
  }
}
