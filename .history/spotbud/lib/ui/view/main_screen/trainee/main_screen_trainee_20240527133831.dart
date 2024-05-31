import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:spotbud/ui/view/main_screen/profile_view.dart';
import 'package:spotbud/ui/view/trainee/mytrainer.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/view/main_screen/home_view.dart';

class MainScreenTrainee extends StatefulWidget {
  @override
  _MainScreenTraineeState createState() => _MainScreenTraineeState();
}

class _MainScreenTraineeState extends State<MainScreenTrainee> {
  int selectedIndex = 0;

  static List<Widget> _screens = [
    HomeView(),
    ProfileView(),
    MyTrainer(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
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
                backgroundColor: Theme.of(context).colorScheme.background,
                activeColor: Theme.of(context).colorScheme.background,
                color: Theme.of(context).colorScheme.secondary,
                hoverColor: Theme.of(context).colorScheme.background,
                tabBackgroundColor: AppColors.acccentColor,
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
                  GButton(
                    icon: Icons.person,
                    text: "My Trainer",
                  ),
                ],
              ),
            )));
  }
}
