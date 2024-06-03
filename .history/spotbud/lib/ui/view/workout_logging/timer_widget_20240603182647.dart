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
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  void startTimer() {
    if (countdownTimer != null && countdownTimer!.isActive) {
      countdownTimer!.cancel();
    } else {
      countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (duration > Duration(seconds: 0)) {
            duration -= Duration(seconds: 1);
          } else {
            timer.cancel();
          }
        });
      });
    }
  }

  void resetTimer() {
    setState(() {
      duration = Duration(minutes: 0);
      countdownTimer?.cancel();
    });
  }

  void setTimer() {
    int minutes = int.tryParse(_minutesController.text) ?? 0;
    int seconds = int.tryParse(_secondsController.text) ?? 0;
    setState(() {
      duration = Duration(minutes: minutes, seconds: seconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                child: TextField(
                  controller: _minutesController,
                  decoration: InputDecoration(labelText: 'Minutes'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: _secondsController,
                  decoration: InputDecoration(labelText: 'Seconds'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: setTimer,
            child: Text('Set Timer'),
          ),
          ElevatedButton(
            onPressed: startTimer,
            child: Text(countdownTimer != null && countdownTimer!.isActive
                ? 'Stop'
                : 'Start'),
          ),
          ElevatedButton(
            onPressed: resetTimer,
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}
