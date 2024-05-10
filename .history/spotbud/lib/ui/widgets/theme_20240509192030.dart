import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:your_app/app_colors.dart'; // Import your custom colors

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  ThemeData get theme => isDarkMode.value ? darkTheme : lightTheme;

  ThemeData get darkTheme => ThemeData(
        primaryColor: AppColors.primaryColor,
        accentColor: AppColors.acccentColor,
        backgroundColor: AppColors.backgroundColor,
        scaffoldBackgroundColor: AppColors.bluebackgroundColor,
        // Add more dark mode specific colors and styles
      );

  ThemeData get lightTheme => ThemeData(
        primaryColor: Colors.blue, // Example light mode primary color
        accentColor: Colors.amber, // Example light mode accent color
        backgroundColor: Colors.white, // Example light mode background color
        scaffoldBackgroundColor:
            Colors.blue, // Example light mode scaffold background color
        // Add more light mode specific colors and styles
      );

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
