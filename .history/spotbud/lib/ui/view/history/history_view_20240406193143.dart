import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/ui/widgets/text.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchWorkoutLogs();
    _resetFilters();
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

        _loggedBodyParts = _extractLoggedBodyParts(snapshot.docs);
        _loggedMachines = _extractLoggedMachines(snapshot.docs);
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
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.acccentColor),
        title: Text(
          'Workout History',
          style: AppTheme.secondaryText(
            size: 22,
            fontWeight: FontWeight.w500,
            color: AppColors.acccentColor,
          ),
        ),
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
            final List<DocumentSnapshot<Object?>> logs =
                snapshot.data!.docs.toList();
            final List<String> allMachines = _extractLoggedMachines(logs);
            final List<String> filteredMachines = _selectedBodyPart == null
                ? allMachines
                : allMachines.where((machine) => logs.any((log) {
                      final List<dynamic>? exercises = log['exercises'];
                      return exercises != null &&
                          exercises.any(
                              (exercise) => exercise['machine'] == machine);
                    }));
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildBodyPartFilter()),
                    SizedBox(width: 10),
                    Expanded(child: _buildMachineFilter(filteredMachines)),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      final timestamp = log['timestamp'] as Timestamp;
                      final date = DateTime.fromMillisecondsSinceEpoch(
                          timestamp.seconds * 1000);
                      final dateFormatted =
                          DateFormat('yyyy-MM-dd').format(date);
                      return ListTile(
                        title: Text(dateFormatted),
                        // You can add more details to the list tile as needed
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildBodyPartFilter() {
    return DropdownButton<String>(
      value: _selectedBodyPart,
      onChanged: (newValue) {
        setState(() {
          _selectedBodyPart = newValue;
          if (_selectedBodyPart == null) {
            _selectedMachine = null;
          }
        });
      },
      items: _loggedBodyParts.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      hint: Text('Select Body Part'),
    );
  }

  Widget _buildMachineFilter(List<String> machines) {
    return DropdownButton<String>(
      value: _selectedMachine,
      onChanged: (newValue) {
        setState(() {
          _selectedMachine = newValue;
        });
      },
      items: machines.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      hint: Text('Select Machine'),
    );
  }
}
