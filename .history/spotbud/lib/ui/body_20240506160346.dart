import 'package:flutter/material.dart';
import 'package:body_part_selector/body_part_selector.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

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
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: BodyPartSelectorTurnable(
          bodyParts: _bodyParts,
          onSelectionUpdated: (selectedParts) {
            setState(() {
              _bodyParts = selectedParts;
              print(_bodyParts);
            });

            // Print the selected body parts
            // print(_bodyParts);
          },
          mirrored: true,
          padding: EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}
