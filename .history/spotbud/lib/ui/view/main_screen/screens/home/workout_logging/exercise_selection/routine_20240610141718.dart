import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/main_screen/screens/home/workout_logging/exercise_selection/create_routine.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';

class WorkoutRoutineScreen extends StatefulWidget {
  @override
  _WorkoutRoutineScreenState createState() => _WorkoutRoutineScreenState();
}

class _WorkoutRoutineScreenState extends State<WorkoutRoutineScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Routines'),
      ),
      body: user == null
          ? Center(
              child: Text('You must be logged in to view workout routines.'),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('data')
                  .doc(user!.uid)
                  .collection('routines')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: LoadingIndicator(),
                  );
                }

                final routines = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: routines.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        tileColor: Theme.of(context).colorScheme.primary,
                        title: Text(
                          'Create New Routine',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.background),
                        ),
                        leading: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        onTap: () {
                          Get.to(() => CreateRoutineScreen());
                        },
                      );
                    }

                    final routine = routines[index - 1];
                    final routineId = routine.id;
                    final routineName = routine['name'] as String? ?? '';
                    final exercises =
                        routine['exercises'] as List<dynamic>? ?? [];

                    return Dismissible(
                      key: Key(routineId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteRoutine(routineId);
                      },
                      child: ListTile(
                        title: Text(routineName),
                        subtitle: Text('${exercises.length} exercises'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _editRoutine(routineId, routineName, exercises);
                              },
                            ),
                            // IconButton(
                            //   icon: Icon(Icons.preview),
                            //   onPressed: () {
                            //     _previewRoutine(
                            //         routineId, routineName, exercises);
                            //   },
                            // ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                // Load the routine exercises into the WorkoutLoggingForm
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          _previewRoutine(routineId, routineName, exercises);
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Future<void> _editRoutine(
      String routineId, String routineName, List<dynamic> exercises) async {
    final routineData = {
      'id': routineId,
      'name': routineName,
      'exercises': exercises,
    };

    Get.to(() => CreateRoutineScreen(routineData: routineData));
  }

  Future<void> _deleteRoutine(String routineId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Routine'),
        content: Text('Are you sure you want to delete this routine?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance
            .collection('data')
            .doc(user!.uid)
            .collection('routines')
            .doc(routineId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Routine deleted successfully'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete routine: $e'),
          ),
        );
      }
    }
  }

  void _previewRoutine(
      String routineId, String routineName, List<dynamic> exercises) {
    Get.to(() => CreateRoutineScreen(
          routineData: {
            'id': routineId,
            'name': routineName,
            'exercises': exercises,
            'isPreview': true,
          },
        ));
  }
}
