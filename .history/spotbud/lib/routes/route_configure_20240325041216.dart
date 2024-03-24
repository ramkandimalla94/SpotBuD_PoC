import 'package:get/get.dart';
import 'package:spotbud/ui/view/auth/auth_login_view.dart';
import 'package:spotbud/ui/view/auth/auth_signup_view.dart';
import 'package:spotbud/ui/view/main_screen/bottom_navigation_bar_view.dart';
import 'package:spotbud/ui/view/main_screen/home_view.dart';
import 'package:spotbud/ui/view/main_screen/sprofile_view.dart';
import 'package:spotbud/ui/view/onboarding/name_view.dart';
import 'package:spotbud/ui/view/splash_screen/splash_screen.dart';
import 'package:spotbud/ui/view/trial.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
      name: '/',
      page: () => SplashScreen(),
    ),
    GetPage(
      name: '/trial',
      page: () => Trial(),
    ),
    GetPage(
      name: '/login',
      page: () => LoginView(),
    ),
    GetPage(
      name: '/signup',
      page: () => SignUpView(),
    ),
    GetPage(
      name: '/name',
      page: () => NameView(),
    ),
    GetPage(
      name: '/home',
      page: () => HomeView(),
    ),
    GetPage(
      name: '/navbar',
      page: () => CustomBottomNavigationBar(
        currentIndex: 0,
      ),
    ),
    GetPage(
      name: '/profile',
      page: () => ProfileView(),
    ),
    // GetPage(
    //   name: '/second_splash_view',
    //   page: () => const SecondSplashView(),
    // ),
  ];
}
