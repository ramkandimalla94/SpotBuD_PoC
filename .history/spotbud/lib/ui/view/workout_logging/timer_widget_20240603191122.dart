import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration = Duration(minutes: 0);
  Timer? countdownTimer;
  double progressValue = 1.0;
  void startTimer() {
    if (countdownTimer != null && countdownTimer!.isActive) {
      countdownTimer!.cancel();
    } else {
      countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (duration > Duration(seconds: 0)) {
            duration -= Duration(seconds: 1);
            progressValue = duration.inSeconds / duration.inSeconds;
          } else {
            timer.cancel();
            progressValue = 0.0;
            _vibrateIfPossible();
          }
        });
      });
    }
  }

  Future<void> _vibrateIfPossible() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 1000);
    }
  }

  void resetTimer() {
    setState(() {
      duration = Duration(minutes: 0);
      progressValue = 1.0;
      countdownTimer?.cancel();
    });
  }

  void updateDuration(Duration newDuration) {
    setState(() {
      duration = newDuration;
      progressValue = 1.0;
    });
  }

  Future<void> setTimer(BuildContext context) async {
    final pickedDuration = await showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        Duration selectedDuration = Duration(minutes: 0);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Set Timer'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${selectedDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(selectedDuration.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration += Duration(minutes: 5);
                          });
                        },
                        child: Text('+5 min'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration -= Duration(minutes: 5);
                          });
                        },
                        child: Text('-5 min'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration += Duration(minutes: 1);
                          });
                        },
                        child: Text('+1 min'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration -= Duration(minutes: 1);
                          });
                        },
                        child: Text('-1 min'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration += Duration(seconds: 30);
                          });
                        },
                        child: Text('+30 sec'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration -= Duration(seconds: 30);
                          });
                        },
                        child: Text('-30 sec'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration += Duration(seconds: 10);
                          });
                        },
                        child: Text('+10 sec'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration -= Duration(seconds: 10);
                          });
                        },
                        child: Text('-10 sec'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration += Duration(seconds: 1);
                          });
                        },
                        child: Text('+1 sec'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration -= Duration(seconds: 1);
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
      },
    );
    if (pickedDuration != null) {
      setState(() {
        duration = pickedDuration;
        progressValue = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
    );
  }
}
