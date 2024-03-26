import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
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
        title: Text(
          'Log Workout ',
          style: AppTheme.primaryText(fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${widget.machine}',
                style: AppTheme.primaryText(fontWeight: FontWeight.w500),
              ),

              for (int index = 0; index < sets.length; index++)
                _buildSetInput(index),
              SizedBox(height: 20),
              buildWorkoutButton(onPressed: _addSet, text: 'Add Set'),
              // ElevatedButton(
              //   onPressed: _addSet,
              //   child: Text('Add Set'),
              // ),
              SizedBox(height: 5),
              buildWorkoutButton(text: 'Save', onPressed: _saveWorkoutDetails),
              // ElevatedButton(
              //   onPressed: _saveWorkoutDetails,
              //   child: Text('Save'),
              // ),
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
        borderRadius: BorderRadius.circular(15), // Rounded corners
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
                      color:
                          AppColors.acccentColor), // Set text bolder and bigger
                ),
                if (index > 0)
                  {
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => _removeSet(index),
                      color: AppColors.acccentColor, // Close button color
                    ),
                  }
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: sets[index].reps,
                    onChanged: (value) => sets[index].reps = value,
                    decoration: InputDecoration(
                      labelText: 'Reps',
                      labelStyle: TextStyle(
                        color: AppColors.acccentColor,
                      ), // Label text color
                      // fillColor: AppColors.acccentColor, // Set TextField color
                      // filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Rounded corners for border
                        borderSide: BorderSide(
                          color: AppColors.acccentColor,
                        ),
                        // borderSide: BorderSide.none, // No border
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: sets[index].weight,
                    onChanged: (value) => sets[index].weight = value,
                    decoration: InputDecoration(
                      labelText: 'Weight',
                      labelStyle: TextStyle(
                        color: AppColors.acccentColor,
                      ), // Label text color
                      // fillColor: AppColors.acccentColor, // Set TextField color
                      // filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.acccentColor,
                        ),
                        // Rounded corners for border
                        //borderSide: BorderSide.none, // No border
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    focusColor: AppColors.acccentColor,

                    value: 'kg', // Default unit
                    onChanged: (value) {
                      setState(() {
                        // Handle unit change
                      });
                    },
                    items: ['kg'].map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(
                          unit,
                          style: TextStyle(color: AppColors.acccentColor),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Unit',
                      labelStyle: TextStyle(
                        color: AppColors.acccentColor,
                      ), // Label text color

                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.acccentColor)
                          // Rounded corners for border
                          // borderSide: BorderSide.none, // No border
                          ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: sets[index].notes,
              onChanged: (value) => sets[index].notes = value,
              maxLines: 3, // Allow for multiline input
              decoration: InputDecoration(
                labelText: 'Notes',
                labelStyle: TextStyle(
                  color: AppColors.acccentColor,
                ), // Label text color
                // fillColor: AppColors.acccentColor, // Set TextField color
                // filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppColors.acccentColor,
                  ),

                  // Rounded corners for border
                  //borderSide: BorderSide.none, // No border
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addSet() {
    // Check if the previous set is fully filled before adding a new set
    if (sets.last.reps.isNotEmpty &&
        sets.last.weight.isNotEmpty &&
        sets.last.notes.isNotEmpty) {
      setState(() {
        sets.add(SetData());
      });
    } else {
      // Show a snackbar or toast indicating that the previous set must be fully filled
      // before adding a new set
      // For example:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Please fill all fields in the previous set first. (Notes is optional)'),
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
    // Check if all sets have at least reps and weight filled
    bool allSetsFilled =
        sets.every((set) => set.reps.isNotEmpty && set.weight.isNotEmpty);

    if (allSetsFilled) {
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
    } else {
      // Show a snackbar or toast indicating that all sets must have reps and weight filled
      // before saving
      // For example:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please fill reps and weight in all sets before saving.'),
        ),
      );
    }
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
