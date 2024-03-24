import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/button.dart'; // Import GetX

class Trial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dead End'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block,
              size: 50,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Dead End',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            buildLoginButton(
                text: "Log Out",
                onPressed: () {
                  Get.offAllNamed('/login');
                })
          ],
        ),
      ),
    );
  }
}
