import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotbud/firebase_options.dart';
import 'package:spotbud/routes/route_configure.dart';
import 'package:spotbud/routes/route_error.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

Future<void> main() async {
  @override
  void initState() {
    _loadThemeStatus();
  }

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(UserDataViewModel());
  runApp(MyApp());
}

ThemeData _darkTheme = ThemeData(
  hintColor: AppColors.secondaryColor,
  colorScheme: const ColorScheme.dark(
      background: AppColors.black,
      primary: AppColors.acccentColor,
      secondary: AppColors.backgroundColor),
  focusColor: AppColors.lightacccentColor,
  brightness: Brightness.dark,
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.amber,
    disabledColor: Colors.grey,
  ),
);

ThemeData _lightTheme = ThemeData(
    hintColor: AppColors.black,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        background: AppColors.backgroundColor,
        primary: AppColors.lightacccentColor,
        secondary: AppColors.black),
    focusColor: AppColors.acccentColor,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blue,
      disabledColor: Colors.grey,
    ));

class MyApp extends StatelessWidget {
  final UserDataViewModel _userDataViewModel = Get.put(UserDataViewModel());

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _getThemeStatus() async {
    var _isLight = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('theme') != null ? prefs.getBool('theme') : true;
    }).obs;
    _userDataViewModel.isLightTheme.value = (await _isLight.value)!;
    Get.changeThemeMode(_userDataViewModel.isLightTheme.value
        ? ThemeMode.light
        : ThemeMode.dark);
  }

  MyApp() {
    _getThemeStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        ScreenUtil.init(
          context,
          designSize: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
          ),
        );
        return GetMaterialApp(
          theme: _lightTheme,
          darkTheme: _darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          unknownRoute:
              GetPage(name: '/route_error', page: () => const RouteErrorView()),
          getPages: AppRoutes.pages,
        );
      },
    );
  }
}