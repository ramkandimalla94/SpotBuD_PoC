import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        Query collection = _firestore
            .collection('data')
            .doc(userId)
            .collection('workouts')
            .orderBy('timestamp', descending: true);

        if (_selectedBodyPart != null) {
          collection =
              collection.where('bodyPart', isEqualTo: _selectedBodyPart);
        }

        if (_selectedMachine != null) {
          collection = collection.where('machine', isEqualTo: _selectedMachine);
        }

        _workoutLogsStream = collection.snapshots();

        // Fetch logged body parts and machines
        final QuerySnapshot<Object?> snapshot = await collection.get();

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
      final String? bodyPart = log['bodyPart'];
      if (bodyPart != null) {
        bodyParts.add(bodyPart);
      }
    });
    return bodyParts.toList();
  }

  List<String> _extractLoggedMachines(List<QueryDocumentSnapshot> logs) {
    final Set<String> machines = Set<String>();
    logs.forEach((log) {
      final String? machine = log['machine'];
      if (machine != null) {
        machines.add(machine);
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
      body: Row(
        children: [
          Column(
            children: [
              DropdownButton<String>(
                value: _selectedBodyPart,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBodyPart = newValue;
                    _fetchWorkoutLogs();
                  });
                },
                items: _loggedBodyParts
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('Select Body Part'),
              ),
              DropdownButton<String>(
                value: _selectedMachine,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMachine = newValue;
                    _fetchWorkoutLogs();
                  });
                },
                items: _loggedMachines
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('Select Machine'),
              ),
              ElevatedButton(
                onPressed: _resetFilters,
                child: Text('Reset Filters'),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _workoutLogsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final logs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      final String? bodyPart = log['bodyPart'];
                      final String? machine = log['machine'];
                      final List<dynamic>? sets = log['sets'];
                      if (bodyPart == null || machine == null || sets == null) {
                        return SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: sets.map<Widget>((set) {
                          final String? reps = set['reps'];
                          final String? weight = set['weight'];
                          final String? notes = set['notes'];
                          return ListTile(
                            title: Text(machine),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Body Part: $bodyPart'),
                                Text(
                                    'Reps: ${reps ?? 'N/A'}, Weight: ${_convertWeight(weight)}'),
                                if (notes != null) Text('Notes: $notes'),
                              ],
                            ),
                          );
                        }).toList(),
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

  String _convertWeight(String? weight) {
    if (_isKgsPreferred) {
      return '$weight kg';
    } else {
      final double? kg = double.tryParse(weight ?? '');
      if (kg != null) {
        final double lbs = kg * 2.20462;
        return '${lbs.toStringAsFixed(2)} lbs';
      } else {
        return 'N/A';
      }
    }
  }
}
