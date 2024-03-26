import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class ProfileView extends StatelessWidget {
  final UserDataViewModel _nameViewModel = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 60,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome,',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Obx(() => Text(
                  '${_nameViewModel.firstName.value} ${_nameViewModel.lastName.value}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                )),
            SizedBox(height: 10),
            Obx(() => Text(
                  '${_nameViewModel.email.value}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                )),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
            ),
          ],
        ),
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
