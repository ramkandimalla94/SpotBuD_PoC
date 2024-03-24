import 'package:flutter/material.dart';
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

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  int selectedIndex = 0;
  final List<Widget> screens = [
    HomeView(),
    ProfileView(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  late Widget currentScreen;

  @override
  void initState() {
    super.initState();
    currentScreen = screens[0];

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        color: AppColors.primaryColor,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 70.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              icon,
              color: selectedIndex == index
                  ? Colors.white
                  : AppColors.secondaryColor,
              size: 30.sp,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: selectedIndex == index
                  ? Colors.white
                  : AppColors.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
