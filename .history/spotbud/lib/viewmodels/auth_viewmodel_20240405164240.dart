import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
          'customMachine': [
            {
              "bodypart": "Chest",
              "machine": [
                {"Single": true, "name": "Bench Press", "type": "weight"},
                {"Single": false, "name": "Incline Press", "type": "weight"},
                {"Single": false, "name": "Fly", "type": "weight"}
              ]
            },
            {
              "bodypart": "Back",
              "machine": [
                {"Single": true, "name": "Pull Up", "type": "reps"},
                {"Single": false, "name": "Deadlift", "type": "weight"},
                {"Single": false, "name": "Row", "type": "weight"}
              ]
            },
            {
              "bodypart": "Legs",
              "machine": [
                {"Single": true, "name": "Squat", "type": "weight"},
                {"Single": false, "name": "Leg Press", "type": "weight"},
                {"Single": false, "name": "Deadlift", "type": "weight"}
              ]
            },
            {
              "bodypart": "Arms",
              "machine": [
                {"Single": true, "name": "Bicep Curl", "type": "weight"},
                {"Single": true, "name": "Tricep Extension", "type": "weight"},
                {"Single": true, "name": "Hammer Curl", "type": "weight"}
              ]
            }
          ],

          // Initialize workoutHistory array
          'workoutHistory': [],
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

      // Save user data to Firestore if login is successful
      if (userCredential.user != null) {
        await saveUserDataFromEmailPassword(userCredential.user!);
      }

      return userCredential; // Return UserCredential if login is successful
    } catch (e) {
      print("Error signing in: $e");
      return null; // Return null if login fails
    }
  }

  Future<void> saveUserDataFromEmailPassword(User user) async {
    try {
      // Reference to the data collection and document for the current user
      CollectionReference data = _firestore.collection('data');
      DocumentReference userDoc = data.doc(user.uid);

      // Check if the user's document already exists in Firestore
      DocumentSnapshot userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        // Save the user's data to Firestore only if the document does not exist
        await userDoc.set({
          'firstName':
              '', // Initialize with empty string for email/password users
          'lastName':
              '', // Initialize with empty string for email/password users
          'email': user.email,

          'customMachine': [
            {
              "bodyPart": "Legs",
              "machineName": [
                "Squat Rack",
                "Leg Press",
                "Leg Curl",
                "Leg Extension"
              ]
            },
            {
              "bodyPart": "Chest",
              "machineName": [
                "Bench Press",
                "Dumbbell Press",
                "Chest Fly",
                "Push-up"
              ]
            },
            {
              "bodyPart": "Back",
              "machineName": [
                "Deadlift",
                "Pull-up",
                "Seated Row",
                "Lat Pulldown"
              ]
            },
            {
              "bodyPart": "Shoulders",
              "machineName": [
                "Military Press",
                "Lateral Raise",
                "Front Raise",
                "Shrug"
              ]
            },
            {
              "bodyPart": "Arms",
              "machineName": [
                "Bicep Curl",
                "Tricep Dip",
                "Hammer Curl",
                "Skull Crusher"
              ]
            }
          ]
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
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user data to Firestore if sign-up is successful
      if (userCredential.user != null) {
        await saveUserDataFromEmailPassword(userCredential.user!);
      }

      return userCredential; // Return UserCredential if sign-up is successful
    } catch (e) {
      print("Error signing up: $e");
      return null; // Return null if sign-up fails
    }
  }
}
