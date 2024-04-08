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

        // Set initial selected body part and machine
        if (_loggedBodyParts.isNotEmpty) {
          _selectedBodyPart = _loggedBodyParts[0];
        }
        if (_loggedMachines.isNotEmpty) {
          _selectedMachine = _loggedMachines[0];
        }
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
              color: AppColors.acccentColor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilters(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _workoutLogsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingIndicator(),
                  );
                } else if (snapshot.data == null ||
                    snapshot.data!.docs.isEmpty) {
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
                  return ListView.builder(
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
                        title: DropdownMenuItem<DateTime>(
                          value: date,
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(date),
                            style: AppTheme.secondaryText(
                                size: 22,
                                fontWeight: FontWeight.w500,
                                color: AppColors.acccentColor),
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
                                    color: AppColors.backgroundColor),
                              ),
                              children: _buildWorkoutDetails(
                                  workouts[i]['exercises']),
                            ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        _buildBodyPartFilter(),
        SizedBox(width: 10),
        _buildMachineFilter(),
      ],
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
      }).toList(),
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
      }).toList(),
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
        .map((log) => log.data() as Map<String, dynamic>)
        .toList();
  }

  List<Widget> _buildWorkoutDetails(List<dynamic>? exercises) {
    if (exercises == null || exercises.isEmpty) {
      return [
        Text(
          'No exercises recorded.',
          style: AppTheme.secondaryText(
              size: 22,
              fontWeight: FontWeight.w500,
              color: AppColors.acccentColor),
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

      final setWidgets = sets.map<Widget>((set) {
        final reps = set['reps'] as String?;
        final weight = set['weight'] as String?;
        final notes = set['notes'] as String?;

        return ListTile(
          title: Text(
            'Reps: ${reps ?? 'N/A'}, Weight: ${weight ?? 'N/A'}',
            style: AppTheme.secondaryText(
                size: 17,
                fontWeight: FontWeight.w500,
                color: AppColors.backgroundColor),
          ),
          subtitle: Text(
            'Notes: ${notes ?? 'N/A'}',
            style: AppTheme.secondaryText(
                size: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.backgroundColor),
          ),
        );
      }).toList();

      return ExpansionTile(
        trailing: Icon(
          Icons.arrow_drop_down,
          color: AppColors.acccentColor,
        ),
        title: Text(
          exerciseName,
          style: AppTheme.secondaryText(
              size: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.acccentColor),
        ),
        children: setWidgets,
      );
    }).toList();
  }
}
