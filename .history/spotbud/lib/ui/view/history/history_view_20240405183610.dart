import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class HistoryView extends StatelessWidget {
  final UserDataViewModel userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
      ),
      body: FutureBuilder(
        future: userDataViewModel.fetchWorkoutHistory(),
        builder: (context,
            AsyncSnapshot<Map<String, List<Map<String, dynamic>>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final workoutHistoryByDate = snapshot.data!;

            return ListView.builder(
              itemCount: workoutHistoryByDate.length,
              itemBuilder: (context, index) {
                final date = workoutHistoryByDate.keys.elementAt(index);
                final workoutDetails = workoutHistoryByDate[date]!;

                return Column(
                  children: [
                    ListTile(
                      title: Text(date),
                      trailing: DropdownButton(
                        items: workoutDetails
                            .map<DropdownMenuItem<String>>((workout) {
                          // Assuming workout has an 'endTime' field
                          String endTime = workout['endTime'] ??
                              ''; // Replace 'endTime' with actual field name
                          return DropdownMenuItem<String>(
                            value: endTime,
                            child: Text(endTime),
                          );
                        }).toList(),
                        onChanged: (selectedEndTime) {
                          // Handle selection of workout details
                          // You can display the selected workout details based on the selected end time here
                        },
                      ),
                    ),
                    Divider(), // Optional: Add divider between dates
                  ],
                );
              },
            );
          } else {
            return Center(child: Text('No workout history available'));
          }
        },
      ),
    );
  }
}
