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
            },
            {
              "bodypart": "Chest & Back",
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
                },
                {
                  "Single": false,
                  "name": "Pull-ups",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Lat Pulldown",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Seated Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Bent Over Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Deadlift",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Single Arm Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "T-Bar Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Face Pull",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Back Extension",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Inverted Row",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Chest Supported Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Renegade Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Kettlebell Swing",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Fly",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Chin-ups",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Good Mornings",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Smith Machine Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Landmine Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Trap Bar Deadlift",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Superman Exercise",
                  "type": "Body Weight: Time"
                },
                {
                  "Single": false,
                  "name": "Hyperextensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Standing Cable Pullover",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Dumbbell Bench Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Incline Dumbbell Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Decline Dumbbell Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Dumbbell Fly",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Pec Deck Machine",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Smith Machine Bench Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Resistance Band Chest Press",
                  "type": "Strength: Resistance Reps"
                }
              ]
            },
            {
              "bodypart": "Lower Body",
              "machine": [
                {
                  "Single": false,
                  "name": "Leg Raise",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Flutter Kicks",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Scissor Kicks",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Hanging Leg Raise",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Crunch",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Mountain Climbers",
                  "type": "Body Weight: Reps"
                },
                {"Single": false, "name": "Plank", "type": "Body Weight: Time"},
                {
                  "Single": false,
                  "name": "Side Plank",
                  "type": "Body Weight: Time"
                },
                {
                  "Single": false,
                  "name": "Russian Twists",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Bicycle Crunches",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Toe Touches",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Heel Taps",
                  "type": "Body Weight: Reps"
                },
                {"Single": false, "name": "V-Ups", "type": "Body Weight: Reps"},
                {
                  "Single": false,
                  "name": "Crunches",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Seated Leg Tucks",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Standing Side Crunch",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Ab Wheel Rollouts",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Crunch",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Decline Bench Sit-ups",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Medicine Ball Slams",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Abdomen",
              "machine": [
                {
                  "Single": false,
                  "name": "Crunches",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Crunches",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Leg Raises",
                  "type": "Body Weight: Reps"
                },
                {"Single": false, "name": "Plank", "type": "Body Weight: Time"},
                {
                  "Single": false,
                  "name": "Side Plank",
                  "type": "Body Weight: Time"
                },
                {
                  "Single": false,
                  "name": "Russian Twists",
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
                  "name": "Ab Wheel Rollouts",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Plank with Leg Raise",
                  "type": "Body Weight: Time"
                },
                {
                  "Single": false,
                  "name": "Flutter Kicks",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Scissor Kicks",
                  "type": "Body Weight: Reps"
                },
                {"Single": false, "name": "V-Ups", "type": "Body Weight: Reps"},
                {
                  "Single": false,
                  "name": "Toe Touches",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Seated Leg Tucks",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Heel Taps",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Crunch",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Decline Bench Sit-ups",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Medicine Ball Slams",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hanging Leg Raises",
                  "type": "Body Weight: Reps"
                }
              ]
            },
            {
              "bodypart": "Upper Legs",
              "machine": [
                {
                  "Single": false,
                  "name": "Squats",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Leg Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Lunges",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Leg Extensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Leg Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hack Squats",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Step-ups",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hip Thrusts",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Romanian Deadlifts",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Sumo Squats",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Bulgarian Split Squats",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Barbell Hip Thrusts",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Single-leg Deadlifts",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Quad Extensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hamstring Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Hip Abductions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Hip Adductions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Inner Thigh Machine",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Outer Thigh Machine",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Knees",
              "machine": [
                {
                  "Single": false,
                  "name": "Straight Leg Raises",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Wall Sits",
                  "type": "Strength: Time"
                },
                {
                  "Single": false,
                  "name": "Seated Knee Extensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Quad Sets",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Hamstring Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Leg Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Step-ups",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Biking (Stationary or Outdoor)",
                  "type": "Cardio: Time"
                },
                {"Single": false, "name": "Swimming", "type": "Cardio: Time"},
                {
                  "Single": false,
                  "name": "Tai Chi",
                  "type": "Flexibility: Time"
                },
                {"Single": false, "name": "Yoga", "type": "Flexibility: Time"},
                {"Single": false, "name": "Pilates", "type": "Strength: Time"},
                {
                  "Single": false,
                  "name": "Resistance Band Knee Flexion",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Resistance Band Knee Extension",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Foam Rolling",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Leg Raises on a Machine",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Stair Climbing",
                  "type": "Cardio: Time"
                },
                {
                  "Single": false,
                  "name": "Elliptical Training",
                  "type": "Cardio: Time"
                },
                {
                  "Single": false,
                  "name": "Squats with Proper Form",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Lower Legs",
              "machine": [
                {
                  "Single": false,
                  "name": "Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Seated Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Standing Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Toe Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Ankle Circles",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Dorsiflexion with Resistance Band",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Plantarflexion with Resistance Band",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Calf Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Heel Walks",
                  "type": "Strength: Distance"
                },
                {
                  "Single": false,
                  "name": "Toe Walks",
                  "type": "Strength: Distance"
                },
                {
                  "Single": false,
                  "name": "Single Leg Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {"Single": false, "name": "Jump Rope", "type": "Cardio: Time"},
                {
                  "Single": false,
                  "name": "Calf Press on Leg Press Machine",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Calf Stretch with Wall",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Tibialis Anterior Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Seated Toe Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Standing Toe Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Inverted Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Ankle Alphabet",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Ballet Point and Flex",
                  "type": "Strength: Reps"
                }
              ]
            },
            {
              "bodypart": "Feet",
              "machine": [
                {
                  "Single": false,
                  "name": "Toe Flexion and Extension",
                  "type": "Flexibility: Reps"
                },
                {
                  "Single": false,
                  "name": "Ankle Alphabet",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Heel Raises",
                  "type": "Strength: Weight Reps"
                },
                {"Single": false, "name": "Toe Taps", "type": "Strength: Reps"},
                {
                  "Single": false,
                  "name": "Foot Circles",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Toe Yoga",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Marble Pickup",
                  "type": "Flexibility: Reps"
                },
                {
                  "Single": false,
                  "name": "Foot Roll",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Arch Lifts",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Toe Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Ankle Circles",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Ankle Flexion and Extension",
                  "type": "Flexibility: Reps"
                },
                {
                  "Single": false,
                  "name": "Foot Flexion and Extension",
                  "type": "Flexibility: Reps"
                },
                {
                  "Single": false,
                  "name": "Heel Walks",
                  "type": "Strength: Distance"
                },
                {
                  "Single": false,
                  "name": "Toe Walks",
                  "type": "Strength: Distance"
                },
                {
                  "Single": false,
                  "name": "Foot Massage",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Toe Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Foot Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Ankle Strengthening Exercises with Resistance Band",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Towel Scrunches",
                  "type": "Strength: Reps"
                }
              ]
            },
            {
              "bodypart": "Shoulders",
              "machine": [
                {
                  "Single": false,
                  "name": "Dumbbell Shoulder Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Barbell Shoulder Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Arnold Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Front Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Lateral Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Rear Delt Flyes",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Shoulder Shrugs",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Upright Rows",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Push Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Push-ups (Wide Grip)",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Push-ups (Close Grip)",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Dumbbell Front Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Dumbbell Lateral Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Shoulder Press Machine",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Lateral Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Front Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Face Pulls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Single Arm Dumbbell Shoulder Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Seated Dumbbell Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Shoulder Taps",
                  "type": "Body Weight: Reps"
                }
              ]
            },
            {
              "bodypart": "Upper Arms",
              "machine": [
                {
                  "Single": false,
                  "name": "Bicep Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hammer Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Preacher Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Bicep Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Tricep Extensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Tricep Dips",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Skull Crushers",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Close Grip Bench Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Overhead Tricep Extension",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Tricep Kickbacks",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Tricep Pushdowns",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Barbell Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hammer Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Zottman Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Hammer Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Grip Tricep Pushdowns",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Diamond Push-ups",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Close Grip Push-ups",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Spider Curls",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Lower Arms",
              "machine": [
                {
                  "Single": false,
                  "name": "Wrist Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Wrist Extensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Wrist Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Wrist Extensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hammer Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Wrist Roller",
                  "type": "Strength: Time"
                },
                {
                  "Single": false,
                  "name": "Forearm Twist with Barbell",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Forearm Plank",
                  "type": "Body Weight: Time"
                },
                {
                  "Single": false,
                  "name": "Grip Strengthener",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Farmer's Walk",
                  "type": "Strength: Distance"
                },
                {
                  "Single": false,
                  "name": "Wrist Flexor Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Wrist Extensor Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Finger Extension Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Flexion Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Squeeze Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Wrist Circles",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Wrist Flexor Stretch with Bar",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Wrist Extensor Stretch with Bar",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Forearm Massage",
                  "type": "Flexibility: Time"
                }
              ]
            },
            {
              "bodypart": "Hands",
              "machine": [
                {
                  "Single": false,
                  "name": "Hand Grippers",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Extensions with Rubber Band",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Wrist Curls with Dumbbells",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Flexion Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Abduction Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Thumb Flexion Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Wrist Circles",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Wrist Flexor Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Wrist Extensor Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Finger Squeeze Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Pinch Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Taps Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Lifts Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Circles Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Wrist Roller",
                  "type": "Strength: Time"
                },
                {
                  "Single": false,
                  "name": "Finger Wave Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Hand Grip Twist Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Hand Grip Strengthening Ball Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Stretch Exercise",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Finger Roll Exercise",
                  "type": "Strength: Reps"
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
            },
            {
              "bodypart": "Chest & Back",
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
                },
                {
                  "Single": false,
                  "name": "Pull-ups",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Lat Pulldown",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Seated Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Bent Over Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Deadlift",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Single Arm Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "T-Bar Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Face Pull",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Back Extension",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Inverted Row",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Chest Supported Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Renegade Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Kettlebell Swing",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Fly",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Chin-ups",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Good Mornings",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Smith Machine Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Landmine Row",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Trap Bar Deadlift",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Superman Exercise",
                  "type": "Body Weight: Time"
                },
                {
                  "Single": false,
                  "name": "Hyperextensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Standing Cable Pullover",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Dumbbell Bench Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Incline Dumbbell Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Decline Dumbbell Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Dumbbell Fly",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Pec Deck Machine",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Smith Machine Bench Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Resistance Band Chest Press",
                  "type": "Strength: Resistance Reps"
                }
              ]
            },
            {
              "bodypart": "Lower Body",
              "machine": [
                {
                  "Single": false,
                  "name": "Leg Raise",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Flutter Kicks",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Scissor Kicks",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Hanging Leg Raise",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Crunch",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Mountain Climbers",
                  "type": "Body Weight: Reps"
                },
                {"Single": false, "name": "Plank", "type": "Body Weight: Time"},
                {
                  "Single": false,
                  "name": "Side Plank",
                  "type": "Body Weight: Time"
                },
                {
                  "Single": false,
                  "name": "Russian Twists",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Bicycle Crunches",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Toe Touches",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Heel Taps",
                  "type": "Body Weight: Reps"
                },
                {"Single": false, "name": "V-Ups", "type": "Body Weight: Reps"},
                {
                  "Single": false,
                  "name": "Crunches",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Seated Leg Tucks",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Standing Side Crunch",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Ab Wheel Rollouts",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Crunch",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Decline Bench Sit-ups",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Medicine Ball Slams",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Upper Legs",
              "machine": [
                {
                  "Single": false,
                  "name": "Squats",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Leg Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Lunges",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Leg Extensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Leg Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hack Squats",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Step-ups",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hip Thrusts",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Romanian Deadlifts",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Sumo Squats",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Bulgarian Split Squats",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Barbell Hip Thrusts",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Single-leg Deadlifts",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Quad Extensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hamstring Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Hip Abductions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Hip Adductions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Inner Thigh Machine",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Outer Thigh Machine",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Knees",
              "machine": [
                {
                  "Single": false,
                  "name": "Straight Leg Raises",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Wall Sits",
                  "type": "Strength: Time"
                },
                {
                  "Single": false,
                  "name": "Seated Knee Extensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Quad Sets",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Hamstring Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Leg Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Step-ups",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Biking (Stationary or Outdoor)",
                  "type": "Cardio: Time"
                },
                {"Single": false, "name": "Swimming", "type": "Cardio: Time"},
                {
                  "Single": false,
                  "name": "Tai Chi",
                  "type": "Flexibility: Time"
                },
                {"Single": false, "name": "Yoga", "type": "Flexibility: Time"},
                {"Single": false, "name": "Pilates", "type": "Strength: Time"},
                {
                  "Single": false,
                  "name": "Resistance Band Knee Flexion",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Resistance Band Knee Extension",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Foam Rolling",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Leg Raises on a Machine",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Stair Climbing",
                  "type": "Cardio: Time"
                },
                {
                  "Single": false,
                  "name": "Elliptical Training",
                  "type": "Cardio: Time"
                },
                {
                  "Single": false,
                  "name": "Squats with Proper Form",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Lower Legs",
              "machine": [
                {
                  "Single": false,
                  "name": "Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Seated Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Standing Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Toe Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Ankle Circles",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Dorsiflexion with Resistance Band",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Plantarflexion with Resistance Band",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Calf Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Heel Walks",
                  "type": "Strength: Distance"
                },
                {
                  "Single": false,
                  "name": "Toe Walks",
                  "type": "Strength: Distance"
                },
                {
                  "Single": false,
                  "name": "Single Leg Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {"Single": false, "name": "Jump Rope", "type": "Cardio: Time"},
                {
                  "Single": false,
                  "name": "Calf Press on Leg Press Machine",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Calf Stretch with Wall",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Tibialis Anterior Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Seated Toe Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Standing Toe Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Inverted Calf Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Ankle Alphabet",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Ballet Point and Flex",
                  "type": "Strength: Reps"
                }
              ]
            },
            {
              "bodypart": "Feet",
              "machine": [
                {
                  "Single": false,
                  "name": "Toe Flexion and Extension",
                  "type": "Flexibility: Reps"
                },
                {
                  "Single": false,
                  "name": "Ankle Alphabet",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Heel Raises",
                  "type": "Strength: Weight Reps"
                },
                {"Single": false, "name": "Toe Taps", "type": "Strength: Reps"},
                {
                  "Single": false,
                  "name": "Foot Circles",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Toe Yoga",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Marble Pickup",
                  "type": "Flexibility: Reps"
                },
                {
                  "Single": false,
                  "name": "Foot Roll",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Arch Lifts",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Toe Raises",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Ankle Circles",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Ankle Flexion and Extension",
                  "type": "Flexibility: Reps"
                },
                {
                  "Single": false,
                  "name": "Foot Flexion and Extension",
                  "type": "Flexibility: Reps"
                },
                {
                  "Single": false,
                  "name": "Heel Walks",
                  "type": "Strength: Distance"
                },
                {
                  "Single": false,
                  "name": "Toe Walks",
                  "type": "Strength: Distance"
                },
                {
                  "Single": false,
                  "name": "Foot Massage",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Toe Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Foot Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Ankle Strengthening Exercises with Resistance Band",
                  "type": "Strength: Resistance Reps"
                },
                {
                  "Single": false,
                  "name": "Towel Scrunches",
                  "type": "Strength: Reps"
                }
              ]
            },
            {
              "bodypart": "Shoulders",
              "machine": [
                {
                  "Single": false,
                  "name": "Dumbbell Shoulder Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Barbell Shoulder Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Arnold Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Front Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Lateral Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Rear Delt Flyes",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Shoulder Shrugs",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Upright Rows",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Push Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Push-ups (Wide Grip)",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Push-ups (Close Grip)",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Dumbbell Front Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Dumbbell Lateral Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Shoulder Press Machine",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Lateral Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Front Raise",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Face Pulls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Single Arm Dumbbell Shoulder Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Seated Dumbbell Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Shoulder Taps",
                  "type": "Body Weight: Reps"
                }
              ]
            },
            {
              "bodypart": "Upper Arms",
              "machine": [
                {
                  "Single": false,
                  "name": "Bicep Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hammer Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Preacher Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Bicep Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Tricep Extensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Tricep Dips",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Skull Crushers",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Close Grip Bench Press",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Overhead Tricep Extension",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Tricep Kickbacks",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Tricep Pushdowns",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Barbell Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hammer Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Zottman Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Cable Hammer Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Grip Tricep Pushdowns",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Diamond Push-ups",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Close Grip Push-ups",
                  "type": "Body Weight: Reps"
                },
                {
                  "Single": false,
                  "name": "Spider Curls",
                  "type": "Strength: Weight Reps"
                }
              ]
            },
            {
              "bodypart": "Lower Arms",
              "machine": [
                {
                  "Single": false,
                  "name": "Wrist Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Wrist Extensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Wrist Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Wrist Extensions",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Hammer Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Reverse Curls",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Wrist Roller",
                  "type": "Strength: Time"
                },
                {
                  "Single": false,
                  "name": "Forearm Twist with Barbell",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Forearm Plank",
                  "type": "Body Weight: Time"
                },
                {
                  "Single": false,
                  "name": "Grip Strengthener",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Farmer's Walk",
                  "type": "Strength: Distance"
                },
                {
                  "Single": false,
                  "name": "Wrist Flexor Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Wrist Extensor Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Finger Extension Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Flexion Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Squeeze Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Wrist Circles",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Wrist Flexor Stretch with Bar",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Wrist Extensor Stretch with Bar",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Forearm Massage",
                  "type": "Flexibility: Time"
                }
              ]
            },
            {
              "bodypart": "Hands",
              "machine": [
                {
                  "Single": false,
                  "name": "Hand Grippers",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Extensions with Rubber Band",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Wrist Curls with Dumbbells",
                  "type": "Strength: Weight Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Flexion Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Abduction Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Thumb Flexion Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Wrist Circles",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Wrist Flexor Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Wrist Extensor Stretch",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Finger Squeeze Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Pinch Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Taps Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Lifts Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Circles Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Wrist Roller",
                  "type": "Strength: Time"
                },
                {
                  "Single": false,
                  "name": "Finger Wave Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Hand Grip Twist Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Hand Grip Strengthening Ball Exercise",
                  "type": "Strength: Reps"
                },
                {
                  "Single": false,
                  "name": "Finger Stretch Exercise",
                  "type": "Flexibility: Time"
                },
                {
                  "Single": false,
                  "name": "Finger Roll Exercise",
                  "type": "Strength: Reps"
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