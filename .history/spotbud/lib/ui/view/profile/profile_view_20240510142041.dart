import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  saveThemeStatus() async {
    SharedPreferences pref = await _prefs;
    pref.setBool('theme', _userDataViewModel.isLightTheme.value);
  }

  String capitalize(String s) => s.isNotEmpty
      ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}'
      : '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PROFILE",
          style: AppTheme.primaryText(
            size: 27,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/bodydetail');
            },
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.background,
            ),
          )
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
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
                            style: TextStyle(
                                fontSize: 25,
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      child: Center(
                        child: Text(
                          'Trainee',
                          style: const TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          'Mail ',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Obx(
                          () => Text(
                            '${_userDataViewModel.email.value}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Unit',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Spacer(),
                        Text(
                          'lbs',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary, // Customize color as needed
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
                            color: Theme.of(context)
                                .colorScheme
                                .secondary, // Customize color as needed
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
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Spacer(),
                        Image.asset(
                          AppAssets.sun,
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                            width: 2), // Add spacing between label and switch
                        ObxValue(
                          (data) => Switch(
                            value: _userDataViewModel.isLightTheme.value,
                            onChanged: (value) {
                              setState(() {
                                _userDataViewModel.isLightTheme.value = value;
                                Get.changeThemeMode(
                                    _userDataViewModel.isLightTheme.value
                                        ? ThemeMode.dark
                                        : ThemeMode.light);
                                saveThemeStatus();
                              });
                            },
                            activeColor: AppColors.acccentColor,
                          ),
                          _userDataViewModel.isLightTheme,
                        ),

                        SizedBox(
                            width: 2), // Add spacing between switch and label
                        Image.asset(
                          AppAssets.moon,
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 6),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(),
                    TextButton(
                      onPressed: () {
                        // Navigate to Body Details screen
                        Get.toNamed('/bodyinfo');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.boy_rounded, // Replace with your desired icon
                            color: Theme.of(context)
                                .colorScheme
                                .secondary, // Icon color
                            size: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // Add spacing between icon and title
                          Text(
                            "Body Details",
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary, // Text color
                            ),
                          ),
                          Spacer(), // Add spacing between title and arrow
                          Icon(
                            CupertinoIcons.forward, // Arrow icon
                            color: Theme.of(context)
                                .colorScheme
                                .secondary, // Arrow color
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        LinkLauncher.launchURL(
                            'https://play.google.com/store/apps/details?id=com.ram.spotbud');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.reviews, // Replace with your desired icon
                            color: Theme.of(context)
                                .colorScheme
                                .secondary, // Icon color
                            size: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // Add spacing between icon and title
                          Text(
                            "Rate on Play Store",
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary, // Text color
                            ),
                          ),
                          Spacer(), // Add spacing between title and arrow
                          Icon(
                            CupertinoIcons.forward, // Arrow icon
                            color: Theme.of(context)
                                .colorScheme
                                .secondary, // Arrow color
                          ),
                        ],
                      ),
                    ),
                    //  const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Divider(),
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
