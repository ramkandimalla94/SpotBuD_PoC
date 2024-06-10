import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/main_screen/screens/home/workout_logging/exercise_selection/body.dart';
import 'package:spotbud/ui/view/main_screen/screens/home/workout_logging/exercise_selection/machine_selection_view.dart';

class CreateRoutineScreen extends StatefulWidget {
  @override
  _CreateRoutineScreenState createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  final TextEditingController _routineNameController = TextEditingController();
  final List<Map<String, String>> _selectedExercises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Routine'),
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
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        setState(() {
                          _selectedExercises.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addExercise,
              child: Text('Add Exercise'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveRoutine,
              child: Text('Save Routine'),
            ),
          ],
        ),
      ),
    );
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
          setState(() {
            _selectedExercises.add({'bodyPart': bodyPart, 'machine': machine});
          });
        }
      }
    }
  }

  Future<void> _saveRoutine() async {
    final routineName = _routineNameController.text.trim();
    if (routineName.isNotEmpty && _selectedExercises.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final routineData = {
          'name': routineName,
          'exercises': _selectedExercises,
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('routines')
            .add(routineData);

        Get.back();
      } else {
        print('User is not logged in');
      }
    } else {
      // Show an error message or a snackbar indicating that the routine name and exercises are required
    }
  }
}
