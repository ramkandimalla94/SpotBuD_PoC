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
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2, // Add letter spacing for better readability
        shadows: [
          Shadow(
            color:
                AppColors.acccentColor.withOpacity(0.3), // Add shadow for depth
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      subTitleTextStyle: TextStyle(
        color: AppColors.acccentColor,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8, // Add slight letter spacing
        shadows: [
          Shadow(
            color: Colors.white.withOpacity(0.3), // Add shadow for depth
            offset: Offset(1, 1),
            blurRadius: 2,
          ),
        ],
      ),
      imageHeight: 400,
    ),
    Introduction(
      title: 'Discover',
      subTitle: 'Amazing Features that Empower Your Fitness Journey',
      imageUrl: AppAssets.stats,
      titleTextStyle: TextStyle(
        color: AppColors.backgroundColor,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2, // Add letter spacing for better readability
        shadows: [
          Shadow(
            color:
                AppColors.acccentColor.withOpacity(0.3), // Add shadow for depth
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      subTitleTextStyle: TextStyle(
        color: AppColors.acccentColor,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8, // Add slight letter spacing
        shadows: [
          Shadow(
            color: Colors.white.withOpacity(0.3), // Add shadow for depth
            offset: Offset(1, 1),
            blurRadius: 2,
          ),
        ],
      ),
      imageHeight: 380,
    ),
    Introduction(
      title: 'Get Started with SpotBuD',
      subTitle: 'Your Journey to Fitness Begins Here',
      imageUrl: AppAssets.activity,
      titleTextStyle: TextStyle(
        color: AppColors.backgroundColor,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2, // Add letter spacing for better readability
        shadows: [
          Shadow(
            color:
                AppColors.acccentColor.withOpacity(0.3), // Add shadow for depth
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      subTitleTextStyle: TextStyle(
        color: AppColors.acccentColor,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8, // Add slight letter spacing
        shadows: [
          Shadow(
            color: Colors.white.withOpacity(0.3), // Add shadow for depth
            offset: Offset(1, 1),
            blurRadius: 2,
          ),
        ],
      ),
      imageHeight: 400,
    ),
  ];

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
