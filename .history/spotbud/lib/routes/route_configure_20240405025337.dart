import 'package:get/get.dart';
import 'package:spotbud/ui/view/auth/auth_login_view.dart';
import 'package:spotbud/ui/view/auth/auth_signup_view.dart';
import 'package:spotbud/ui/view/history/history_view.dart';
import 'package:spotbud/ui/view/log_workout/body_part_view.dart';
import 'package:spotbud/ui/view/log_workout/machine_selection_view.dart';
import 'package:spotbud/ui/view/log_workout/work_out_form.dart';
import 'package:spotbud/ui/view/main_screen/home_view.dart';
import 'package:spotbud/ui/view/main_screen/main_screen.dart';
import 'package:spotbud/ui/view/main_screen/profile_view.dart';
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
      name: '/home',
      page: () => HomeView(),
    ),

    GetPage(
      name: '/profile',
      page: () => ProfileView(),
    ),
    GetPage(
      name: '/mainscreen',
      page: () => MainScreen(),
    ),
    GetPage(
      name: '/bodypart',
      page: () => BodyPartSelectionScreen(),
    ),
    GetPage(
      name: '/history',
      page: () => HistoryPage(),
    ),
    GetPage(
      name: '/log',
      page: MachineSelectionScreen(
        bodyPart: '',
      ),
    )

    // GetPage(
    //   name: '/second_splash_view',
    //   page: () => const SecondSplashView(),
    // ),
  ];
}
