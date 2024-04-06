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
  String? selectedBodyPart;
  String? selectedMachine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bluebackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.bluebackgroundColor,
        iconTheme: IconThemeData(color: AppColors.acccentColor),
        title: Text(
          'Workout History',
          style: AppTheme.primaryText(
              fontWeight: FontWeight.w500, color: AppColors.acccentColor),
        ),
      ),
      body: Column(
        children: [
          _buildFilterDropdowns(),
          Expanded(
            child: FutureBuilder(
              future: _userDataViewModel.fetchWorkoutHistory(),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // Filter workouts based on selected body part and machine
                  List<Map<String, dynamic>> filteredWorkouts = snapshot.data!;
                  if (selectedBodyPart != null) {
                    filteredWorkouts = filteredWorkouts
                        .where((workout) =>
                            workout['bodyPart'] == selectedBodyPart)
                        .toList();
                  }
                  if (selectedMachine != null) {
                    filteredWorkouts = filteredWorkouts
                        .where(
                            (workout) => workout['machine'] == selectedMachine)
                        .toList();
                  }

                  // Sort filtered workout history by date
                  filteredWorkouts
                      .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

                  // Group workout history by date
                  Map<DateTime, List<Map<String, dynamic>>> groupedByDate = {};
                  filteredWorkouts.forEach((workout) {
                    DateTime date = workout['timestamp'].toDate();
                    DateTime formattedDate =
                        DateTime(date.year, date.month, date.day);
                    if (groupedByDate.containsKey(formattedDate)) {
                      groupedByDate[formattedDate]!.add(workout);
                    } else {
                      groupedByDate[formattedDate] = [workout];
                    }
                  });

                  return ListView(
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
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdowns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButton<String>(
          value: selectedBodyPart,
          hint: Text('Select Body Part'),
          onChanged: (value) {
            setState(() {
              selectedBodyPart = value;
            });
          },
          items: _userDataViewModel.bodyParts
              .map<DropdownMenuItem<String>>((bodyPart) {
            return DropdownMenuItem<String>(
              value: bodyPart,
              child: Text(bodyPart),
            );
          }).toList(),
        ),
        DropdownButton<String>(
          value: selectedMachine,
          hint: Text('Select Machine'),
          onChanged: (value) {
            setState(() {
              selectedMachine = value;
            });
          },
          items: _userDataViewModel.machines
              .map<DropdownMenuItem<String>>((machine) {
            return DropdownMenuItem<String>(
              value: machine,
              child: Text(machine),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<Widget> _buildBodyPartSegments(List<Map<String, dynamic>> workouts) {
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