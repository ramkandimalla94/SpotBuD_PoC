import 'package:flutter/material.dart';
import 'package:spotbud/ui/widgets/assets.dart';

class Machine {
  final String name;
  final String imagePath;

  Machine({required this.name, required this.imagePath});
}

class MachineData {
  static List<Machine> getMachines() {
    return [
      Machine(name: 'Squat Rack', imagePath: AppAssets.legs),
      Machine(name: 'Leg Press', imagePath: AppAssets.legs),
      Machine(name: 'Leg Curl', imagePath: AppAssets.legs),
      Machine(name: 'Leg Extension', imagePath: AppAssets.legs),
      Machine(name: 'Bench Press', imagePath: AppAssets.chest),
      Machine(name: 'Dumbbell Press', imagePath: AppAssets.chest),
      Machine(name: 'Chest Fly', imagePath: AppAssets.chest),
      Machine(name: 'Push-up', imagePath: AppAssets.chest),
      Machine(name: 'Deadlift', imagePath: AppAssets.back),
      Machine(name: 'Pull-up', imagePath: AppAssets.back),
      Machine(name: 'Seated Row', imagePath: AppAssets.back),
      Machine(name: 'Lat Pulldown', imagePath: AppAssets.back),
      Machine(name: 'Military Press', imagePath: AppAssets.shoulder),
      Machine(name: 'Lateral Raise', imagePath: AppAssets.shoulder),
      Machine(name: 'Front Raise', imagePath: AppAssets.shoulder),
      Machine(name: 'Shrug', imagePath: AppAssets.shoulder),
      Machine(name: 'Bicep Curl', imagePath: AppAssets.arms),
      Machine(name: 'Tricep Dip', imagePath: AppAssets.arms),
      Machine(name: 'Hammer Curl', imagePath: AppAssets.arms),
      Machine(name: 'Skull Crusher', imagePath: AppAssets.arms),
    ];
  }
}
