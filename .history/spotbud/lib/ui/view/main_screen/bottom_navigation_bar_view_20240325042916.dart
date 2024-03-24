import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/main_screen/home_view.dart';
import 'package:spotbud/ui/view/main_screen/sprofile_view.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

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
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeView();

  @override
  void initState() {
    super.initState();
    currentScreen = HomeView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make the scaffold transparent
      body: PageStorage(bucket: bucket, child: currentScreen),
      bottomNavigationBar: BottomAppBar(
        elevation: 0, // Remove the elevation
        color: Colors.transparent, // Make the background transparent
        child: Container(
          height: 60.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: AppColors.primaryColor, // Set a custom background color
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildNavBarItem(Icons.home, 'Home', 0),
              buildNavBarItem(Icons.person, 'Profile', 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          currentScreen = screens[index];
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), // Rounded corners
          color: selectedIndex == index
              ? AppColors.secondaryColor // Selected item color
              : Colors
                  .transparent, // Transparent background for non-selected items
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selectedIndex == index
                  ? AppColors.primaryColor // Selected icon color
                  : Colors.white, // Non-selected icon color
            ),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: selectedIndex == index
                    ? AppColors.primaryColor // Selected text color
                    : Colors.white, // Non-selected text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
