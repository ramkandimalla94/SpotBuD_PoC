import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/link_launcher.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String capitalize(String s) => s.isNotEmpty
      ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}'
      : '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: AppTheme.primaryText(
            size: 32,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/bodydetail');
            },
            icon: const Icon(
              Icons.edit,
              color: AppColors.black,
            ),
          )
        ],
        centerTitle: true,
        backgroundColor: AppColors.acccentColor,
      ),
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [],
                    ),

                    Container(
                      child: Center(
                        child: Obx(
                          () => Text(
                            '${capitalize(_userDataViewModel.firstName.value)} ${capitalize(_userDataViewModel.lastName.value)}',
                            style: const TextStyle(
                                fontSize: 25,
                                color: AppColors.backgroundColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Text(
                          'Mail ',
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.backgroundColor,
                          ),
                        ),
                        Spacer(),
                        Obx(
                          () => Text(
                            '${_userDataViewModel.email.value}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppColors.backgroundColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Divider(),
                    TextButton(
                      onPressed: () {
                        // Navigate to Body Details screen
                        Get.toNamed('/bodydetail');
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons
                                .info_outline, // Replace with your desired icon
                            color: CupertinoColors.systemBlue, // Icon color
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // Add spacing between icon and title
                          Text(
                            "Body Details",
                            style: TextStyle(
                              fontSize: 16,
                              color: CupertinoColors.systemBlue, // Text color
                            ),
                          ),
                          Spacer(), // Add spacing between title and arrow
                          Icon(
                            CupertinoIcons.forward, // Arrow icon
                            color: CupertinoColors.systemBlue, // Arrow color
                          ),
                        ],
                      ),
                    ),

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Theme',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Image.asset(
                          AppAssets.sun,
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                            width: 2), // Add spacing between label and switch
                        Switch(
                          value: _userDataViewModel.isLightTheme.value,
                          onChanged: (value) {
                            setState(() {
                              _userDataViewModel.isLightTheme.value = value;
                            });
                          },
                          activeColor: AppColors.acccentColor,
                        ),
                        SizedBox(
                            width: 2), // Add spacing between switch and label
                        Image.asset(
                          AppAssets.moon,
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    CupertinoTextSelectionToolbarButton(
                      onPressed: () {
                        LinkLauncher.launchURL(
                            'https://play.google.com/store/apps/details?id=com.ram.spotbud');
                      },
                      child: Text("Rate App"),
                    ),

                    SizedBox(height: 20),
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
