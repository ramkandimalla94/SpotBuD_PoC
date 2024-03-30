import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/history_viewmodel.dart';

class HistoryPage extends StatelessWidget {
  final HistoryViewModel _historyViewModel = Get.put(HistoryViewModel());

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
          _buildFilters(),
          Expanded(
            child: Obx(
              () => _buildHistoryList(_historyViewModel.workoutHistory),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDropdown(
            label: 'Filter by Machine',
            items: _historyViewModel.uniqueMachines,
            onChanged: (value) => _historyViewModel.filterByMachine(value),
          ),
          _buildDropdown(
            label: 'Filter by Body Part',
            items: _historyViewModel.uniqueBodyParts,
            onChanged: (value) => _historyViewModel.filterByBodyPart(value),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButton<String>(
      hint: Text(label),
      onChanged: onChanged,
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
    );
  }

  Widget _buildHistoryList(List<Map<String, dynamic>> history) {
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> workout = history[index];
        return ExpansionTile(
          title: Text(
            DateFormat.yMMMd().format(workout['timestamp'].toDate()),
            style: AppTheme.primaryText(
                color: AppColors.acccentColor,
                fontWeight: FontWeight.w500,
                size: 18),
          ),
          trailing: Icon(
            Icons.arrow_drop_down,
            color: AppColors.acccentColor,
          ),
          children: _buildWorkoutDetails(workout['sets']),
        );
      },
    );
  }

  List<Widget> _buildWorkoutDetails(List<dynamic> sets) {
    return sets
        .map<Widget>((set) => ListTile(
              title: Text(
                'Reps: ${set['reps']}, Weight: ${set['weight']}, Notes: ${set['notes']}',
                style: AppTheme.primaryText(
                    color: AppColors.backgroundColor,
                    fontWeight: FontWeight.w500,
                    size: 15),
              ),
            ))
        .toList();
  }
}
