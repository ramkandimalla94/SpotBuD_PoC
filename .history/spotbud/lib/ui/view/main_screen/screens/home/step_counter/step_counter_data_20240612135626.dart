import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';

class StepsTracker extends StatefulWidget {
  @override
  _StepsTrackerState createState() => _StepsTrackerState();
}

class _StepsTrackerState extends State<StepsTracker> {
  late Stream<StepCount> _stepCountStream;
  final User? user = FirebaseAuth.instance.currentUser;
  int? _todaySteps;
  late Stream<QuerySnapshot> _stepsRecordStream;

  @override
  void initState() {
    super.initState();
    _initPedometer();
    _initFirestore();
  }

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_updateSteps).onError(_handleError);
  }

  void _updateSteps(StepCount event) {
    setState(() {
      _todaySteps = event.steps;
    });
  }

  void _handleError(dynamic error) {
    print('Error: $error');
  }

  void _initFirestore() {
    _stepsRecordStream = FirebaseFirestore.instance
        .collection('data')
        .doc(user!.uid)
        .collection('stepsRecords')
        .orderBy('date', descending: true)
        .snapshots();
  }

//   try {
  //   await FirebaseFirestore.instance
  //       .collection('data')
  //       .doc(user!.uid)
  //       .collection('routines')
  //       .doc(routineId)
  //       .delete();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Routine deleted successfully'),
  //     ),
  //   );
  // } catch (e) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Failed to delete routine: $e'),
  //     ),
  //   );
  // }
  void _saveStepsToFirestore() async {
    if (_todaySteps != null) {
      await FirebaseFirestore.instance
          .collection('data')
          .doc(user!.uid)
          .collection('stepsRecords')
          .add({
        'date': DateTime.now(),
        'steps': _todaySteps,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Steps Tracker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Today\'s Steps',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _todaySteps != null
                        ? Text(
                            _todaySteps.toString(),
                            style: TextStyle(fontSize: 48),
                          )
                        : const LoadingIndicator(),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _stepsRecordStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingIndicator();
                }

                List<FlSpot> spots = [];
                snapshot.data!.docs.forEach((doc) {
                  DateTime date = doc['date'].toDate();
                  int steps = doc['steps'];
                  spots.add(FlSpot(date.millisecondsSinceEpoch.toDouble(),
                      steps.toDouble()));
                });

                return LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        barWidth: 2,
                        color: Colors.blue,
                        dotData: FlDotData(
                          show: false,
                        ),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            DateTime date = DateTime.fromMillisecondsSinceEpoch(
                                value.toInt());
                            return Text(
                              '${date.day}/${date.month}',
                              style: TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 2000,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveStepsToFirestore,
        child: Icon(Icons.save),
      ),
    );
  }
}
