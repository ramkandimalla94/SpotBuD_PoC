import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

class Onboarding extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Welcome to SpotBuD',
      subTitle: 'Your Personal Gym Companion',
      imageUrl: AppAssets.tracker,
      titleTextStyle: TextStyle(
          color: AppColors.backgroundColor,
          fontSize: 30,
          fontWeight: FontWeight.bold),
      subTitleTextStyle: TextStyle(color: AppColors.acccentColor),
      imageHeight: 400,
    ),
    Introduction(
      title: 'Discover SpotBuD Features',
      subTitle: 'Empowering Your Fitness Journey',
      imageUrl: AppAssets.stats,
    ),
    Introduction(
      title: 'Get Started with SpotBuD',
      subTitle: 'Your Journey to Fitness Begins Here',
      imageUrl: AppAssets.activity,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      foregroundColor: AppColors.acccentColor,
      skipTextStyle: TextStyle(color: AppColors.acccentColor),
      backgroudColor: AppColors.primaryColor,

      introductionList: list,
      onTapSkipButton: () {
        Get.toNamed('/login');
      },
      // foregroundColor: Colors.red,
    );
  }
}
