import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/main_screen/home_view.dart';
import 'package:spotbud/ui/view/main_screen/sprofile_view.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

class MainNavigationBarView extends StatefulWidget {
  const MainNavigationBarView({super.key});

  @override
  _MainNavigationBarViewState createState() => _MainNavigationBarViewState();
}

class _MainNavigationBarViewState extends State<MainNavigationBarView> {
  int selectedIndex = 0;
  final List<Widget> screens = [
    HomeView(),
    ProfileView(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const MainHomeView();

  @override
  void initState() {
    super.initState();
    currentScreen = const MainHomeView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.search),
      //   onPressed: () {
      //     // Get.toNamed('/search');
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildNavBarItem(Icons.home, "home".tr, 0),
              buildNavBarItem(Icons.cleaning_services, "service".tr, 1),
              buildNavBarItem(Icons.shopping_basket_outlined, "shop".tr, 2),
              buildNavBarItem(Icons.account_circle, "account".tr, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, String text, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedIndex = index;
          currentScreen = screens[index];
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: SizedBox(
        height: 60.h,
        //width: 50.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: selectedIndex == index
                  ? AppColors.secondaryColor
                  : AppColors.primaryColor,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: selectedIndex == index
                    ? AppColors.secondaryColor
                    : AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
