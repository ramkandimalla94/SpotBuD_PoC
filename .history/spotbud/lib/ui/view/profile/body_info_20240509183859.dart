import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';

class BodyInfo extends StatelessWidget {
  const BodyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Body Details",
          style: AppTheme.primaryText(
            size: 32,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/bodydetail');
            },
            icon: const Icon(
              Icons.edit,
              color: AppColors.black,
            ),
          )
        ],
        centerTitle: true,
        backgroundColor: AppColors.acccentColor,
      ),
      backgroundColor: AppColors.black,
    );
  }
}
