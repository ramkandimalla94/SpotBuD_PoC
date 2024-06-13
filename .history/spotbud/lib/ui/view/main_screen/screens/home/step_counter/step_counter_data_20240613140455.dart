import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DailyStepRecords extends StatefulWidget {
  @override
  _DailyStepRecordsState createState() => _DailyStepRecordsState();
}

class _DailyStepRecordsState extends State<DailyStepRecords> {
  Stream<StepCount>? _stepCountStream;
  int _dailySteps = 0;
  Map<String, int> _dailyStepRecords = {};

  @override
  void initState() {
    super.initState();
    _initPedometer();
    _fetchDailyStepRecords();
  }

  Future<void> _initPedometer() async {
    await Firebase.initializeApp();
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream!.listen(_onStepCount);
  }

  void _onStepCount(StepCount event) {
    setState(() {
      _dailySteps = event.steps;
    });
    _storeDailySteps();
  }

  Future<void> _fetchDailyStepRecords() async {
    await Firebase.initializeApp();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('dailyStepRecords')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('records')
        .get();
    querySnapshot.docs.forEach((doc) {
      setState(() {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        _dailyStepRecords[doc.id] =
            data?.containsKey('steps') == true ? data!['steps'] as int : 0;
      });
    });
  }

  Future<void> _storeDailySteps() async {
    String currentDate = _getCurrentDate();
    await FirebaseFirestore.instance
        .collection('dailyStepRecords')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('records')
        .doc(currentDate)
        .set({'steps': _dailySteps});
    _fetchDailyStepRecords();
  }

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    if (now.hour == 0 && now.minute == 0) {
      _resetDailySteps();
    }
    return formattedDate;
  }

  void _resetDailySteps() {
    setState(() {
      _dailySteps = 0;
    });
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
        subtitle: Text('Steps: $_dailySteps'),
      ),
    );
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
