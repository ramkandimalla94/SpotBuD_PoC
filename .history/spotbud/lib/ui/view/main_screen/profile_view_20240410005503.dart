import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class ProfileView extends StatelessWidget {
  final UserDataViewModel _nameViewModel = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Text(
                          'Welcome ',
                          style: AppTheme.primaryText(
                            size: 32,
                            color: AppColors.acccentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              Get.toNamed('/bodydetail');
                            },
                            icon: Icon(
                              Icons.edit,
                              color: AppColors.backgroundColor,
                            ))
                      ],
                    ),
                    SizedBox(height: 60),
                    Obx(() => Text(
                          'Name: ${_nameViewModel.firstName.value} ${_nameViewModel.lastName.value}',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.secondaryColor,
                          ),
                        )),
                    SizedBox(height: 10),
                    // Fetch and display email from FirebaseAuth currentUser
                    FutureBuilder<User?>(
                      future: Future.value(_auth.currentUser),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData && snapshot.data != null) {
                            String? email = snapshot.data!.email;
                            return Text(
                              'Email: $email',
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.secondaryColor,
                              ),
                            );
                          } else {
                            return Text(
                              'Email: Not available',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                              ),
                            );
                          }
                        } else {
                          return LoadingIndicator();
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Obx(() => Text(
                          'Height: ${_nameViewModel.feet.value} ft ${_nameViewModel.inches.value} in',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.secondaryColor,
                          ),
                        )),
                    SizedBox(height: 10),
                    Obx(() => Text(
                          'Weight: ${_nameViewModel.weight.value} kg',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.secondaryColor,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: buildWorkoutButton(
                text: "Log Out",
                onPressed: () {
                  _logout(context);
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Image.asset(
              AppAssets.logogolden,
              width: 250,
            ),
          ),
          SizedBox(height: 20), // Add some space between text and logo
        ],
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
        SnackBar(
          content: Text('Logout failed. Please try again.'),
        ),
      );
    }
  }
}
