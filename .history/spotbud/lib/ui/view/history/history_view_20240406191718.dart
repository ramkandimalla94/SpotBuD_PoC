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
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No workout logs available.'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final workoutLogs = snapshot.data!.docs;
            List<DateTime> dates = _extractDates(workoutLogs);
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildBodyPartFilter()),
                    SizedBox(width: 10),
                    Expanded(child: _buildMachineFilter()),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      final date = dates[index];
                      final dateFormatted =
                          DateFormat('yyyy-MM-dd').format(date);
                      final workouts = _filterWorkoutsByDate(workoutLogs, date);

                      return ExpansionTile(
                        trailing: Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.acccentColor,
                        ),
                        title: Text(
                          DateFormat('yyyy-MM-dd').format(date),
                          style: AppTheme.secondaryText(
                            size: 22,
                            fontWeight: FontWeight.w500,
                            color: AppColors.acccentColor,
                          ),
                        ),
                        children: [
                          for (var i = 0; i < workouts.length; i++)
                            ExpansionTile(
                              trailing: Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.backgroundColor,
                              ),
                              title: Text(
                                'Start time:' +
                                    (workouts[i]['startTime'] as String? ??
                                        'N/A'),
                                style: AppTheme.secondaryText(
                                  size: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.backgroundColor,
                                ),
                              ),
                              children: _buildWorkoutDetails(
                                  workouts[i]['exercises']),
                            ),
                        ],
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
        });
      },
      items: _loggedBodyParts.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList()
        ..insert(
            0,
            DropdownMenuItem<String>(
                value: null, child: Text('Select Body Part'))),
      hint: Text('Select Body Part'),
    );
  }

  Widget _buildMachineFilter() {
    return DropdownButton<String>(
      value: _selectedMachine,
      onChanged: (newValue) {
        setState(() {
          _selectedMachine = newValue;
        });
      },
      items: _loggedMachines.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList()
        ..insert(
            0,
            DropdownMenuItem<String>(
                value: null, child: Text('Select Machine'))),
      hint: Text('Select Machine'),
    );
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

  List<Map<String, dynamic>> _filterWorkoutsByDate(
      List<DocumentSnapshot> logs, DateTime date) {
    return logs
        .where((log) {
          final timestamp = log['timestamp'] as Timestamp;
          final logDate =
              DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
          return DateTime(logDate.year, logDate.month, logDate.day) ==
              DateTime(date.year, date.month, date.day);
        })
        .where((log) {
          // Filter based on selected body part
          if (_selectedBodyPart != null) {
            final List<dynamic>? exercises = log['exercises'];
            if (exercises != null) {
              return exercises
                  .any((exercise) => exercise['bodyPart'] == _selectedBodyPart);
            } else {
              return false;
            }
          } else {
            return true;
          }
        })
        .where((log) {
          // Filter based on selected machine
          if (_selectedMachine != null) {
            final List<dynamic>? exercises = log['exercises'];
            if (exercises != null) {
              return exercises
                  .any((exercise) => exercise['machine'] == _selectedMachine);
            } else {
              return false;
            }
          } else {
            return true;
          }
        })
        .map((log) => log.data() as Map<String, dynamic>)
        .toList();
  }

  List<Widget> _buildWorkoutDetails(List<dynamic>? exercises) {
    // Same as before
  }
}
