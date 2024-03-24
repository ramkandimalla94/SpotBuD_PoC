import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/main_screen/home_view.dart';
import 'package:spotbud/ui/view/main_screen/sprofile_view.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int selectedIndex = 0;
  final List<Widget> screens = [
    HomeView(),
    ProfileView(),
  ];
  late Widget currentScreen;

  @override
  void initState() {
    super.initState();
    currentScreen = HomeView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20.h), // Adjust bottom padding
        child: GNav(
          gap: 10, // Gap between items
          color: Colors.grey[800], // Item color
          activeColor: AppColors.primaryColor, // Active item color
          iconSize: 24, // Icon size
          padding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h), // Padding
          duration: Duration(milliseconds: 400), // Animation duration
          tabBackgroundColor: AppColors.secondaryColor, // Background color
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
          selectedIndex: selectedIndex,
          onTabChange: (index) {
            setState(() {
              selectedIndex = index;
              currentScreen = screens[index];
            });
          },
        ),
      ),
    );
  }
}
