import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
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

                return ExpansionTile(
                  title: Text(date), // Date as the title
                  children: _buildWorkoutDetails(
                      workoutDetails), // Workout details as children
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

  List<Widget> _buildWorkoutDetails(List<Map<String, dynamic>> workoutDetails) {
    return workoutDetails.map((workout) {
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
