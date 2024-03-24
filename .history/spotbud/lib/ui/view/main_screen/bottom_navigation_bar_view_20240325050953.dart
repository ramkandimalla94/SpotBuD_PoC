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
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 90),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: GNav(
            curve: Curves.fastLinearToSlowEaseIn,
            gap: 10,
            padding: EdgeInsets.all(20),
            // backgroundColor: AppColors.blue,
            activeColor: AppColors.primaryColor,
            color: AppColors.backgroundColor,
            hoverColor: AppColors.blue,
            tabBackgroundColor: AppColors.secondaryColor,
            mainAxisAlignment: MainAxisAlignment.center,
            selectedIndex: selectedIndex,
            onTabChange: (index) {
              setState(() {
                selectedIndex = index;
                if (selectedIndex == 0) {
                  Get.toNamed('/home');
                } else if (selectedIndex == 1) {
                  Get.toNamed('/profile');
                }
              });
            },
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
