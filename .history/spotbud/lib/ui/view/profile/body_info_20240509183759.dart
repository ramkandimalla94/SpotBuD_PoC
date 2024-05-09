import 'package:flutter/material.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';

class BodyInfo extends StatelessWidget {
  const BodyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: AppTheme.primaryText(
            size: 32,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: AppColors.black,
    );
  }
}
