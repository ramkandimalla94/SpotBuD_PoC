import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final StepCountController _stepCountController =
      Get.put(StepCountController());

  int _initialStepCount = 0;
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

    if (savedInitialStepCount == null) {
      // First time app is opened, set initial step count to 0
      _initialStepCount = 0;
      prefs.setInt('initialStepCount', _initialStepCount);
    } else {
      _initialStepCount = savedInitialStepCount;
    }

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream!.listen(_onStepCount);
  }

  void _onStepCount(StepCount event) {
    int currentStepCount = event.steps;
    _dailySteps = currentStepCount - _initialStepCount;

    setState(() {
      _stepCountController.updateDailySteps(_dailySteps);
    });

    _storeDailySteps();
  }

  Future<void> _fetchDailyStepRecords() async {
    User? user = _auth.currentUser;
    String userId = user!.uid;
    await Firebase.initializeApp();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('data')
        .doc(userId)
        .collection('dailyStepRecords')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('records')
        .get();
    querySnapshot.docs.forEach((doc) {
      setState(() {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        _dailyStepRecords[doc.id] = data?['steps'] as int? ?? 0;
      });
    });
  }

  Future<void> _storeDailySteps() async {
    User? user = _auth.currentUser;
    String userId = user!.uid;

    String currentDate = _getCurrentDate();
    await FirebaseFirestore.instance
        .collection('data')
        .doc(userId)
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
    });

    prefs.setInt('initialStepCount', _initialStepCount);
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
        subtitle: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Steps: ${_stepCountController.dailySteps.value}'),
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

class StepCountController extends GetxController {
  RxInt dailySteps = 0.obs;

  void updateDailySteps(int steps) {
    dailySteps.value = steps;
  }
}
