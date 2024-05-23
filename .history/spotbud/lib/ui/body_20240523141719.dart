import 'package:flutter/material.dart';
import 'package:body_part_selector/body_part_selector.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/machine_selection_view.dart';
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
    if (bodyParts.leftShoulder || bodyParts.rightShoulder)
      changedParts.add('Shoulders');
    if (bodyParts.leftUpperArm || bodyParts.rightUpperArm)
      changedParts.add('Upper Arms');
    if (bodyParts.leftElbow || bodyParts.rightElbow) changedParts.add('Elbows');
    if (bodyParts.leftLowerArm || bodyParts.rightLowerArm)
      changedParts.add('Lower Arms');
    if (bodyParts.leftHand || bodyParts.rightHand) changedParts.add('Hands');
    if (bodyParts.upperBody) changedParts.add('Upper Body');
    if (bodyParts.lowerBody) changedParts.add('Lower Body');
    if (bodyParts.leftUpperLeg || bodyParts.rightUpperLeg)
      changedParts.add('Upper Legs');
    if (bodyParts.leftKnee || bodyParts.rightKnee) changedParts.add('Knees');
    if (bodyParts.leftLowerLeg || bodyParts.rightLowerLeg)
      changedParts.add('Lower Legs');
    if (bodyParts.leftFoot || bodyParts.rightFoot) changedParts.add('Feet');
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
                Get.toNamed(MachineSelectionScreen(bodyPart: ))
              },
            ),
          ],
        );
      },
    );
  }
}
