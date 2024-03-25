import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class WorkoutLoggingForm extends StatefulWidget {
  final String bodyPart;
  final String machine;
  final UserDataViewModel _userDataViewModel = Get.find();

  WorkoutLoggingForm({required this.bodyPart, required this.machine});

  @override
  _WorkoutLoggingFormState createState() => _WorkoutLoggingFormState();
}

class _WorkoutLoggingFormState extends State<WorkoutLoggingForm> {
  List<SetData> sets = [SetData()]; // Initial list with one set

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Workout - ${widget.machine}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int index = 0; index < sets.length; index++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set ${index + 1}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    onChanged: (value) => sets[index].reps = value,
                    decoration: InputDecoration(labelText: 'Reps'),
                  ),
                  TextFormField(
                    onChanged: (value) => sets[index].weight = value,
                    decoration: InputDecoration(labelText: 'Weight'),
                  ),
                  TextFormField(
                    onChanged: (value) => sets[index].notes = value,
                    decoration: InputDecoration(labelText: 'Notes'),
                  ),
                ],
              ),
            ElevatedButton(
              onPressed: _addSet,
              child: Text('Add Set'),
            ),
            ElevatedButton(
              onPressed: _saveWorkoutDetails,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _addSet() {
    setState(() {
      sets.add(SetData());
    });
  }

  void _saveWorkoutDetails() {
    List<Map<String, dynamic>> setsData = [];
    sets.forEach((set) {
      setsData.add({
        'reps': set.reps,
        'weight': set.weight,
        'notes': set.notes,
      });
    });

    // Save workout details using UserDataViewModel
    widget._userDataViewModel.addWorkoutDetails({
      'timestamp': DateTime.now(),
      'bodyPart': widget.bodyPart,
      'machine': widget.machine,
      'sets': setsData,
    });

    // Navigate back to the machine selection screen
    Get.back();
  }
}

class SetData {
  String reps = '';
  String weight = '';
  String notes = '';
}
