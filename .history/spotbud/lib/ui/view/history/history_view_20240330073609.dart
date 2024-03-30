import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  List<String> machinesList = [];
  List<String> bodyPartsList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _fetchMachines();
    await _fetchBodyParts();
  }

  Future<void> _fetchMachines() async {
    List<String> machines = await _userDataViewModel.fetchDistinctMachines();
    setState(() {
      machinesList = machines;
    });
  }

  Future<void> _fetchBodyParts() async {
    List<String> bodyParts = await _userDataViewModel.fetchDistinctBodyParts();
    setState(() {
      bodyPartsList = bodyParts;
    });
  }

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
      body: Column(
        children: [
          Column(
            children: [
              Text(
                'Filters',
                style: AppTheme.primaryText(
                    color: AppColors.acccentColor,
                    fontWeight: FontWeight.w500,
                    size: 18),
              ),
              _buildFilterDropdowns(),
            ],
          ),
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
                  // Filter workout history based on selected body part and machine
                  List<Map<String, dynamic>> filteredHistory = snapshot.data!
                      .where((workout) =>
                          (selectedBodyPart == null ||
                              workout['bodyPart'] == selectedBodyPart) &&
                          (selectedMachine == null ||
                              workout['machine'] == selectedMachine))
                      .toList();

                  // Sort filtered workout history by date
                  filteredHistory
                      .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

                  // Group filtered workout history by date
                  Map<DateTime, List<Map<String, dynamic>>> groupedByDate = {};
                  filteredHistory.forEach((workout) {
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
    List<String> filteredMachines = [];

    if (selectedBodyPart != null) {
      // Filter machines based on selected body part
      filteredMachines = machinesList.where((machine) {
        // Get machines associated with the selected body part
        return _userDataViewModel
            .getMachinesForBodyPart(selectedBodyPart!)
            .contains(machine);
      }).toList();
    } else {
      // If no body part is selected, show all machines
      filteredMachines = machinesList;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButton<String>(
          value: selectedBodyPart,
          hint: Text(
            'Select Body Part',
            style: AppTheme.primaryText(
                color: AppColors.acccentColor,
                fontWeight: FontWeight.w500,
                size: 18),
          ),
          icon: Icon(Icons.arrow_drop_down, color: AppColors.acccentColor),
          onChanged: (value) {
            setState(() {
              selectedBodyPart = value;
              // Reset selected machine when body part changes
              selectedMachine = null;
              // Fetch machines based on the selected body part
              _fetchMachines();
            });
          },
          dropdownColor: AppColors.bluebackgroundColor,
          items: bodyPartsList.map<DropdownMenuItem<String>>((bodyPart) {
            return DropdownMenuItem<String>(
              value: bodyPart,
              child: Text(
                bodyPart,
                style: AppTheme.primaryText(
                    color: AppColors.acccentColor,
                    fontWeight: FontWeight.w500,
                    size: 18),
              ),
            );
          }).toList(),
        ),
        DropdownButton<String>(
          value: selectedMachine,
          hint: Text(
            'Select Machine',
            style: AppTheme.primaryText(
                color: AppColors.acccentColor,
                fontWeight: FontWeight.w500,
                size: 18),
          ),
          icon: Icon(Icons.arrow_drop_down, color: AppColors.acccentColor),
          dropdownColor: AppColors.acccentColor,
          onChanged: (value) {
            setState(() {
              selectedMachine = value;
            });
          },
          items: filteredMachines.map<DropdownMenuItem<String>>((machine) {
            return DropdownMenuItem<String>(
              value: machine,
              child: Text(
                machine,
                style: AppTheme.primaryText(
                    color: AppColors.acccentColor,
                    fontWeight: FontWeight.w500,
                    size: 18),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<Widget> _buildBodyPartSegments(List<Map<String, dynamic>> workouts) {
    return workouts.map((workout) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < workout['sets'].length; index++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
    }).toList();
  }
}
