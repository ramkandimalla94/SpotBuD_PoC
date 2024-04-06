import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryView extends StatefulWidget {
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> _workoutLogsStream = Stream<QuerySnapshot>.empty();

  @override
  void initState() {
    super.initState();
    _fetchWorkoutLogs();
  }

  void _fetchWorkoutLogs() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        String userId = user.uid;
        _workoutLogsStream = _firestore
            .collection('data')
            .doc(userId)
            .collection('workouts')
            .orderBy('timestamp', descending: true)
            .snapshots();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _workoutLogsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final workoutLogs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: workoutLogs.length,
              itemBuilder: (context, index) {
                final workoutLog =
                    workoutLogs[index].data() as Map<String, dynamic>;
                final timestamp = workoutLog['timestamp'] as Timestamp;
                final formattedDate = DateTime.fromMillisecondsSinceEpoch(
                        timestamp.seconds * 1000)
                    .toString();
                // Add your UI components here to display workout logs
                return ListTile(
                  title: Text('Workout on $formattedDate'),
                  // Additional details can be displayed here
                );
              },
            );
          }
        },
      ),
    );
  }
}
