// lib/view/screens/dead_end_screen.dart

import 'package:flutter/material.dart';
import 'package:spotbud/ui/widgets/button.dart';

class Trial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dead End'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.block,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'Dead End',
              style: TextStyle(fontSize: 24),
            ),
            buildLoginButton(
              height: 60,
              width: 200,
              text: 'Go Back to Login',
              onPressed: () {
                // Navigate back to the login page
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
