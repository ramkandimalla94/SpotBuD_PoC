import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StopwatchTimerScreen extends StatelessWidget {
  final RxBool isStopwatch = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stopwatch & Timer'),
        actions: [
          Obx(() => Switch(
                value: isStopwatch.value,
                onChanged: (value) {
                  isStopwatch.value = value;
                },
              )),
        ],
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
          ElevatedButton(
            onPressed: () {
              setState(() {
                stopwatch.isRunning ? stopwatch.stop() : stopwatch.start();
              });
            },
            child: Text(stopwatch.isRunning ? 'Stop' : 'Start'),
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
    );
  }
}

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration = Duration(minutes: 0);
  Timer? countdownTimer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            duration.inMinutes.remainder(60).toString().padLeft(2, '0') +
                ':' +
                (duration.inSeconds.remainder(60)).toString().padLeft(2, '0'),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (countdownTimer != null && countdownTimer!.isActive) {
                  countdownTimer!.cancel();
                } else {
                  countdownTimer =
                      Timer.periodic(Duration(seconds: 1), (timer) {
                    setState(() {
                      duration -= Duration(seconds: 1);
                      if (duration <= Duration(seconds: 0)) {
                        timer.cancel();
                      }
                    });
                  });
                }
              });
            },
            child: Text(countdownTimer != null && countdownTimer!.isActive
                ? 'Stop'
                : 'Start'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                duration = Duration(minutes: 0);
                countdownTimer?.cancel();
              });
            },
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}
