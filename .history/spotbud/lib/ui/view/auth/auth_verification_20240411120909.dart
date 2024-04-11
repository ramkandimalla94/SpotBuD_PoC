import 'package:flutter/material.dart';

class EmailVerificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Your Email'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please verify your email address.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              Text(
                'A verification link has been sent to your email. Click on the link to verify your email address.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
