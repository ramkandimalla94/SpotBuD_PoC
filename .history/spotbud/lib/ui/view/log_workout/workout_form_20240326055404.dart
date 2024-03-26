import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int index = 0; index < sets.length; index++)
                _buildSetInput(index),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addSet,
                child: Text('Add Set'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveWorkoutDetails,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetInput(int index) {
    return Card(
      color: AppColors.black,
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Set ${index + 1}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => _removeSet(index),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: sets[index].reps,
              onChanged: (value) => sets[index].reps = value,
              decoration: InputDecoration(labelText: 'Reps'),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: sets[index].weight,
              onChanged: (value) => sets[index].weight = value,
              decoration: InputDecoration(labelText: 'Weight'),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: sets[index].notes,
              onChanged: (value) => sets[index].notes = value,
              decoration: InputDecoration(labelText: 'Notes'),
            ),
          ],
        ),
      ),
    );
  }

  void _addSet() {
    setState(() {
      sets.add(SetData.fromSet(sets.last));
    });
  }

  void _removeSet(int index) {
    setState(() {
      sets.removeAt(index);
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

  SetData({this.reps = '', this.weight = '', this.notes = ''});

  SetData.fromSet(SetData other) {
    reps = other.reps;
    weight = other.weight;
    notes = other.notes;
  }
}
