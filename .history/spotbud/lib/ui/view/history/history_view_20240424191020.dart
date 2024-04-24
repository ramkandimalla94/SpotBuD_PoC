import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/ui/widgets/button.dart';
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
  late DateTime _selectedMonth = DateTime.now();
  List<String> _loggedMachines = [];
  late FixedExtentScrollController _scrollController;

  bool _isKgsPreferred = true; // Default preference is kilograms

  @override
  void initState() {
    super.initState();
    // Fetch workout logs for the current month initially
    _scrollController = FixedExtentScrollController();
    _fetchWorkoutLogs(_selectedMonth);
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

  Future<void> _fetchWorkoutLogs(DateTime selectedMonth) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DateTime startDate = DateTime(selectedMonth.year, selectedMonth.month);
        DateTime endDate = DateTime(selectedMonth.year, selectedMonth.month + 1)
            .subtract(Duration(days: 1));

        _workoutLogsStream = _firestore
            .collection('data')
            .doc(userId)
            .collection('workouts')
            .where('timestamp',
                isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
            .orderBy('timestamp', descending: true)
            .snapshots();

        // Fetch logged body parts and machines
        final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('data')
            .doc(userId)
            .collection('workouts')
            .where('timestamp',
                isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Add filter dropdowns here
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Text(
                      'Filters',
                      style: TextStyle(
                          color: AppColors.acccentColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.filter_list,
                      color: AppColors.acccentColor,
                    ),
                  ],
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  children: [
                    _buildBodyPartFilter(),
                    _buildMachineFilter(_loggedMachines),
                  ],
                ),
                SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    _resetFilters();
                  },
                  child: Text(
                    'Reset',
                    style: TextStyle(color: AppColors.backgroundColor),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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
                  List<DateTime> filteredDates =
                      _filteredDates(dates, workoutLogs);
                  return Column(
                    children: [
                      _buildMonthYearSelector(context, _selectedMonth),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredDates.length,
                          itemBuilder: (context, index) {
                            final date = filteredDates[index];
                            final dateFormatted =
                                DateFormat('yyyy-MM-dd').format(date);
                            final workoutsForDate =
                                _filterWorkoutsByDate(workoutLogs, date);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            DateFormat('EEE').format(date),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('dd').format(date),
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('MMM/yy').format(date),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: double
                                              .infinity, // Take all available width
                                          decoration: BoxDecoration(
                                            color: AppColors.secondaryColor,
                                            borderRadius: BorderRadius.circular(
                                                20), // Rounded border
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (var workout
                                                  in workoutsForDate)
                                                ..._buildWorkoutDetails(
                                                    workout['exercises']),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildMonthYearSelector(BuildContext context, DateTime selectedMonth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('MMMM yyyy').format(selectedMonth),
            style: TextStyle(
                fontSize: 20,
                color: AppColors.acccentColor,
                fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: AppColors.backgroundColor,
            ),
            onPressed: () {
              _showMonthYearPicker(context);
            },
          ),
        ],
      ),
    );
  }

  void _showMonthYearPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryColor,
      elevation: 2,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MonthPicker(
                    selectedMonth: _selectedMonth,
                    onChanged: (DateTime newDateTime) {
                      setState(() {
                        _selectedMonth = newDateTime;
                      });
                    },
                  ),
                  YearPicker(
                    selectedMonth: _selectedMonth,
                    onChanged: (DateTime newDateTime) {
                      setState(() {
                        _selectedMonth = newDateTime;
                      });
                    },
                  ),
                  buildLoginButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleMonthTap(_selectedMonth);
                      setState(() {}); // Trigger a rebuild
                    },
                    text: 'Done',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleMonthTap(DateTime selectedMonth) async {
    setState(() {
      _selectedMonth = selectedMonth;
    });

    // Fetch and update data for the selected month
    await _fetchWorkoutLogs(_selectedMonth);

    // Print a message to verify the selected month
    print('Selected Month: ${DateFormat('MMMM yyyy').format(selectedMonth)}');
  }

  List<Widget> _buildWorkoutDetails(List<dynamic>? exercises) {
    if (exercises == null || exercises.isEmpty) {
      return [
        Center(
          child: Text(
            'No exercises recorded.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        )
      ];
    }

    List<Widget> workoutDetails = [];

    // Loop through each exercise
    for (var exercise in exercises) {
      final bodyPart = exercise['bodyPart'] as String?;
      final exerciseName = exercise['machine'] as String?;
      final sets = exercise['sets'] as List<dynamic>?;

      // Check if exercise details are valid
      if (bodyPart == null || exerciseName == null || sets == null) {
        continue;
      }

      // Add machine name at the top
      workoutDetails.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '$exerciseName:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );

      // Loop through each set of the exercise
      for (var set in sets) {
        final reps = set['reps'] as String?;
        final weight = set['weight'] as String?;
        final notes = set['notes'] as String?;

        // Build set details
        workoutDetails.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${reps ?? 'N/A'} x ${_convertWeight(weight)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                if (notes != null && notes.isNotEmpty)
                  Text(
                    'Notes: $notes',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        );
      }
    }

    return workoutDetails;
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

class MonthPicker extends StatelessWidget {
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onChanged;

  MonthPicker({
    required this.selectedMonth,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CupertinoPicker.builder(
        scrollController: FixedExtentScrollController(
          initialItem: selectedMonth.month - 1,
        ),
        itemExtent: 32,
        onSelectedItemChanged: (int index) {
          onChanged(DateTime(selectedMonth.year, index + 1, selectedMonth.day));
        },
        childCount: 12,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Text(
              DateFormat(
                'MMMM',
              ).format(DateTime(selectedMonth.year, index + 1)),
              style: TextStyle(color: AppColors.backgroundColor),
            ),
          );
        },
      ),
    );
  }
}

class YearPicker extends StatelessWidget {
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onChanged;

  YearPicker({
    required this.selectedMonth,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CupertinoPicker.builder(
        scrollController: FixedExtentScrollController(
          initialItem: selectedMonth.year - 2010,
        ),
        itemExtent: 32,
        onSelectedItemChanged: (int index) {
          onChanged(
              DateTime(index + 2010, selectedMonth.month, selectedMonth.day));
        },
        childCount: DateTime.now().year - 2010 + 1,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Text(
              (2010 + index).toString(),
              style: TextStyle(color: AppColors.backgroundColor),
            ),
          );
        },
      ),
    );
  }
}
