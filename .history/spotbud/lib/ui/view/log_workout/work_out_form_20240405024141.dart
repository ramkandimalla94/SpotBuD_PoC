import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/body_part_selection_screen.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class WorkoutLoggingForm extends StatefulWidget {
  @override
  _WorkoutLoggingFormState createState() => _WorkoutLoggingFormState();
}

class _WorkoutLoggingFormState extends State<WorkoutLoggingForm> {
  final UserDataViewModel _userDataViewModel = Get.find();
  List<SetData> sets = [SetData()]; // Initial list with one set
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _endTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bluebackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.bluebackgroundColor,
        title: Text('Add Workout', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveWorkoutDetails,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddExercise,
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Today\'s Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Start Time:',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${_startTime.hour}:${_startTime.minute}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  Text(
                    'End Time:',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${_endTime.hour}:${_endTime.minute}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              for (int index = 0; index < sets.length; index++)
                _buildSetInput(index),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetInput(int index) {
    return Card(
      color: AppColors.primaryColor,
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.acccentColor,
                  ),
                ),
                if (index > 0)
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => _removeSet(index),
                    color: AppColors.acccentColor,
                  ),
              ],
            ),
            SizedBox(height: 20),
            // Widgets for entering reps, weight, unit, and notes
          ],
        ),
      ),
    );
  }

  void _addSet() {
    // Check if the previous set is fully filled before adding a new set
    if (sets.last.reps.isNotEmpty && sets.last.weight.isNotEmpty) {
      setState(() {
        sets.add(SetData());
      });
    } else {
      // Show a snackbar indicating that the previous set must be fully filled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all fields in the previous set first. (Notes is optional)',
          ),
        ),
      );
    }
  }

  void _removeSet(int index) {
    setState(() {
      sets.removeAt(index);
    });
  }

  void _saveWorkoutDetails() {
    // Save workout details
  }

  void _navigateToAddExercise() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BodyPartSelectionScreen();
      },
    );
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
