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
          labelData: const RotationStageLabelData(
            front: "front",
            left: 'left',
            right: 'right',
            back: 'back',
          ),
          onSelectionUpdated: (selectedParts) {
            setState(() {
              _bodyParts = selectedParts;
            });
            _showSelectedBodyPartsDialog(context, _bodyParts);
          },
          mirrored: true,
          padding: EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  void _showSelectedBodyPartsDialog(BuildContext context, BodyParts bodyParts) {
    final changedParts = <String>[];

    if (bodyParts.head) changedParts.add('Head');
    if (bodyParts.neck) changedParts.add('Neck');
    if (bodyParts.leftShoulder) changedParts.add('Left Shoulder');
    if (bodyParts.leftUpperArm) changedParts.add('Left Upper Arm');
    if (bodyParts.leftElbow) changedParts.add('Left Elbow');
    if (bodyParts.leftLowerArm) changedParts.add('Left Lower Arm');
    if (bodyParts.leftHand) changedParts.add('Left Hand');
    if (bodyParts.rightShoulder) changedParts.add('Right Shoulder');
    if (bodyParts.rightUpperArm) changedParts.add('Right Upper Arm');
    if (bodyParts.rightElbow) changedParts.add('Right Elbow');
    if (bodyParts.rightLowerArm) changedParts.add('Right Lower Arm');
    if (bodyParts.rightHand) changedParts.add('Right Hand');
    if (bodyParts.upperBody) changedParts.add('Upper Body');
    if (bodyParts.lowerBody) changedParts.add('Lower Body');
    if (bodyParts.leftUpperLeg) changedParts.add('Left Upper Leg');
    if (bodyParts.leftKnee) changedParts.add('Left Knee');
    if (bodyParts.leftLowerLeg) changedParts.add('Left Lower Leg');
    if (bodyParts.leftFoot) changedParts.add('Left Foot');
    if (bodyParts.rightUpperLeg) changedParts.add('Right Upper Leg');
    if (bodyParts.rightKnee) changedParts.add('Right Knee');
    if (bodyParts.rightLowerLeg) changedParts.add('Right Lower Leg');
    if (bodyParts.rightFoot) changedParts.add('Right Foot');
    if (bodyParts.abdomen) changedParts.add('Abdomen');
    if (bodyParts.vestibular) changedParts.add('Vestibular');

    if (changedParts.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selected Body Parts'),
          content: SingleChildScrollView(
            child: ListBody(
              children: changedParts.map((part) => Text(part)).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
