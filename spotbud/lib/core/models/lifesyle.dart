enum Lifestyle {
  Sedentary,
  LightlyActive,
  ModeratelyActive,
  VeryActive,
}

extension LifestyleExtension on Lifestyle {
  String get displayText {
    return this.toString().splitMapJoin(RegExp(r'(?<=[a-z])[A-Z]'),
        onMatch: (m) => ' ${m.group(0)}', onNonMatch: (n) => n.toLowerCase());
  }
}
