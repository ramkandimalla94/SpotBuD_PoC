import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:get/get.dart';
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
  late TabController _tabController;
  bool _isKgsPreferred = true; // Default preference is kilograms

  @override
  void initState() {
    super.initState();
    _fetchWorkoutLogs();
    _checkWeightPreference();
    _tabController = TabController(length: 1, vsync: ,);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        DateFormat('yyyy-MM-dd').format(date),
                        style: AppTheme.secondaryText(
                          size: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColors.acccentColor,
                        ),
                      ),
                    ),
                    for (var workout in workoutsForDate)
                      ..._buildWorkoutDetails(workout['exercises']),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showWorkoutDetailsDialog(DateTime date, List<DocumentSnapshot> logs) {
    List<DocumentSnapshot> workoutsOnDate = logs.where((log) {
      final timestamp = log['timestamp'] as Timestamp;
      final logDate =
          DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
      return DateTime(logDate.year, logDate.month, logDate.day) ==
          DateTime(date.year, date.month, date.day);
    }).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            DateFormat('yyyy-MM-dd').format(date),
            style: AppTheme.secondaryText(
              size: 22,
              fontWeight: FontWeight.w500,
              color: AppColors.acccentColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var log in workoutsOnDate)
                ..._buildWorkoutDetails(log['exercises']),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBodyPartFilter() {
    return DropdownButton<String>(
      dropdownColor: AppColors.primaryColor,
      value: _selectedBodyPart,
      onChanged: (newValue) {
        setState(() {
          _selectedBodyPart = newValue;
          // Reset selected machine when body part changes
          _selectedMachine = null;
        });
      },
      items: _loggedBodyParts.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: AppColors.backgroundColor),
          ),
        );
      }).toList(),
      hint: Text(
        'Select Body Part',
        style: AppTheme.primaryText(
          color: AppColors.acccentColor,
          size: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMachineFilter(List<String> loggedMachines) {
    List<String> machinesToShow = _selectedBodyPart == null
        ? loggedMachines
        : loggedMachines.where((machine) {
            return _loggedBodyParts.contains(_selectedBodyPart) &&
                loggedMachines.contains(machine);
          }).toList();

    return DropdownButton<String>(
      dropdownColor: AppColors.primaryColor,
      value: _selectedMachine,
      onChanged: (newValue) {
        setState(() {
          _selectedMachine = newValue;
        });
      },
      items: machinesToShow.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: AppColors.backgroundColor),
          ),
        );
      }).toList(),
      hint: Text(
        'Select Machine',
        style: AppTheme.primaryText(
          color: AppColors.acccentColor,
          size: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
    }).where((log) {
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
    }).where((log) {
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
    }).toList();
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
            'Reps: ${reps ?? 'N/A'}, Weight: ${_convertWeight(weight)}',
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
}
