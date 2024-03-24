import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';=

class AppTheme {
  static TextStyle customTextStyle(
      {String fontFamily = 'Roboto',
      FontWeight fontWeight = FontWeight.w200,
      Color color = AppColors.primaryColor,
      double size = 28,
      bool underline = false,
      double height = 0.0,
      double letterSpacing = 0.0}) {
    return TextStyle(
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        color: color,
        fontSize: size.sp,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
        height: height.h,
        letterSpacing: letterSpacing.w);
  }
}




//   // Customized usage
//   TextStyle customizedTextStyle = AppTheme.customTextStyle(
//     fontFamily: 'Arial',
//     fontWeight: FontWeight.w600,
//     color: Colors.blue,
//     size: 18,
//     underline: true,