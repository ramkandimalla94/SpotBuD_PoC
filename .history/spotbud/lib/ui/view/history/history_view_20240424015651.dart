import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class HistoryView extends StatefulWidget {
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> _workoutLogsStream;
  String? _selectedBodyPart;
  String? _selectedMachine;
  List<String> _loggedBodyParts = [];
  List<String> _loggedMachines = [];

  bool _isKgsPreferred = true; // Default preference is kilograms

  @override
  void initState() {
    super.initState();
    _fetchWorkoutLogs();
    _checkWeightPreference();
  }

  Future<void> _checkWeightPreference() async {
    // Fetch user's weight preference from UserViewModel using Get.find()
    final userDataViewModel = Get.find<UserDataViewModel>();
    _isKgsPreferred = userDataViewModel.isKgsPreferred.value;
  }

  void _resetFilters() {
    setState(() {
      _selectedBodyPart = null;
      _selectedMachine = null;
    });
  }

  Future<void> _fetchWorkoutLogs() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        _workoutLogsStream = _firestore
            .collection('data')
            .doc(userId)
            .collection('workouts')
            .orderBy('timestamp', descending: true)
            .snapshots();

        // Fetch logged body parts and machines
        final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('data')
            .doc(userId)
            .collection('workouts')
            .get();

        setState(() {
          _loggedBodyParts = _extractLoggedBodyParts(snapshot.docs);
          _loggedMachines = _extractLoggedMachines(snapshot.docs);
        });
      }
    } catch (e) {
      print('Error fetching workout logs: $e');
    }
  }

  List<String> _extractLoggedBodyParts(List<QueryDocumentSnapshot> logs) {
    final Set<String> bodyParts = Set<String>();
    logs.forEach((log) {
      final List<dynamic>? exercises = log['exercises'];
      if (exercises != null) {
        exercises.forEach((exercise) {
          bodyParts.add(exercise['bodyPart']);
        });
      }
    });
    return bodyParts.toList();
  }

  List<String> _extractLoggedMachines(List<QueryDocumentSnapshot> logs) {
    final Set<String> machines = Set<String>();
    logs.forEach((log) {
      final List<dynamic>? exercises = log['exercises'];
      if (exercises != null) {
        exercises.forEach((exercise) {
          machines.add(exercise['machine']);
        });
      }
    });
    return machines.toList();
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
            List<DateTime> dates = _extractDates(workoutLogs);
            List<DateTime> filteredDates = _filteredDates(dates, workoutLogs);
            return ListView.builder(
              itemCount: filteredDates.length,
              itemBuilder: (context, index) {
                final date = filteredDates[index];
                final dateFormatted = DateFormat('yyyy-MM-dd').format(date);
                final workoutsForDate =
                    _filterWorkoutsByDate(workoutLogs, date);
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(date),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var workout in workoutsForDate)
                            ..._buildWorkoutDetails(workout['exercises']),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildWorkoutDetails(List<dynamic>? exercises) {
    if (exercises == null || exercises.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'No exercises recorded.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        )
      ];
    }

    return exercises.map<Widget>((exercise) {
      final bodyPart = exercise['bodyPart'] as String?;
      final exerciseName = exercise['machine'] as String?;
      final sets = exercise['sets'] as List<dynamic>?;
      if (bodyPart == null || exerciseName == null || sets == null) {
        return SizedBox.shrink();
      }

      final exerciseDetails = sets.map<Widget>((set) {
        final reps = set['reps'] as String?;
        final weight = set['weight'] as String?;
        final notes = set['notes'] as String?;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$exerciseName:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Reps: ${reps ?? 'N/A'}, Weight: $_convertWeight(weight)',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              if (notes != null && notes.isNotEmpty)
                Text(
                  'Notes: $notes',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        );
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: exerciseDetails,
      );
    }).toList();
  }

  String _convertWeight(String? weight) {
    if (_isKgsPreferred) {
      // If preferred weight unit is kilograms, return weight as it is
      return '$weight kg';
    } else {
      // Convert weight from kilograms to pounds
      final double? kg = double.tryParse(weight ?? '');
      if (kg != null) {
        final double lbs = kg * 2.20462;
        return lbs.toStringAsFixed(2) + ' lbs';
      } else {
        return 'N/A';
      }
    }
  }

  List<DateTime> _filteredDates(
      List<DateTime> allDates, List<DocumentSnapshot> logs) {
    return allDates.where((date) {
      final filteredWorkouts = _filterWorkoutsByDate(logs, date);
      return filteredWorkouts.isNotEmpty;
    }).toList();
  }

  List<DateTime> _extractDates(List<DocumentSnapshot> logs) {
    final dates = <DateTime>{};
    logs.forEach((log) {
      final timestamp = log['timestamp'] as Timestamp;
      final date =
          DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
      dates.add(DateTime(date.year, date.month, date.day));
    });
    return dates.toList()..sort((a, b) => b.compareTo(a));
  }

  List<DocumentSnapshot<Object?>> _filterWorkoutsByDate(
      List<DocumentSnapshot<Object?>> logs, DateTime date) {
    return logs.where((log) {
      final timestamp = log['timestamp'] as Timestamp;
      final logDate =
          DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
      return DateTime(logDate.year, logDate.month, logDate.day) ==
          DateTime(date.year, date.month, date.day);
    }).toList();
  }
}
