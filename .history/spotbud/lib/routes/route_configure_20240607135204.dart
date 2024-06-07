import 'package:get/get.dart';
import 'package:spotbud/ui/view/auth/auth_login_view.dart';
import 'package:spotbud/ui/view/auth/auth_signup_view.dart';
import 'package:spotbud/ui/view/auth/auth_verification.dart';
import 'package:spotbud/ui/view/history/history_view.dart';
import 'package:spotbud/ui/view/workout_logging/work_out_form.dart';
import 'package:spotbud/ui/view/main_screen/screens/home_view.dart';
import 'package:spotbud/ui/view/main_screen/main_screen.dart';
import 'package:spotbud/ui/view/body_details_profile/body_info.dart';
import 'package:spotbud/ui/view/main_screen/screens/profile_view.dart';
import 'package:spotbud/ui/view/onboarding/body_details.dart';
import 'package:spotbud/ui/view/onboarding/role.dart';
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
      name: '/history',
      page: () => HistoryView(),
    ),
    GetPage(
      name: '/bodydetail',
      page: () => UserInfoPage(),
    ),
    GetPage(
      name: '/authbodydetail',
      page: () => UserInfoPage(),
    ),
    GetPage(
      name: '/logworkout',
      page: () => WorkoutLoggingForm(),
    ),
    GetPage(
      name: '/verify',
      page: () => VerifyScreen(),
    ),
    GetPage(
      name: '/bodyinfo',
      page: () => BodyInfo(),
    ),
    GetPage(
      name: '/role',
      page: () => RoleSelectionScreen(),
    ),
  ];
}