import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final UserDataViewModel _userDataViewModel = Get.put(UserDataViewModel());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isKgsPreferred = true; // Default to kgs

  @override
  void initState() {
    super.initState();
    // _fetchUserData();
  }

  // Future<void> _fetchUserData() async {
  //   await _userDataViewModel.fetchUserData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: AppTheme.primaryText(
            size: 32,
            color: AppColors.acccentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    Row(
                      children: [
                        Text(
                          'User Details ',
                          style: AppTheme.primaryText(
                            size: 32,
                            color: AppColors.acccentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Get.toNamed('/bodydetail');
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.backgroundColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => Text(
                        'Name: ${_userDataViewModel.firstName.value} ${_userDataViewModel.lastName.value}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => Text(
                        'Email: ${_userDataViewModel.email.value}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => Text(
                        'Height: ${_userDataViewModel.feet.value} ft ${_userDataViewModel.inches.value} in',
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => Text(
                        'Weight: ${_userDataViewModel.convertWeightIfNeeded(_userDataViewModel.weight.value)} ${_userDataViewModel.getDisplayWeightUnit()}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      String genderString = _userDataViewModel.gender.value
                          .toString()
                          .split('.')[1];
                      return Text(
                        'Gender: $genderString',
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.secondaryColor,
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    Obx(() {
                      String lifestyleString = _userDataViewModel
                          .lifestyle.value
                          .toString()
                          .split('.')[1];
                      return Text(
                        'Lifestyle: $lifestyleString',
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.secondaryColor,
                        ),
                      );
                    }),
                    //  const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Preferred Weight Unit:',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'lbs',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white, // Customize color as needed
                          ),
                        ),
                        SizedBox(
                            width: 2), // Add spacing between label and switch
                        Switch(
                          value: _userDataViewModel.isKgsPreferred.value,
                          onChanged: (value) {
                            setState(() {
                              _userDataViewModel.isKgsPreferred.value = value;
                              saveWeightUnitPreference(value);
                            });
                          },
                          activeColor: AppColors.acccentColor,
                        ),
                        SizedBox(
                            width: 2), // Add spacing between switch and label
                        Text(
                          'kgs',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white, // Customize color as needed
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: buildLoginButton(
                text: "Log Out",
                onPressed: () {
                  _logout(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                AppAssets.logogolden,
                width: 250,
              ),
            ),
            const SizedBox(height: 20), // Add some space between text and logo
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      Get.offAllNamed('/login'); // Navigate to login screen after logout
    } catch (e) {
      print('Error during logout: $e');
      // Handle error if logout fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout failed. Please try again.'),
        ),
      );
    }
  }

  Future<void> saveWeightUnitPreference(bool isKgsPreferred) async {
    try {
      User? user = _auth.currentUser;
      if (_isKgsPreferred) {}
      if (user != null) {
        String userId = user.uid;
        await _firestore.collection('data').doc(userId).update({
          'isKgsPreferred': isKgsPreferred,
        });
        // Update observable
        // Assuming you have a separate observable for isKgsPreferred
        // Update it here if necessary
      }
    } catch (e) {
      print('Error saving weight unit preference: $e');
    }
  }
}
