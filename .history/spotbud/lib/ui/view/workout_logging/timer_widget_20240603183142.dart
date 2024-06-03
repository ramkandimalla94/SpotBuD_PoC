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

  Future<void> setTimer(BuildContext context) async {
    final TextEditingController _minutesController = TextEditingController();
    final TextEditingController _secondsController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Timer'),
        content: Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _minutesController,
                decoration: InputDecoration(labelText: 'Minutes'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _secondsController,
                decoration: InputDecoration(labelText: 'Seconds'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              int minutes = int.tryParse(_minutesController.text) ?? 0;
              int seconds = int.tryParse(_secondsController.text) ?? 0;
              setState(() {
                duration = Duration(minutes: minutes, seconds: seconds);
              });
              Navigator.of(context).pop();
            },
            child: Text('Set'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => setTimer(context),
            child: Text(
              '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
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
