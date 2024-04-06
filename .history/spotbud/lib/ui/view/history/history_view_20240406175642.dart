import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';

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
                  child: LoadingIndicator(),
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

                    // Extract workout details
                    final date = workoutLog['date'];
                    final startTime = workoutLog['startTime'];
                    final endTime = workoutLog['endTime'];
                    final exercises = workoutLog['exercises'] as List<dynamic>;

                    // Build a list of widgets to display each exercise
                    List<Widget> exerciseWidgets = [];
                    for (var exercise in exercises) {
                      final exerciseName = exercise['name'];
                      final sets = exercise['sets'] as List<dynamic>;
                      List<Widget> setWidgets = [];
                      for (var set in sets) {
                        final reps = set['reps'];
                        final weight = set['weight'];
                        final notes = set['notes'];
                        // Build a widget for each set
                        setWidgets.add(
                          ListTile(
                            title: Text('Reps: $reps, Weight: $weight'),
                            subtitle: Text('Notes: $notes'),
                          ),
                        );
                      }
                      // Build a widget for each exercise
                      exerciseWidgets.add(
                        ExpansionTile(
                          title: Text(exerciseName),
                          children: setWidgets,
                        ),
                      );
                    }

                    // Add your UI components here to display workout logs
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: $date'),
                            Text('Start Time: $startTime'),
                            Text('End Time: $endTime'),
                            Divider(),
                            ...exerciseWidgets, // Display exercise details
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }));
  }
}
