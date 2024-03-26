import 'package:flutter/material.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';

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
            color: AppColors.black, fontWeight: FontWeight.w500, size: 18),
      ),
      children: filteredWorkouts.map((workout) {
        return ListTile(
          title: Text(
            workout['machine'],
            style: AppTheme.primaryText(
                color: AppColors.acccentColor,
                fontWeight: FontWeight.w500,
                size: 18),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < workout['sets'].length; index++)
                Column(
                  children: [
                    Text(
                      'Set ${index + 1}: ',
                      style: AppTheme.primaryText(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          size: 15),
                    ),
                    Text(
                      'Reps: ${workout['sets'][index]['reps']}, Weight: ${workout['sets'][index]['weight']}, Notes: ${workout['sets'][index]['notes']}',
                      style: AppTheme.primaryText(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          size: 15),
                    ),
                  ],
                ),
            ],
          ),
        );
      }).toList(),
    );
  }).toList();
}
