import 'package:flutter/material.dart';
import 'dart:async';

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

  void updateDuration(Duration newDuration) {
    setState(() {
      duration = newDuration;
    });
  }

  Future<void> setTimer(BuildContext context) async {
    final pickedDuration = await showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        Duration selectedDuration = Duration(minutes: 0);
        return AlertDialog(
          title: Text('Set Timer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDuration += Duration(minutes: 1);
                        updateDuration(selectedDuration);
                      });
                    },
                    child: Text('+1 min'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDuration -= Duration(minutes: 1);
                        updateDuration(selectedDuration);
                      });
                    },
                    child: Text('-1 min'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDuration += Duration(seconds: 10);
                        updateDuration(selectedDuration);
                      });
                    },
                    child: Text('+10 sec'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDuration -= Duration(seconds: 10);
                        updateDuration(selectedDuration);
                      });
                    },
                    child: Text('-10 sec'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDuration += Duration(seconds: 30);
                        updateDuration(selectedDuration);
                      });
                    },
                    child: Text('+30 sec'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDuration -= Duration(seconds: 30);
                        updateDuration(selectedDuration);
                      });
                    },
                    child: Text('-30 sec'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDuration += Duration(minutes: 5);
                        updateDuration(selectedDuration);
                      });
                    },
                    child: Text('+5 min'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDuration -= Duration(minutes: 5);
                        updateDuration(selectedDuration);
                      });
                    },
                    child: Text('-5 min'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDuration += Duration(seconds: 1);
                        updateDuration(selectedDuration);
                      });
                    },
                    child: Text('+1 sec'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDuration -= Duration(seconds: 1);
                        updateDuration(selectedDuration);
                      });
                    },
                    child: Text('-1 sec'),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedDuration);
              },
              child: Text('Set'),
            ),
          ],
        );
      },
    );
    if (pickedDuration != null) {
      setState(() {
        duration = pickedDuration;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
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
                    child: Text(
                        countdownTimer != null && countdownTimer!.isActive
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
        ),
      );
}
