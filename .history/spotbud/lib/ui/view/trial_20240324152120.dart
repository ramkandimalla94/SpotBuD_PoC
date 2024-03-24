// lib/view/screens/dead_end_screen.dart

import 'package:flutter/material.dart';

class Trial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dead End'),
      ),
      body: const Center(
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
          ],
        ),
      ),
    );
  }
}
