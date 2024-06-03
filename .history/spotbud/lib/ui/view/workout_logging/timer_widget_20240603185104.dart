import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
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
    final pickedDuration = await showDurationPicker(
      context: context,
      initialTime: duration,
    );
    if (pickedDuration != null) {
      setState(() {
        duration = pickedDuration;
      });
    }
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: startTimer,
                child: Text(countdownTimer != null && countdownTimer!.isActive
                    ? 'Stop'
                    : 'Start'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: resetTimer,
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
