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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selected Body Parts'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Head: ${bodyParts.head}'),
                Text('Neck: ${bodyParts.neck}'),
                Text('Left Shoulder: ${bodyParts.leftShoulder}'),
                Text('Left Upper Arm: ${bodyParts.leftUpperArm}'),
                Text('Left Elbow: ${bodyParts.leftElbow}'),
                Text('Left Lower Arm: ${bodyParts.leftLowerArm}'),
                Text('Left Hand: ${bodyParts.leftHand}'),
                Text('Right Shoulder: ${bodyParts.rightShoulder}'),
                Text('Right Upper Arm: ${bodyParts.rightUpperArm}'),
                Text('Right Elbow: ${bodyParts.rightElbow}'),
                Text('Right Lower Arm: ${bodyParts.rightLowerArm}'),
                Text('Right Hand: ${bodyParts.rightHand}'),
                Text('Upper Body: ${bodyParts.upperBody}'),
                Text('Lower Body: ${bodyParts.lowerBody}'),
                Text('Left Upper Leg: ${bodyParts.leftUpperLeg}'),
                Text('Left Knee: ${bodyParts.leftKnee}'),
                Text('Left Lower Leg: ${bodyParts.leftLowerLeg}'),
                Text('Left Foot: ${bodyParts.leftFoot}'),
                Text('Right Upper Leg: ${bodyParts.rightUpperLeg}'),
                Text('Right Knee: ${bodyParts.rightKnee}'),
                Text('Right Lower Leg: ${bodyParts.rightLowerLeg}'),
                Text('Right Foot: ${bodyParts.rightFoot}'),
                Text('Abdomen: ${bodyParts.abdomen}'),
                Text('Vestibular: ${bodyParts.vestibular}'),
              ],
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
