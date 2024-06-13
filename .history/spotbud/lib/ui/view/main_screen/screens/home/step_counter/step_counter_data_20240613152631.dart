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
      // First time app is opened, set initial step count and last stored step count to 0
      _initialStepCount = 0;
      _lastStoredStepCount = 0;
      prefs.setInt('initialStepCount', _initialStepCount);
      prefs.setInt('lastStoredStepCount', _lastStoredStepCount);
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
    String userId = user!.uid;

    _dailyStepRecordsStream = FirebaseFirestore.instance
        .collection('data')
        .doc(userId)
        .collection('dailyStepRecords')
        .doc(userId)
        .collection('records')
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
    String userId = user!.uid;

    String currentDate = _getCurrentDate();
    int stepsToAdd = _dailySteps - _lastStoredStepCount;

    if (stepsToAdd > 0) {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('data')
          .doc(userId)
          .collection('dailyStepRecords')
          .doc(userId)
          .collection('records')
          .doc(currentDate);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        int existingSteps;
        if (snapshot.exists) {
          existingSteps = snapshot.data() != null ? ['steps'] as int? ?? 0 : 0;
        } else {
          existingSteps = 0;
        }
        int updatedSteps = existingSteps + stepsToAdd;
        transaction.set(docRef, {'steps': updatedSteps});
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('lastStoredStepCount', _dailySteps);

      _fetchDailyStepRecords();
    }
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
        await Pedometer.stepCountStream.first.then((value) => value.steps);

    setState(() {
      _initialStepCount = currentStepCount;
      _dailySteps = 0;
      _lastStoredStepCount = currentStepCount;
    });

    prefs.setInt('initialStepCount', _initialStepCount);
    prefs.setInt('lastStoredStepCount', _lastStoredStepCount);
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
            Text('Current Steps: $_dailySteps'),
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
    String userId = user!.uid;

    String currentDate = _getCurrentDate();
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('data')
        .doc(userId)
        .collection('dailyStepRecords')
        .doc(userId)
        .collection('records')
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
