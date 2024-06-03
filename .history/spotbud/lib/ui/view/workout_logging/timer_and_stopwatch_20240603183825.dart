import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/workout_logging/timer_widget.dart';

class StopwatchTimerScreen extends StatelessWidget {
  final RxBool isStopwatch = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stopwatch & Timer'),
        actions: [],
      ),
      body: Obx(() => isStopwatch.value ? StopwatchWidget() : TimerWidget()),
    );
  }
}

class StopwatchWidget extends StatefulWidget {
  @override
  _StopwatchWidgetState createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  final stopwatch = Stopwatch();
  late final Timer timer;
  final RxBool isStopwatch = true.obs;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (stopwatch.isRunning) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => Switch(
                value: isStopwatch.value,
                onChanged: (value) {
                  isStopwatch.value = value;
                },
              )),
          Text(
            "STOPWATCH",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            stopwatch.elapsed.inMinutes
                    .remainder(60)
                    .toString()
                    .padLeft(2, '0') +
                ':' +
                (stopwatch.elapsed.inSeconds.remainder(60))
                    .toString()
                    .padLeft(2, '0') +
                '.' +
                (stopwatch.elapsed.inMilliseconds.remainder(1000) ~/ 10)
                    .toString()
                    .padLeft(2, '0'),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    stopwatch.isRunning ? stopwatch.stop() : stopwatch.start();
                  });
                },
                child: Text(stopwatch.isRunning ? 'Stop' : 'Start'),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    stopwatch.reset();
                  });
                },
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
