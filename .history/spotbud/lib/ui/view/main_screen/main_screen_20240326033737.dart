import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:spotbud/ui/view/main_screen/profile_view.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/view/main_screen/home_view.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  static List<Widget> _screens = [
    HomeView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _screens.elementAt(selectedIndex),
        ),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 90),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: GNav(
                curve: Curves.fastLinearToSlowEaseIn,
                gap: 10,
                padding: EdgeInsets.all(20),
                backgroundColor: AppColors.black,
                activeColor: AppColors.primaryColor,
                color: AppColors.black,
                hoverColor: AppColors.blue,
                tabBackgroundColor: AppColors.secondaryColor,
                mainAxisAlignment: MainAxisAlignment.center,
                selectedIndex: selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    selectedIndex = index;
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
            )));
  }
}
