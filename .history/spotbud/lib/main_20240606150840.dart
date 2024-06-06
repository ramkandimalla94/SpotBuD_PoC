import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final UserDataViewModel _userDataViewModel = Get.put(UserDataViewModel());

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Get.put(UserDataViewModel());
  Future<void> _getThemeStatus() async {
    final prefs = await _prefs;
    final isLight = prefs.getBool('theme') ?? true;
    _userDataViewModel.isLightTheme.value = isLight;
    Get.changeThemeMode(_userDataViewModel.isLightTheme.value
        ? ThemeMode.light
        : ThemeMode.dark);
  }

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

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _getThemeStatus() async {
    final prefs = await _prefs;
    final isLight = prefs.getBool('theme') ?? true;
    _userDataViewModel.isLightTheme.value = isLight;
    Get.changeThemeMode(_userDataViewModel.isLightTheme.value
        ? ThemeMode.light
        : ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    _getThemeStatus();
    //print(_userDataViewModel.isLightTheme);
    return Builder(
      builder: (context) {
        ScreenUtil.init(
          context,
          designSize: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
          ),
        );
        return BetterFeedback(
          theme: FeedbackThemeData(
            background: Colors.grey,
            feedbackSheetColor: Colors.grey[50]!,
            drawColors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
          ),
          localizationsDelegates: [
            GlobalFeedbackLocalizationsDelegate(),
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            Global
          ],
          localeOverride: const Locale('en'),
          child: GetMaterialApp(
            theme: _lightTheme,
            darkTheme: _darkTheme,
            themeMode: ThemeMode.dark,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            unknownRoute: GetPage(
                name: '/route_error', page: () => const RouteErrorView()),
            getPages: AppRoutes.pages,
          ),
        );
      },
    );
  }
}
