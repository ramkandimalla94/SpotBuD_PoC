import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/machine_selection_view.dart';

class BodyPartSelectionScreen extends StatelessWidget {
  final List<String> bodyParts = [
    'Chest',
    'Back',
    'Legs',
    'Arms',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Body Part'),
      ),
      body: ListView.builder(
        itemCount: bodyParts.length,
        itemBuilder: (context, index) {
          final bodyPart = bodyParts[index];
          return ListTile(
            title: Text(bodyPart),
            onTap: () {
              Get.to(MachineSelectionScreen());
            },
          );
        },
      ),
    );
  }
}
