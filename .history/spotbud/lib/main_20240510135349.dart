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
import 'package:spotbud/ui/widgets/theme.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(UserDataViewModel());
  runApp(MyApp());
}

final Color _lightFocusColor = Colors.black.withOpacity(0.12);
final Color _darkFocusColor = Colors.white.withOpacity(0.12);
ColorScheme lightColorScheme = ColorScheme(
  primary: Color(0xFFB93C5D),
  onPrimary: Colors.black,
  secondary: Color(0xFFEFF3F3),
  onSecondary: Color(0xFF322942),
  error: Colors.redAccent,
  onError: Colors.white,
  background: Color(0xFFE6EBEB),
  onBackground: Colors.white,
  surface: Color(0xFFFAFBFB),
  onSurface: Color(0xFF241E30),
  brightness: Brightness.light,
);
const ColorScheme darkColorScheme = ColorScheme(
  primary: Color(0xFFFF8383),
  secondary: Color(0xFF4D1F7C),
  background: Color(0xFF241E30),
  surface: Color(0xFF1F1929),
  onBackground: Color(0x0DFFFFFF),
  error: Colors.redAccent,
  onError: Colors.white,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  brightness: Brightness.dark,
);

ThemeData lightThemeData = themeData(lightColorScheme, _lightFocusColor);
ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);
ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
  return ThemeData(
      colorScheme: colorScheme,
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      focusColor: focusColor);
}

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
          themeMode: ThemeMode.system,
          darkTheme: _darkTheme,
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