import 'package:get/get.dart';
import 'package:spotbud/ui/view/splash_screen/splash_scree.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
      name: '/',
      page: () => const SplashScreen(),
    ),
    // GetPage(
    //   name: '/second_splash_view',
    //   page: () => const SecondSplashView(),
    // ),
  ];
}
