import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/main_screen/pedometer_controller.dart';

class DailyStepRecords extends StatelessWidget {
  final PedometerController _pedometerController =
      Get.put(PedometerController());

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
          return ListView.builder(
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
      }),
    );
  }
}
