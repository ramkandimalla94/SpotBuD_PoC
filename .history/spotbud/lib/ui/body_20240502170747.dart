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
              // Update selected parts
              _bodyParts = selectedParts;

              // If a left part is selected, also select the corresponding right part
              if (_bodyParts.leftHand) {
                _bodyParts = _bodyParts.copyWith(rightHand: true);
              } else if (_bodyParts.leftLowerArm) {
                _bodyParts = _bodyParts.copyWith(rightLowerArm: true);
              } else if (_bodyParts.leftElbow) {
                _bodyParts = _bodyParts.copyWith(rightElbow: true);
              } else if (_bodyParts.leftUpperArm) {
                _bodyParts = _bodyParts.copyWith(rightUpperArm: true);
              } else if (_bodyParts.leftShoulder) {
                _bodyParts = _bodyParts.copyWith(rightShoulder: true);
              } else if (!_bodyParts.leftHand) {
                _bodyParts = _bodyParts.copyWith(rightHand: false);
              } else if (!_bodyParts.leftLowerArm) {
                _bodyParts = _bodyParts.copyWith(rightLowerArm: false);
              } else if (!_bodyParts.leftElbow) {
                _bodyParts = _bodyParts.copyWith(rightElbow: false);
              } else if (!_bodyParts.leftUpperArm) {
                _bodyParts = _bodyParts.copyWith(rightUpperArm: false);
              } else if (!_bodyParts.leftShoulder) {
                _bodyParts = _bodyParts.copyWith(rightShoulder: false);
              }

              // If a right part is selected, also select the corresponding left part
              if (_bodyParts.rightHand) {
                _bodyParts = _bodyParts.copyWith(leftHand: true);
              } else if (_bodyParts.rightLowerArm) {
                _bodyParts = _bodyParts.copyWith(leftLowerArm: true);
              } else if (_bodyParts.rightElbow) {
                _bodyParts = _bodyParts.copyWith(leftElbow: true);
              } else if (_bodyParts.rightUpperArm) {
                _bodyParts = _bodyParts.copyWith(leftUpperArm: true);
              } else if (_bodyParts.rightShoulder) {
                _bodyParts = _bodyParts.copyWith(leftShoulder: true);
              } else if (!_bodyParts.rightHand) {
                _bodyParts = _bodyParts.copyWith(leftHand: false);
              } else if (!_bodyParts.rightLowerArm) {
                _bodyParts = _bodyParts.copyWith(leftLowerArm: false);
              } else if (!_bodyParts.rightElbow) {
                _bodyParts = _bodyParts.copyWith(leftElbow: false);
              } else if (!_bodyParts.rightUpperArm) {
                _bodyParts = _bodyParts.copyWith(leftUpperArm: false);
              } else if (!_bodyParts.rightShoulder) {
                _bodyParts = _bodyParts.copyWith(leftShoulder: false);
              }
            });

            // Print the selected body parts
            print(_bodyParts);
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
