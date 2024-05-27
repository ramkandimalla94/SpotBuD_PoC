import 'package:flutter/material.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';

class MyTrainee extends StatelessWidget {
  const MyTrainee({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Trainer's Zone",
          style: AppTheme.primaryText(
            size: 27,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: AppColors.black, // Adjust the back button color here
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
