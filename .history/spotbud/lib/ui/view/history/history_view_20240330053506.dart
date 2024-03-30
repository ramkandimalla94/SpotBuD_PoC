import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final UserDataViewModel _userDataViewModel = Get.find();

  // Variables to hold selected filter values
  String _selectedMachine = '';
  String _selectedBodyPart = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bluebackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.bluebackgroundColor,
        iconTheme: IconThemeData(color: AppColors.acccentColor),
        title: Text(
          'Workout History ',
          style: AppTheme.primaryText(
              fontWeight: FontWeight.w500, color: AppColors.acccentColor),
        ),
      ),
      body: FutureBuilder(
        future: _userDataViewModel.fetchWorkoutHistory(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Sort workout history by date
            snapshot.data!
                .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

            // Group workout history by date
            Map<DateTime, List<Map<String, dynamic>>> groupedByDate = {};
            snapshot.data!.forEach((workout) {
              DateTime date = workout['timestamp'].toDate();
              DateTime formattedDate =
                  DateTime(date.year, date.month, date.day);
              if (groupedByDate.containsKey(formattedDate)) {
                groupedByDate[formattedDate]!.add(workout);
              } else {
                groupedByDate[formattedDate] = [workout];
              }
            });

            return Column(
              children: [
                _buildFilters(),
                Expanded(
                  child: ListView(
                    children: groupedByDate.entries.map((entry) {
                      return ExpansionTile(
                        title: Text(
                          DateFormat.yMMMd().format(entry.key),
                          style: AppTheme.primaryText(
                              color: AppColors.acccentColor,
                              fontWeight: FontWeight.w500,
                              size: 18),
                        ),
                        trailing: Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.acccentColor,
                        ),
                        children: _buildBodyPartSegments(entry.value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DropdownButton<String>(
            value: _selectedMachine,
            hint: Text('Filter by Machine'),
            onChanged: (newValue) {
              setState(() {
                _selectedMachine = newValue!;
              });
            },
            items: _buildDropdownItems(_getUniqueValues('machine')),
          ),
          DropdownButton<String>(
            value: _selectedBodyPart,
            hint: Text('Filter by Body Part'),
            onChanged: (newValue) {
              setState(() {
                _selectedBodyPart = newValue!;
              });
            },
            items: _buildDropdownItems(_getUniqueValues('bodyPart')),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(List<String> values) {
    return values
        .map((value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ))
        .toList();
  }

  List<String> _getUniqueValues(String key) {
    List<String> uniqueValues = [];
    snapshot.data!.forEach((workout) {
      String value = workout[key];
      if (!uniqueValues.contains(value)) {
        uniqueValues.add(value);
      }
    });
    return uniqueValues;
  }

  List<Widget> _buildBodyPartSegments(List<Map<String, dynamic>> workouts) {
    // Filter workouts based on selected machine and body part
    if (_selectedMachine.isNotEmpty) {
      workouts = workouts
          .where((workout) => workout['machine'] == _selectedMachine)
          .toList();
    }
    if (_selectedBodyPart.isNotEmpty) {
      workouts = workouts
          .where((workout) => workout['bodyPart'] == _selectedBodyPart)
          .toList();
    }

    Set<String> bodyParts = Set<String>();
    workouts.forEach((workout) {
      bodyParts.add(workout['bodyPart']);
    });

    return bodyParts.map((bodyPart) {
      List<Map<String, dynamic>> filteredWorkouts =
          workouts.where((workout) => workout['bodyPart'] == bodyPart).toList();

      return ExpansionTile(
        title: Text(
          bodyPart,
          style: AppTheme.primaryText(
              color: AppColors.backgroundColor,
              fontWeight: FontWeight.w500,
              size: 18),
        ),
        trailing: Icon(
          Icons.arrow_drop_down,
          color: AppColors.backgroundColor,
        ),
        children: filteredWorkouts.map((workout) {
          return ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                workout['machine'],
                style: AppTheme.primaryText(
                    color: AppColors.acccentColor,
                    fontWeight: FontWeight.w500,
                    size: 18),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align children to the start
              children: [
                for (var index = 0; index < workout['sets'].length; index++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Align children to the start
                      children: [
                        Text(
                          'Set ${index + 1}: ',
                          style: AppTheme.primaryText(
                              color: AppColors.backgroundColor,
                              fontWeight: FontWeight.w500,
                              size: 15),
                        ),
                        Text(
                          'Reps: ${workout['sets'][index]['reps']}, Weight: ${workout['sets'][index]['weight']}, Notes: ${workout['sets'][index]['notes']}',
                          style: AppTheme.primaryText(
                              color: AppColors.backgroundColor,
                              fontWeight: FontWeight.w500,
                              size: 15),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      );
    }).toList();
  }
}
