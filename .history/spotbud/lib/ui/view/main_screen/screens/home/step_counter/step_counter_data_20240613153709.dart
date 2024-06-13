import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyStepRecords extends StatefulWidget {
  @override
  _DailyStepRecordsState createState() => _DailyStepRecordsState();
}

class _DailyStepRecordsState extends State<DailyStepRecords> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<StepCount>? _stepCountStream;
  int _dailySteps = 0;
  Map<String, int> _dailyStepRecords = {};
  int _initialStepCount = 0;
  int _lastStoredStepCount = 0;
  String _currentDate = '';

  @override
  void initState() {
    super.initState();
    _initPedometer();
    _fetchDailyStepRecords();
  }

  Future<void> _initPedometer() async {
    await Firebase.initializeApp();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedInitialStepCount = prefs.getInt('initialStepCount');
    int? savedLastStoredStepCount = prefs.getInt('lastStoredStepCount');

    if (savedInitialStepCount == null) {
      _initialStepCount = 0;
      _lastStoredStepCount = 0;
      await prefs.setInt('initialStepCount', _initialStepCount);
      await prefs.setInt('lastStoredStepCount', _lastStoredStepCount);
    } else {
      _initialStepCount = savedInitialStepCount;
      _lastStoredStepCount = savedLastStoredStepCount ?? 0;
    }

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream!.listen(_onStepCount);
  }

  void _onStepCount(StepCount event) {
    int currentStepCount = event.steps;
    int stepsToAdd = currentStepCount - _lastStoredStepCount;

    setState(() {
      _dailySteps += stepsToAdd;
      _lastStoredStepCount = currentStepCount;
    });

    _storeDailySteps();
  }

  Stream<QuerySnapshot>? _dailyStepRecordsStream;

  Future<void> _fetchDailyStepRecords() async {
    User? user = _auth.currentUser;
    if (user == null) return;
    String userId = user.uid;

    _dailyStepRecordsStream = FirebaseFirestore.instance
        .collection('data')
        .doc(userId)
        .collection('dailyStepRecords')
        .snapshots();

    _dailyStepRecordsStream!.listen((snapshot) {
      Map<String, int> records = {};
      snapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        records[doc.id] = data?['steps'] as int? ?? 0;
      });
      setState(() {
        _dailyStepRecords = records;
      });
    });
  }

  Future<void> _storeDailySteps() async {
    User? user = _auth.currentUser;
    if (user == null) return;
    String userId = user.uid;
    String currentDate = _getCurrentDate();

    DocumentReference docRef = FirebaseFirestore.instance
        .collection('data')
        .doc(userId)
        .collection('dailyStepRecords')
        .doc(currentDate);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);
      int existingSteps = 0;
      if (snapshot.exists && snapshot.data() != null) {
        existingSteps =
            (snapshot.data() as Map<String, dynamic>)['steps'] as int? ?? 0;
      }
      int updatedSteps = existingSteps + _dailySteps;
      transaction.set(docRef, {'steps': updatedSteps});
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastStoredStepCount', _lastStoredStepCount);
  }

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    if (formattedDate != _currentDate) {
      _resetDailySteps();
      _currentDate = formattedDate;
    }
    return formattedDate;
  }

  Future<void> _resetDailySteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentStepCount =
        await _stepCountStream!.first.then((value) => value.steps);

    setState(() {
      _initialStepCount = currentStepCount;
      _dailySteps = 0;
      _lastStoredStepCount = currentStepCount;
    });

    await prefs.setInt('initialStepCount', _initialStepCount);
    await prefs.setInt('lastStoredStepCount', _lastStoredStepCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Step Records'),
      ),
      body: _dailyStepRecords.isEmpty
          ? Center(
              child: Text('No data available.'),
            )
          : ListView(
              children: [
                _buildCurrentDayCard(),
                SizedBox(height: 20),
                _buildHistoryList(),
              ],
            ),
    );
  }

  Widget _buildCurrentDayCard() {
    return Card(
      child: ListTile(
        title: Text('Today (${_getCurrentDate()})'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<int>(
              future: _getTodayStoredSteps(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Stored Steps: Loading...');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  int todayStoredSteps = snapshot.data ?? 0;
                  return Text('Stored Steps: $todayStoredSteps');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<int> _getTodayStoredSteps() async {
    User? user = _auth.currentUser;
    if (user == null) return 0;
    String userId = user.uid;

    String currentDate = _getCurrentDate();
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('data')
        .doc(userId)
        .collection('dailyStepRecords')
        .doc(currentDate)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      return data?['steps'] as int? ?? 0;
    } else {
      return 0;
    }
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _dailyStepRecords.length,
      itemBuilder: (context, index) {
        String date = _dailyStepRecords.keys.elementAt(index);
        int steps = _dailyStepRecords[date] ?? 0;

        return ListTile(
          title: Text('Date: $date'),
          subtitle: Text('Steps: $steps'),
        );
      },
    );
  }
}
