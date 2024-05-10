enum Lifestyle {
  Sedentary,
  LightlyActive,
  ModeratelyActive,
  VeryActive,
}

extension LifestyleExtension on Lifestyle {
  String get showtext {
    String text = this.toString().split('.').last;
    return text[0].toUpperCase() + text.substring(1);
  }

  String get displayText {
    return this.toString().splitMapJoin(RegExp(r'(?<=[a-z])[A-Z]'),
        onMatch: (m) => ' ${m.group(0)}', onNonMatch: (n) => n.toLowerCase());
  }
}
