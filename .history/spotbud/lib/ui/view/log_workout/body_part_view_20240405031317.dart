import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              Get.toNamed('/machineselection', arguments: bodyPart);
            },
          );
        },
      ),
    );
  }
}
