import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration = Duration(minutes: 0);
  Timer? countdownTimer;

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
    );
    if (picked != null) {
      setState(() {
        duration = Duration(hours: picked.hour, minutes: picked.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "STOPWATCH",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            duration.inMinutes.remainder(60).toString().padLeft(2, '0') +
                ':' +
                (duration.inSeconds.remainder(60)).toString().padLeft(2, '0'),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => selectTime(context),
            child: Text('Set Timer'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (countdownTimer != null && countdownTimer!.isActive) {
                  countdownTimer!.cancel();
                } else {
                  countdownTimer =
                      Timer.periodic(Duration(seconds: 1), (timer) {
                    setState(() {
                      if (duration > Duration(seconds: 0)) {
                        duration -= Duration(seconds: 1);
                      } else {
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
