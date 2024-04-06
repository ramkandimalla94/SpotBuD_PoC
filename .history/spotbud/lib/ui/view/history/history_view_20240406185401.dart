import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/ui/widgets/text.dart';

class HistoryView extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.acccentColor),
        title: Text(
          'Workout History',
          style: AppTheme.secondaryText(
              size: 22,
              fontWeight: FontWeight.w500,
              color: AppColors.acccentColor),
        ),
      ),
      body: FutureBuilder(
        future: _fetchWorkoutLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return _buildWorkoutHistoryWidget();
          }
        },
      ),
    );
  }

  Future<void> _fetchWorkoutLogs() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        _workoutLogsStream = _firestore
            .collection('data')
            .doc(userId)
            .collection('workouts')
            .orderBy('timestamp', descending: true)
            .snapshots();
        return;
      }
      throw 'User not authenticated';
    } catch (e) {
      print('Error fetching workout logs: $e');
      throw e;
    }
  }

  Widget _buildWorkoutHistoryWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: _workoutLogsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingIndicator(),
          );
        } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No workout logs available.'),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final workoutLogs = snapshot.data!.docs;
          final dates = _extractDates(workoutLogs);
          return ListView.builder(
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final workouts = _filterWorkoutsByDate(workoutLogs, date);
              return ExpansionTile(
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.acccentColor,
                ),
                title: DropdownMenuItem<DateTime>(
                  value: date,
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(date),
                    style: AppTheme.secondaryText(
                      size: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColors.acccentColor,
                    ),
                  ),
                ),
                children: workouts.map<Widget>((workout) {
                  return ExpansionTile(
                    trailing: Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.backgroundColor,
                    ),
                    title: Text(
                      'Start time: ${workout['startTime'] as String? ?? 'N/A'}',
                      style: AppTheme.secondaryText(
                        size: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.backgroundColor,
                      ),
                    ),
                    children: _buildWorkoutDetails(workout['exercises']),
                  );
                }).toList(),
              );
            },
          );
        }
      },
    );
  }

  List<DateTime> _extractDates(List<DocumentSnapshot> logs) {
    final dates = <DateTime>{};
    logs.forEach((log) {
      final timestamp = log['timestamp'] as Timestamp;
      final date =
          DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
      dates.add(DateTime(date.year, date.month, date.day));
    });
    return dates.toList()..sort((a, b) => b.compareTo(a));
  }

  List<Map<String, dynamic>> _filterWorkoutsByDate(
    List<DocumentSnapshot> logs,
    DateTime date,
  ) {
    return logs
        .where((log) {
          final timestamp = log['timestamp'] as Timestamp;
          final logDate =
              DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
          return DateTime(logDate.year, logDate.month, logDate.day) ==
              DateTime(date.year, date.month, date.day);
        })
        .map((log) => log.data() as Map<String, dynamic>)
        .toList();
  }

  List<Widget> _buildWorkoutDetails(List<dynamic>? exercises) {
    if (exercises == null || exercises.isEmpty) {
      return [
        Text(
          'No exercises recorded.',
          style: AppTheme.secondaryText(
            size: 22,
            fontWeight: FontWeight.w500,
            color: AppColors.acccentColor,
          ),
        )
      ];
    }

    return exercises.map<Widget>((exercise) {
      final bodyPart = exercise['bodyPart'] as String?;
      final exerciseName = exercise['machine'] as String?;
      final sets = exercise['sets'] as List<dynamic>?;
      if (bodyPart == null || exerciseName == null || sets == null) {
        return SizedBox.shrink();
      }

      final setWidgets = sets.map<Widget>((set) {
        final reps = set['reps'] as String?;
        final weight = set['weight'] as String?;
        final notes = set['notes'] as String?;

        return ListTile(
          title: Text(
            'Reps: ${reps ?? 'N/A'}, Weight: ${weight ?? 'N/A'}',
            style: AppTheme.secondaryText(
              size: 17,
              fontWeight: FontWeight.w500,
              color: AppColors.backgroundColor,
            ),
          ),
          subtitle: Text(
            'Notes: ${notes ?? 'N/A'}',
            style: AppTheme.secondaryText(
              size: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.backgroundColor,
            ),
          ),
        );
      }).toList();

      return ExpansionTile(
        trailing: Icon(
          Icons.arrow_drop_down,
          color: AppColors.acccentColor,
        ),
        title: Text(
          exerciseName,
          style: AppTheme.secondaryText(
            size: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.acccentColor,
          ),
        ),
        children: setWidgets,
      );
    }).toList();
  }
}
