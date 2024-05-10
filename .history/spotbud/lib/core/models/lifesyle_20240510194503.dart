enum Lifestyle {
  Sedentary,
  LightlyActive,
  ModeratelyActive,
  VeryActive,
}

extension LifestyleExtension on Lifestyle {
  String get showtext {
    String text = this.toString().split('.').last;
    return text
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .trim();
  }

  String get displayText {
    return this.toString().splitMapJoin(RegExp(r'(?<=[a-z])[A-Z]'),
        onMatch: (m) => ' ${m.group(0)}', onNonMatch: (n) => n.toLowerCase());
  }
}
