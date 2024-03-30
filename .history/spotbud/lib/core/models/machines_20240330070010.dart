import 'package:flutter/material.dart';
import 'package:spotbud/ui/widgets/assets.dart';

class Machine {
  final String name;
  final String imagePath;
  final String bodyPart; // New field for body part

  Machine({
    required this.name,
    required this.imagePath,
    required this.bodyPart,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'bodyPart': bodyPart,
    };
  }
}

class MachineData {
  static List<Map<String, dynamic>> getMachines() {
    List<Machine> machines = [
      Machine(name: 'Squat Rack', imagePath: AppAssets.legs, bodyPart: 'Legs'),
      Machine(name: 'Leg Press', imagePath: AppAssets.legs, bodyPart: 'Legs'),
      Machine(name: 'Leg Curl', imagePath: AppAssets.legs, bodyPart: 'Legs'),
      Machine(
          name: 'Leg Extension', imagePath: AppAssets.legs, bodyPart: 'Legs'),
      Machine(
          name: 'Bench Press', imagePath: AppAssets.chest, bodyPart: 'Chest'),
      Machine(
          name: 'Dumbbell Press',
          imagePath: AppAssets.chest,
          bodyPart: 'Chest'),
      Machine(name: 'Chest Fly', imagePath: AppAssets.chest, bodyPart: 'Chest'),
      Machine(name: 'Push-up', imagePath: AppAssets.chest, bodyPart: 'Chest'),
      Machine(name: 'Deadlift', imagePath: AppAssets.back, bodyPart: 'Back'),
      Machine(name: 'Pull-up', imagePath: AppAssets.back, bodyPart: 'Back'),
      Machine(name: 'Seated Row', imagePath: AppAssets.back, bodyPart: 'Back'),
      Machine(
          name: 'Lat Pulldown', imagePath: AppAssets.back, bodyPart: 'Back'),
      Machine(
          name: 'Military Press',
          imagePath: AppAssets.shoulder,
          bodyPart: 'Shoulders'),
      Machine(
          name: 'Lateral Raise',
          imagePath: AppAssets.shoulder,
          bodyPart: 'Shoulders'),
      Machine(
          name: 'Front Raise',
          imagePath: AppAssets.shoulder,
          bodyPart: 'Shoulders'),
      Machine(
          name: 'Shrug', imagePath: AppAssets.shoulder, bodyPart: 'Shoulders'),
      Machine(name: 'Bicep Curl', imagePath: AppAssets.arms, bodyPart: 'Arms'),
      Machine(name: 'Tricep Dip', imagePath: AppAssets.arms, bodyPart: 'Arms'),
      Machine(name: 'Hammer Curl', imagePath: AppAssets.arms, bodyPart: 'Arms'),
      Machine(
          name: 'Skull Crusher', imagePath: AppAssets.arms, bodyPart: 'Arms'),
    ];
    return machines.map((machine) => machine.toMap()).toList();
  }
}
