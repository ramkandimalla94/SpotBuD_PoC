import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/main_screen/screens/home/workout_logging/exercise_selection/body.dart';
import 'package:spotbud/ui/view/main_screen/screens/home/workout_logging/exercise_selection/machine_selection_view.dart';

class CreateRoutineScreen extends StatefulWidget {
  final Map<String, dynamic>? routineData;

  CreateRoutineScreen({this.routineData});

  @override
  _CreateRoutineScreenState createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  final TextEditingController _routineNameController = TextEditingController();
  final List<Map<String, dynamic>> _selectedExercises = [];
  bool isPreviewMode = false;

  @override
  void initState() {
    super.initState();
    _populateFromRoutineData();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.routineData != null && !isPreviewMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode
            ? 'Edit Routine'
            : (isPreviewMode ? 'Preview Routine' : 'Create Routine')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _routineNameController,
              decoration: InputDecoration(
                labelText: 'Routine Name',
              ),
              readOnly: isPreviewMode,
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedExercises.length,
                itemBuilder: (context, index) {
                  final exercise = _selectedExercises[index];
                  return ListTile(
                    title: Text(
                        '${exercise['bodyPart']} - ${exercise['machine']}'),
                    subtitle: Text(
                        'Sets: ${exercise['sets']} Reps: ${exercise['reps']}'),
                    trailing: isPreviewMode
                        ? null
                        : IconButton(
                            icon: Icon(Icons.remove_circle),
                            onPressed: () {
                              setState(() {
                                _selectedExercises.removeAt(index);
                              });
                            },
                          ),
                    onTap: () {
                      if (!isPreviewMode) {
                        _editExercise(index);
                      }
                    },
                  );
                },
              ),
            ),
            if (!isPreviewMode)
              ElevatedButton(
                onPressed: _addExercise,
                child: Text('Add Exercise'),
              ),
            SizedBox(height: 16.0),
            if (!isPreviewMode)
              ElevatedButton(
                onPressed: _saveRoutine,
                child: Text(isEditMode ? 'Update Routine' : 'Save Routine'),
              ),
          ],
        ),
      ),
    );
  }

  void _populateFromRoutineData() {
    if (widget.routineData != null) {
      final routineName = widget.routineData!['name'] ?? '';
      final exercisesData = widget.routineData!['exercises'] ?? [];
      isPreviewMode = widget.routineData!['isPreview'] ?? false;

      _routineNameController.text = routineName;
      _selectedExercises.clear();
      _selectedExercises
          .addAll(exercisesData.map<Map<String, dynamic>>((exercise) {
        return {
          'bodyPart': exercise['bodyPart'].toString(),
          'machine': exercise['machine'].toString(),
          'sets': exercise['sets'] ?? '0',
        };
      }).toList());
    }
  }

  Future<void> _addExercise() async {
    final selectedBodyPart = await Get.to(() => Bodypart());
    if (selectedBodyPart != null && selectedBodyPart is String) {
      final machineResult = await Get.to(
          () => MachineSelectionScreen(bodyPart: selectedBodyPart));
      if (machineResult != null && machineResult is Map<String, String>) {
        final bodyPart = machineResult['bodyPart'];
        final machine = machineResult['machine'];
        if (bodyPart != null && machine != null) {
          _showSetRepDialog(bodyPart, machine);
        }
      }
    }
  }

  void _showSetRepDialog(String bodyPart, String machine) async {
    final setsController = TextEditingController();
    final repsController = TextEditingController();

    final latestSetDetails = await fetchLatestSetDetails(machine);
    if (latestSetDetails != null) {
      setsController.text = latestSetDetails['sets'] ?? '0';
      repsController.text = latestSetDetails['reps'] ?? '0';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Sets and Reps'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: setsController,
                decoration: InputDecoration(
                  labelText: 'Sets',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: repsController,
                decoration: InputDecoration(
                  labelText: 'Reps',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
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
                final sets = setsController.text.trim();
                final reps = repsController.text.trim();
                if (sets.isNotEmpty && reps.isNotEmpty) {
                  setState(() {
                    _selectedExercises.add({
                      'bodyPart': bodyPart,
                      'machine': machine,
                      'sets': sets,
                      'reps': reps,
                    });
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editExercise(int index) {
    final exercise = _selectedExercises[index];
    final setsController = TextEditingController(text: exercise['sets']);
    final repsController = TextEditingController(text: exercise['reps']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Sets and Reps'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: setsController,
                decoration: InputDecoration(
                  labelText: 'Sets',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: repsController,
                decoration: InputDecoration(
                  labelText: 'Reps',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
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
                final sets = setsController.text.trim();
                final reps = repsController.text.trim();
                if (sets.isNotEmpty && reps.isNotEmpty) {
                  setState(() {
                    _selectedExercises[index]['sets'] = sets;
                    _selectedExercises[index]['reps'] = reps;
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveRoutine() async {
    final routineName = _routineNameController.text.trim();
    if (routineName.isNotEmpty && _selectedExercises.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final exercisesData = _selectedExercises
            .map((exercise) => {
                  'bodyPart': exercise['bodyPart'],
                  'machine': exercise['machine'],
                  'sets': exercise['sets'],
                  'reps': exercise['reps'],
                })
            .toList();

        final routineData = {
          'name': routineName,
          'exercises': exercisesData,
        };

        if (widget.routineData != null) {
          // Editing an existing routine
          final routineId = widget.routineData!['id'];
          await FirebaseFirestore.instance
              .collection('data')
              .doc(user.uid)
              .collection('routines')
              .doc(routineId)
              .update(routineData);
          Get.back();
        } else {
          // Creating a new routine
          await FirebaseFirestore.instance
              .collection('data')
              .doc(user.uid)
              .collection('routines')
              .add(routineData);
          Get.back();
        }
      } else {
        print('User is not logged in');
      }
    } else {
      // Show an error message or a snackbar indicating that the routine name and exercises are required
    }
  }

  Future<List<Map<String, String>>?> fetchLatestSetDetails(
      String machineName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Fetch the latest workout containing the specified machine
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection('data')
            .doc(userId)
            .collection('workouts')
            .orderBy('timestamp', descending: true)
            .limit(14)
            .get();

        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            var workoutData = doc.data();
            List<dynamic> exercises = workoutData['exercises'];

            var exerciseContainingMachine = exercises.firstWhere(
                (exercise) => exercise['machine'] == machineName,
                orElse: () => null);

            if (exerciseContainingMachine != null) {
              List<dynamic> sets = exerciseContainingMachine['sets'];
              if (sets.isNotEmpty) {
                return sets.map<Map<String, String>>((set) {
                  return {
                    'reps': set['reps'] ?? 'Data Not Available',
                    'weight': set['weight'] ?? 'Data Not Available',
                  };
                }).toList();
              } else {
                print('No sets available for $machineName');
              }
            } else {
              print(
                  'Exercise containing $machineName not found in this workout');
            }
          }
        } else {
          print('No workout data available');
        }
      } else {
        throw Exception('User is not logged in');
      }
    } catch (e) {
      print('Error fetching latest set details: $e');
    }
    return null; // Return null if there's an error or no data
  }
}
