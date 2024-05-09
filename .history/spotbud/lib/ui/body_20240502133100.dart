import 'package:flutter/material.dart';
import 'package:body_part_selector/body_part_selector.dart';

class Bodypart extends StatefulWidget {
  const Bodypart({super.key});

  @override
  State<Bodypart> createState() => _BodypartState();
}

class _BodypartState extends State<Bodypart> {
  BodyParts _bodyParts = const BodyParts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BodyPartSelectorTurnable(
          bodyParts: _bodyParts,
          onSelectionUpdated: (selectedParts) {
            setState(() {
              _bodyParts = selectedParts;
            });

            // Print the selected body parts
            printSelectedBodyParts(_bodyParts);
          },
          labelData: const RotationStageLabelData(
            front: 'Front',
            left: 'Left',
            right: 'Right',
            back: 'Back',
          ),
        ),
      ),
    );
  }
}

void printSelectedBodyParts(Map<String, bool> bodyParts) {
  print('Selected Body Parts:');
  bodyParts.forEach((part, isSelected) {
    if (isSelected) {
      print(part);
    }
  });
}
