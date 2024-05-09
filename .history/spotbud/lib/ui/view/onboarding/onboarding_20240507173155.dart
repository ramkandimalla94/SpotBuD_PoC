import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

class Onboarding extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Buy & Sell',
      subTitle: 'Browse the menu and order directly from the application',
      imageUrl: AppAssets.tracker,
      titleTextStyle: TextStyle(
          color: AppColors.acccentColor,
          fontSize: 30,
          fontWeight: FontWeight.bold),
      subTitleTextStyle: TextStyle(color: AppColors.acccentColor),
      imageHeight: 400,
    ),
    Introduction(
      title: 'Delivery',
      subTitle: 'Your order will be immediately collected and',
      imageUrl: AppAssets.stats,
    ),
    Introduction(
      title: 'Receive Money',
      subTitle: 'Pick up delivery at your door and enjoy groceries',
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
