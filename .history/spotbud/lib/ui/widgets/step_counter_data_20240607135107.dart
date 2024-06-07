import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotbud/ui/view/main_screen/screens/home/pedometer_controller.dart';

class DailyStepRecords extends StatelessWidget {
  final PedometerViewModel _pedometerController = Get.put(PedometerViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Step Records'),
      ),
      body: Obx(() {
        if (_pedometerController.dailyStepRecords.isEmpty) {
          return Center(
            child: Text('No data available.'),
          );
        } else {
          return ListView(
            children: [
              _buildCurrentDayCard(),
              SizedBox(height: 20),
              _buildHistoryList(),
            ],
          );
        }
      }),
    );
  }

  Widget _buildCurrentDayCard() {
    return Card(
      child: ListTile(
        title: Text('Today (${_getCurrentDate()})'),
        subtitle: Text('Steps: ${_pedometerController.dailySteps.value}'),
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _pedometerController.dailyStepRecords.length,
      itemBuilder: (context, index) {
        String date =
            _pedometerController.dailyStepRecords.keys.elementAt(index);
        int steps = _pedometerController.dailyStepRecords[date] ?? 0;

        return ListTile(
          title: Text('Date: $date'),
          subtitle: Text('Steps: $steps'),
        );
      },
    );
  }

  String _getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
}
