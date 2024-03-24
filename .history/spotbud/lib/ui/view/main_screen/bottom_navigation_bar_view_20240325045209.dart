import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 90),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30), // Set circular border radius
          child: GNav(
            onTabChange: ,
            gap: 10,
            padding: EdgeInsets.all(20),
            backgroundColor: AppColors.black,
            activeColor: AppColors.primaryColor,
            color: AppColors.backgroundColor,
            hoverColor: AppColors.blue,
            tabBackgroundColor: AppColors.secondaryColor,
            mainAxisAlignment: MainAxisAlignment.center,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                icon: Icons.person,
                text: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
