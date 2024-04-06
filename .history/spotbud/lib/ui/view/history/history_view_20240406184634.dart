import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class HistoryView extends StatelessWidget {
  final userDataController = Get.find<UserDataViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userDataController.workoutLogsStream,
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
            return ListView.builder(
              itemCount: workoutLogs.length,
              itemBuilder: (context, index) {
                final workoutLog =
                    workoutLogs[index].data() as Map<String, dynamic>;
                final timestamp = workoutLog['timestamp'] as Timestamp;
                final formattedDate = DateTime.fromMillisecondsSinceEpoch(
                  timestamp.seconds * 1000,
                ).toString();

                final date = workoutLog['date'] ?? 'N/A';
                final startTime = workoutLog['startTime'] ?? 'N/A';
                final endTime = workoutLog['endTime'] ?? 'N/A';
                final exercises = workoutLog['exercises'] as List<dynamic>;

                List<Widget> exerciseWidgets = [];
                for (var exercise in exercises) {
                  final bodyPart = exercise['bodyPart'] ?? 'N/A';
                  final exerciseName = exercise['machine'] ?? 'N/A';
                  final sets = exercise['sets'] as List<dynamic>;
                  List<Widget> setWidgets = [];
                  for (var set in sets) {
                    final reps = set['reps'] ?? 'N/A';
                    final weight = set['weight'] ?? 'N/A';
                    final notes = set['notes'] ?? 'N/A';
                    setWidgets.add(
                      ListTile(
                        title: Text('Reps: $reps, Weight: $weight'),
                        subtitle: Text('Notes: $notes'),
                      ),
                    );
                  }
                  exerciseWidgets.add(
                    ExpansionTile(
                      title: Text(exerciseName),
                      children: setWidgets,
                    ),
                  );
                }

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: $date'),
                        Text('Start Time: $startTime'),
                        Text('End Time: $endTime'),
                        Divider(),
                        ...exerciseWidgets,
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
