import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  ConfettiController? _confettiController;
  Duration duration = Duration.zero;
  Timer? countdownTimer;
  double progressValue = 1.0;
  Duration totalDuration = const Duration(minutes: 0);
  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  void dispose() {
    _confettiController!.dispose();
    super.dispose();
  }

  void startTimer() {
    if (countdownTimer != null && countdownTimer!.isActive) {
      countdownTimer!.cancel();
    } else {
      if (totalDuration == Duration.zero) {
        // Handle case where totalDuration is not set
        print('Total duration not set.');
        return;
      }

      countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (duration > const Duration(seconds: 0)) {
            duration -= const Duration(seconds: 1);
            if (duration.inSeconds > 0) {
              progressValue = duration.inSeconds / totalDuration.inSeconds;
            } else {
              progressValue = 0.0;
              timer.cancel();
              _vibrateIfPossible();
            }
          } else {
            timer.cancel();
          }
        });
      });
    }
  }

  Future<void> setTimer(BuildContext context) async {
    final pickedDuration = await showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        Duration selectedDuration = const Duration(minutes: 0);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Set Timer'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${selectedDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(selectedDuration.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration += const Duration(minutes: 5);
                          });
                        },
                        child: const Text('+5 min'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration -= const Duration(minutes: 5);
                          });
                        },
                        child: const Text('-5 min'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration += const Duration(minutes: 1);
                          });
                        },
                        child: const Text('+1 min'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration -= const Duration(minutes: 1);
                          });
                        },
                        child: const Text('-1 min'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration += const Duration(seconds: 30);
                          });
                        },
                        child: const Text('+30 sec'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration -= const Duration(seconds: 30);
                          });
                        },
                        child: const Text('-30 sec'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration += const Duration(seconds: 10);
                          });
                        },
                        child: const Text('+10 sec'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration -= const Duration(seconds: 10);
                          });
                        },
                        child: const Text('-10 sec'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration += const Duration(seconds: 1);
                          });
                        },
                        child: const Text('+1 sec'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDuration -= const Duration(seconds: 1);
                          });
                        },
                        child: const Text('-1 sec'),
                      ),
                    ],
                  ),
                  // Additional buttons for setting timer
                  // Add buttons for other increments/decrements as needed
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    totalDuration = selectedDuration;
                    Navigator.of(context).pop(selectedDuration);
                  },
                  child: const Text('Set'),
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

  void _vibrateIfPossible() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 2000);
    }
  }

  void resetTimer() {
    setState(() {
      duration = const Duration(minutes: 0);
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

  // Future<void> setTimer(BuildContext context) async {
  //   final pickedDuration = await showDialog<Duration>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       Duration selectedDuration = Duration(minutes: 0);
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: Text('Set Timer'),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text(
  //                   '${selectedDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(selectedDuration.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
  //                   style: TextStyle(fontSize: 24),
  //                 ),
  //                 SizedBox(height: 10),

  //               ],
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('Cancel'),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(selectedDuration);
  //                 },
  //                 child: Text('Set'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  //   if (pickedDuration != null) {
  //     setState(() {
  //       duration = pickedDuration;
  //       progressValue = 1.0;
  //     });
  //   }
  // }

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
                style:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: startTimer,
                  child: Text(countdownTimer != null && countdownTimer!.isActive
                      ? 'Stop'
                      : 'Start'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
