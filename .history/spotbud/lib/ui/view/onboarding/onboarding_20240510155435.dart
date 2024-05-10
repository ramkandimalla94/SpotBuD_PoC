import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      foregroundColor: AppColors.acccentColor,
      skipTextStyle: TextStyle(color: AppColors.acccentColor, fontSize: 20),
      backgroudColor: AppColors.black,

      introductionList: list,
      onTapSkipButton: () {
        Get.toNamed('/login');
      },
      // foregroundColor: Colors.red,
    );
  }
}
