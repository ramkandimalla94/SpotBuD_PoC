import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class ProfileView extends StatelessWidget {
  final UserDataViewModel _nameViewModel = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 120),
                  Text(
                    'Welcome,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Obx(() => Text(
                        'Name: ${_nameViewModel.firstName.value} ${_nameViewModel.lastName.value}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
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
                              color: Colors.blue,
                            ),
                          );
                        } else {
                          return Text(
                            'Email: Not available',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                            ),
                          );
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Image.asset(
              'assets/logogolden.png',
              width: 150,
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
